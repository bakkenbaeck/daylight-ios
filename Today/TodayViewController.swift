//
//  TodayViewController.swift
//  Today
//
//  Created by Dylan Marriott on 18/02/17.
//

import CoreLocation
import NotificationCenter
import UIKit

@objc(TodayViewController)

class TodayViewController: UIViewController, NCWidgetProviding {

    private lazy var locationTracker: LocationTracker = {
        let tracker = LocationTracker()
        tracker.delegate = self
        return tracker
    }()

    override func loadView() {
        let view = TodayView(frame: UIScreen.main.bounds)
        self.view = view
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationTracker.locateIfPossible()
    }

    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        (self.view as! TodayView).updateView()
        completionHandler(NCUpdateResult.newData)
    }
}

extension TodayViewController: LocationTrackerDelegate {

    func locationTracker(_ locationTracker: LocationTracker, didFailWith error: Error) {
        // ignore errors in the widget
    }

    func locationTracker(_ locationTracker: LocationTracker, didFindLocation placemark: CLPlacemark) {
//        Location.current = Location(placemark: placemark)
        (self.view as! TodayView).updateView()
    }
}
