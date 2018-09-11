import CoreLocation
import UIKit

protocol OnboardingViewDelegate: class {
    func didRequestToLocateIfPossible(on controller: OnboardingView)
    func didRequestToSkipNotifications(on controller: OnboardingView)
    func didRequestToRegisterForNotifications(on controller: OnboardingView)
}

class OnboardingView: UIView {

    enum OnboardingState {
        case location
        case notification
        case denied
    }

    weak var delegate: OnboardingViewDelegate?

    var onboardingState: OnboardingState = .denied {
        didSet {
            switch onboardingState {
            case .location:
                self.setLocationUndetermined()
            case .notification:
                self.setNotificationUndetermined()
            case .denied:
                self.setLocationDisabled()
            }
        }
    }


    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = Theme.light(size: 32)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = true

        return label
    }()

    lazy var button: UIButton = {
        let button = UIButton()

        button.titleLabel?.font = Theme.light(size: 16)
        button.setTitleColor(Theme.daylightText.withAlphaComponent(0.6), for: .normal)
        button.contentHorizontalAlignment = .left
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didSelectButton), for: .touchUpInside)

        return button
    }()

    lazy var tapGestureRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer()
        recognizer.addTarget(self, action: #selector(self.didTapScreen))

        return recognizer
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.addSubviewsAndConstraints()

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubviewsAndConstraints() {
        self.addSubview(self.titleLabel)
        self.addSubview(self.button)

        self.titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: (2 * -Theme.insets.bottom)).isActive = true
        self.titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: Theme.insets.left).isActive = true
        self.titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -Theme.insets.right).isActive = true
        self.titleLabel.heightAnchor.constraint(equalToConstant: self.titleLabel.height())

        self.titleLabel.addGestureRecognizer(self.tapGestureRecognizer)

        let rightInset = CGFloat(-10)
        self.button.heightAnchor.constraint(equalToConstant: 20).isActive = true

        self.button.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -Theme.insets.top).isActive = true
        self.button.leftAnchor.constraint(equalTo: self.leftAnchor, constant: Theme.insets.left).isActive = true
        self.button.rightAnchor.constraint(equalTo: self.rightAnchor, constant: rightInset).isActive = true
    }

    func setLocationUndetermined() {
        self.backgroundColor = Theme.daylightBackground

        let text = NSLocalizedString("Hi! Daylight uses your location to give you accurate daylight information.", comment: "")

        UIView.animate(withDuration: 0.2) {
            self.titleLabel.attributedText = text.attributedMessageString(textColor: Theme.daylightText.withAlphaComponent(0.6), highlightColor: Theme.daylightText, highlightedSubstring: "your location")
            self.button.setTitle("Tap to enable access", for: .normal)
        }
    }

    func setLocationDisabled() {
        self.backgroundColor = Theme.nightBackground

        let text = NSLocalizedString("Unfortunately, Daylight doesn't work without your location data. If you change your mind, you can enable it by going to settings.", comment: "")

        UIView.animate(withDuration: 0.2) {
            self.titleLabel.attributedText = text.attributedMessageString(textColor: Theme.nightText.withAlphaComponent(0.6), highlightColor: Theme.nightText, highlightedSubstring: "going to settings")
        }
    }

    func setNotificationUndetermined() {
        self.backgroundColor = Theme.daylightBackground

        let text = NSLocalizedString("Enable notifications to receive daylight changes on your phone in the morning.", comment: "")
        UIView.animate(withDuration: 0.2) {
            self.titleLabel.attributedText = text.attributedMessageString(textColor: Theme.daylightText.withAlphaComponent(0.6), highlightColor: Theme.daylightText, highlightedSubstring: "Enable notifications")
            self.button.setTitle("Skip for now", for: .normal)
        }
    }

    @objc func didTapScreen() {
        switch self.onboardingState {
        case .location:
              self.delegate?.didRequestToLocateIfPossible(on: self)
        case .denied:
            UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
        case .notification:
            self.delegate?.didRequestToRegisterForNotifications(on: self)
        }
    }

    @objc func didSelectButton() {
        switch self.onboardingState {
        case .location:
            self.delegate?.didRequestToLocateIfPossible(on: self)
        case .denied:
            UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
        case .notification:
            self.delegate?.didRequestToSkipNotifications(on: self)
        }
    }
}
