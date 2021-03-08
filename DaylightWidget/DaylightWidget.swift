//
//  DaylightWidget.swift
//  DaylightWidget
//
//  Created by Wesley Cheung on 04/11/2020.
//

import WidgetKit
import SwiftUI
import CoreLocation

extension View {
    
    /// Hide or show the view based on a boolean value.
    ///
    /// Example for visibility:
    ///
    ///     Text("Label")
    ///         .isHidden(true)
    ///
    /// Example for complete removal:
    ///
    ///     Text("Label")
    ///         .isHidden(true, remove: true)
    ///
    /// - Parameters:
    ///   - hidden: Set to `false` to show the view. Set to `true` to hide the view.
    ///   - remove: Boolean value indicating whether or not to remove the view.
    @ViewBuilder func isHidden(_ hidden: Bool, remove: Bool = false) -> some View {
        if hidden {
            if !remove {
                self.hidden()
            }
        } else {
            self
        }
    }
}

class WidgetLocationManager: NSObject, CLLocationManagerDelegate {
    var locationManager: CLLocationManager? {
        didSet {
            self.locationManager!.delegate = self
        }
    }
    private var handler: ((CLLocation) -> Void)?
    func fetchLocation(handler: @escaping (CLLocation) -> Void) {
        self.handler = handler
        self.locationManager!.requestLocation()
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.handler!(locations.last!)
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

struct Provider: TimelineProvider {
    var widgetLocationManager = WidgetLocationManager()

    func fetchCityAndCountry(from location: CLLocation, completion: @escaping (_ city: String?, _ country:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            completion(placemarks?.first?.locality,
                       placemarks?.first?.country,
                       error)
        }
    }
    
    func placeholder(in context: Context) -> SimpleEntry {
        let location = Location(coordinate: CLLocationCoordinate2D(latitude: 59.8937806, longitude: 10.6450379), city: "Oslo", country: "Norway")
        let controller = DaylightModelController(location: location)
        
        return SimpleEntry(date: Date(), daylightController: controller)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let location = Location(coordinate: CLLocationCoordinate2D(latitude: 59.8937806, longitude: 10.6450379), city: "Oslo", country: "Norway")
        let controller = DaylightModelController(location: location)
        let entry = SimpleEntry(date: Date(), daylightController: controller)
        completion(entry)
    }
    

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        let currentDate = Date()
        if widgetLocationManager.locationManager == nil {
            widgetLocationManager.locationManager = CLLocationManager()
            widgetLocationManager.locationManager!.requestWhenInUseAuthorization()
        }
        
        widgetLocationManager.fetchLocation(handler: { location in
            fetchCityAndCountry(from: location) { city, country, error in
                guard let city = city, let country = country, error == nil else { return }
                
                let getLocation = Location(coordinate: location.coordinate, city: city, country: country)
                           
                
                let refreshDate = Calendar.current.date(byAdding: .minute, value: 1, to: currentDate)!
                            
                let controller = DaylightModelController(location: getLocation)
                
                let entry = SimpleEntry(date: currentDate, daylightController: controller)
                let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
                
                completion(timeline)
           }
        })
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let daylightController: DaylightModelController
    
}

private func color(for sunPhase: SunTime.SunPhase) -> UIColor {
    if sunPhase == .night || sunPhase == .predawn {
        // Theme.nightText is a bit too bright on the light background of the widget
        // Let's just use twiligtText color here, it fits well for the night too :)
        return Theme.twilightText
    } else {
        return Theme.colors(for: sunPhase).textColor
    }
}


struct WidgetSunView: View {
    var entry: Provider.Entry
    let sunSize = CGFloat(12.0)
    
    func location(for percentageInDay: CGFloat, width: CGFloat, height: CGFloat) -> SunViewLocation {
        let position = CGFloat.pi + (percentageInDay * CGFloat.pi)
        let x = 50.0 + cos(position) * 50.0
        let y = abs(sin(position) * 100.0)
        let absoluteX = ((width - sunSize) / 100) * x
        let absoluteY = -(height / 100.0) * y + sunSize

        print("printing absolute")
        print("percentageInDay", percentageInDay)
        print("position", position)
        print(absoluteX)
        print(absoluteY)
        
        return SunViewLocation(x: absoluteX, y: absoluteY)
    }
        
    var sunViewLeftAnchor: NSLayoutConstraint?
    var sunViewBottomAnchor: NSLayoutConstraint?
    
    
    var body: some View {
        ZStack {
            Color(entry.daylightController.primaryColor).ignoresSafeArea()
            
            GeometryReader { geo in
                let sun = Image(uiImage: UIImage(named: "sun")!.withRenderingMode(.alwaysTemplate)).resizable().frame(width: sunSize, height: sunSize, alignment: .center)
                
                let moon = Image(uiImage: UIImage(named: "moon")!.withRenderingMode(.alwaysTemplate)).resizable().frame(width: sunSize * 0.5, height: sunSize, alignment: .leading)
                
                let sunLocation = location(for: entry.daylightController.percentageInDay, width: geo.size.width, height: geo.size.height)
                
                sun.position(x: sunLocation.x, y: sunLocation.y).foregroundColor(Color(entry.daylightController.secondaryColor)).isHidden(entry.daylightController.shouldShowMoon)
                
                moon.position(x: sunLocation.x, y: sunLocation.y).foregroundColor(Color(entry.daylightController.secondaryColor)).isHidden(!entry.daylightController.shouldShowMoon)
            }
        }
    }
}


struct DaylightWidgetEntryView : View {
    @Environment(\.widgetFamily) var family

    var entry: Provider.Entry
    
    @ViewBuilder
    var body: some View {
        switch family {
        case .systemSmall:
            WidgetTextView(entry: entry)
        case .systemMedium:
            WidgetTextView(entry: entry)
        case .systemLarge:
            WidgetSunView(entry: entry)
        default:
            WidgetTextView(entry: entry)
        }
    }
}

@main
struct DaylightWidget: Widget {
    let kind: String = "DaylightWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            DaylightWidgetEntryView(entry: entry)
        }
        .supportedFamilies([.systemSmall, .systemMedium])
//        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
        .configurationDisplayName("Daylight")
        .description("The perfect assistant for the long and dark winters of the north.")
    }
}

struct DaylightWidget_Previews: PreviewProvider {
    static var previews: some View {
        let location = Location(coordinate: CLLocationCoordinate2D(latitude: 59.8937806, longitude: 10.6450379), city: "Oslo", country: "Norway")
        let controller = DaylightModelController(location: location)
        let daylightEntry = SimpleEntry(date: Date(), daylightController: controller)
        
        Group{
//            DaylightWidgetEntryView(entry: daylightEntry).previewContext(WidgetPreviewContext(family: .systemSmall))
//            DaylightWidgetEntryView(entry: daylightEntry).previewContext(WidgetPreviewContext(family: .systemMedium))
            DaylightWidgetEntryView(entry: daylightEntry).previewContext(WidgetPreviewContext(family: .systemLarge))
        }
    }
}
