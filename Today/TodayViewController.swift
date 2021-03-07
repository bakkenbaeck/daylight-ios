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
    private var daylightController: DaylightModelController? {
        didSet {
            guard let daylightController = self.daylightController else { return }
            (self.view as! TodayView).updateView(with: daylightController)
        }
    }

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
        guard let daylightController = self.daylightController else { return }

        (self.view as! TodayView).updateView(with: daylightController)
        completionHandler(NCUpdateResult.newData)
    }
}

extension TodayViewController: LocationTrackerDelegate {

    func didFailWithError(_ error: Error, on locationTracker: LocationTracker) {
        // ignore errors in the widget
    }

    func didFindLocation(_ placemark: CLPlacemark, on locationTracker: LocationTracker) {
        guard let location = Location(placemark: placemark) else { return }
        self.daylightController = DaylightModelController(location: location)
    }

    func didUpdateAuthorizationStatus(_ authorizationStatus: CLAuthorizationStatus, on locationTracker: LocationTracker) {

    }
}
