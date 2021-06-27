//
//  WidgetTextView.swift
//  DaylightWidgetExtension
//
//  Created by Wesley Cheung on 08/03/2021.
//

import SwiftUI

// View for showing weather message and country
struct WidgetTextView: View {
    var entry: Provider.Entry
    
    var body: some View {
        ZStack {
            Color(entry.daylightController.primaryColor).ignoresSafeArea()
            
            VStack(alignment: .center, spacing: 12, content: {
                Text(entry.daylightController.stringMessage ?? "")
                    .multilineTextAlignment(.center)
                    .font(Font(Theme.light(size: 15)))
                
                Text(entry.daylightController.locationLabel)
                    .font(Font(Theme.light(size: 12)))
            }).padding(.horizontal).foregroundColor(Color(entry.daylightController.secondaryColor))
        }
    }
}
