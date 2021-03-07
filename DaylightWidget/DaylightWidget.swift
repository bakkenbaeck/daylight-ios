//
//  DaylightWidget.swift
//  DaylightWidget
//
//  Created by Wesley Cheung on 04/11/2020.
//

import WidgetKit
import SwiftUI
import CoreLocation

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
//
//    func location(for percentageInDay: CGFloat) -> SunViewLocation {
//        let position = CGFloat.pi + (percentageInDay * CGFloat.pi)
//        let x = 50.0 + cos(position) * 50.0
//        let y = abs(sin(position) * 100.0)
//        let absoluteX = ((self.bounds.width - SunView.sunSize) / 100) * x
//        let absoluteY = -(self.aboveHorizonLayoutView.frame.height / 100.0) * y + SunView.sunSize
//
//        return SunViewLocation(x: absoluteX, y: absoluteY)
//    }
//    
    let sunSize = CGFloat(12.0)
//    var sunViewLocation = location(for: daylightController.percentageInDay)
    
    var sunViewLeftAnchor: NSLayoutConstraint?
    var sunViewBottomAnchor: NSLayoutConstraint?
    
    
    var body: some View {
        let sun = Image(uiImage: UIImage(named: "sun")!.withRenderingMode(.alwaysTemplate)).resizable().frame(width: sunSize, height: sunSize, alignment: .center)
        
        let moon = Image(uiImage: UIImage(named: "moon")!.withRenderingMode(.alwaysTemplate)).resizable().frame(width: sunSize * 0.5, height: sunSize, alignment: .leading)
        
//        Text("hello")
        VStack(alignment: .center, spacing: 12, content: {
            sun
            moon
        })
    }
}

// View for showing weather message and country
struct WidgetTextView: View {
    var entry: Provider.Entry
    
    var body: some View {
        ZStack {
            Color(entry.daylightController.primaryColor).ignoresSafeArea()
            
            VStack(alignment: .center, spacing: 12, content: {
                Text(entry.daylightController.stringMessage!).multilineTextAlignment(.center).font(Font(Theme.light(size: 15)))
                Text(entry.daylightController.locationLabel).font(Font(Theme.light(size: 12)))
            }).padding(.horizontal).foregroundColor(Color(entry.daylightController.secondaryColor))
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
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
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
