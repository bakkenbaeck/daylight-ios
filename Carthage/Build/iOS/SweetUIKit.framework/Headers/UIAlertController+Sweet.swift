import UIKit

public extension UIAlertController {

    /**
     Creates a dismissable alert controller.
     - parameter title: The title.
     - parameter message: The message.
     - returns: The alert controller.
     */
    public static func dismissableAlert(title: String, message: String? = nil) -> UIAlertController {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: NSLocalizedString("Dismiss", comment: ""), style: .cancel, handler: nil))

        return controller
    }

    /**
     Creates a alert controller configurated for destructive confirmations.
     - parameter title: The title.
     - parameter message: The message.
     - parameter destructiveActionTitle: The title for the destructive button.
     - parameter destructiveBlock: The block to be run when the destructive action gets triggered.
     - returns: The alert controller.
     */
    public static func destructiveConfirmationAlert(title: String? = nil, message: String, destructiveActionTitle: String? = nil, destructiveBlock: (() -> Void)? = nil) -> UIAlertController {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil))

        if let destructiveBlock = destructiveBlock {
            controller.addAction(UIAlertAction(title: destructiveActionTitle ?? NSLocalizedString("Delete", comment: ""), style: .destructive, handler: { _ in
                destructiveBlock()
            }))
        }

        return controller
    }

    /**
     Creates an alert controller to display an error.
     - parameter error: The error.
     - returns: The alert controller.
     */
    public static func errorAlert(_ error: NSError) -> UIAlertController {
        let controller = UIAlertController(title: NSLocalizedString("Oops, something went wrong", comment: ""), message: error.localizedDescription, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: NSLocalizedString("Dismiss", comment: ""), style: .cancel, handler: nil))

        return controller
    }

    /**
     Creates an alert controller to be displayed for tasks that block the UI or require you to wait for a response.
     - parameter title: The title.
     - returns: The alert controller.
     */
    public static func progressAlert(_ title: String) -> UIAlertController {
        let controller = UIAlertController(title: title + "\n\n", message: nil, preferredStyle: .alert)
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
        indicator.color = UIColor.gray
        indicator.center = CGPoint(x: 135, y: 65.5)
        indicator.startAnimating()
        controller.view.addSubview(indicator)

        return controller
    }
}
