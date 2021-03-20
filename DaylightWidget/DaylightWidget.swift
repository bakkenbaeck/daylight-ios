//
//  DaylightWidget.swift
//  DaylightWidget
//
//  Created by Wesley Cheung on 04/11/2020.
//

import WidgetKit
import SwiftUI
import CoreLocation

struct Provider: TimelineProvider {
    var widgetLocationManager = WidgetLocationManager()

    
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
            self.widgetLocationManager.fetchCityAndCountry(from: location) { city, country, error in
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
//        case .systemLarge:
//            WidgetSunView(entry: entry)
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
            DaylightWidgetEntryView(entry: daylightEntry).previewContext(WidgetPreviewContext(family: .systemSmall))
            DaylightWidgetEntryView(entry: daylightEntry).previewContext(WidgetPreviewContext(family: .systemMedium))
//            DaylightWidgetEntryView(entry: daylightEntry).previewContext(WidgetPreviewContext(family: .systemLarge))
        }
    }
}
