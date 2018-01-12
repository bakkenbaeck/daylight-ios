//
//  TodayView.swift
//  Project
//
//  Created by Dylan Marriott on 19/02/17.
//

import Foundation
import UIKit

class TodayView: UIView {

    private lazy var sunriseIcon: UIImageView = {
        let sunriseIcon = UIImageView(image: #imageLiteral(resourceName: "sunrise").withRenderingMode(.alwaysTemplate))
        sunriseIcon.translatesAutoresizingMaskIntoConstraints = false
        return sunriseIcon
    }()

    private lazy var sunriseLabel: UILabel = {
        let sunriseLabel = UILabel()
        sunriseLabel.translatesAutoresizingMaskIntoConstraints = false
        sunriseLabel.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.medium)
        sunriseLabel.textAlignment = .center
        return sunriseLabel
    }()

    private lazy var sunsetIcon: UIImageView = {
        let sunsetIcon = UIImageView(image: #imageLiteral(resourceName: "sunset").withRenderingMode(.alwaysTemplate))
        sunsetIcon.translatesAutoresizingMaskIntoConstraints = false
        return sunsetIcon
    }()

    private lazy var sunsetLabel: UILabel = {
        let sunsetLabel = UILabel()
        sunsetLabel.translatesAutoresizingMaskIntoConstraints = false
        sunsetLabel.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.medium)
        sunsetLabel.textAlignment = .center
        return sunsetLabel
    }()

    private lazy var messageLabel: UILabel = {
        let messageLabel = UILabel()
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.medium)
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        return messageLabel
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.addSubview(self.sunriseIcon)
        self.addSubview(self.sunriseLabel)
        self.addSubview(self.sunsetIcon)
        self.addSubview(self.sunsetLabel)
        self.addSubview(self.messageLabel)

        let padding: CGFloat = 30
        let constraints = [
            sunriseIcon.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            sunriseIcon.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -12),
            sunriseIcon.widthAnchor.constraint(equalToConstant: 40),
            sunriseIcon.heightAnchor.constraint(equalToConstant: 40),

            sunriseLabel.leadingAnchor.constraint(equalTo: sunriseIcon.leadingAnchor),
            sunriseLabel.topAnchor.constraint(equalTo: sunriseIcon.bottomAnchor, constant: 2),
            sunriseLabel.widthAnchor.constraint(equalTo: sunriseIcon.widthAnchor),
            sunriseLabel.heightAnchor.constraint(equalToConstant: 20),

            sunsetIcon.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            sunsetIcon.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -12),
            sunsetIcon.widthAnchor.constraint(equalToConstant: 40),
            sunsetIcon.heightAnchor.constraint(equalToConstant: 40),

            sunsetLabel.leadingAnchor.constraint(equalTo: sunsetIcon.leadingAnchor),
            sunsetLabel.topAnchor.constraint(equalTo: sunsetIcon.bottomAnchor, constant: 2),
            sunsetLabel.widthAnchor.constraint(equalTo: sunsetIcon.widthAnchor),
            sunsetLabel.heightAnchor.constraint(equalToConstant: 20),

            messageLabel.leadingAnchor.constraint(equalTo: sunriseIcon.trailingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(equalTo: sunsetIcon.leadingAnchor, constant: -20),
            messageLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            messageLabel.heightAnchor.constraint(equalTo: self.heightAnchor)
        ]
        NSLayoutConstraint.activate(constraints)

        self.updateView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateView() {
        if let location = Location.current {
            let tintColor = self.color(for: location.sunTime.sunPhase)
            sunriseIcon.tintColor = tintColor
            sunsetIcon.tintColor = tintColor
            sunriseLabel.textColor = tintColor.darker(by: 20)
            sunsetLabel.textColor = tintColor.darker(by: 20)

            sunriseLabel.text = location.sunTime.sunriseTimeString
            sunsetLabel.text = location.sunTime.sunsetTimeString

            let interval = location.sunTime.dayLengthDifference
            let minutesRounded = abs(Int(Darwin.round(interval / 60.0)))
            let generatedMessage = Message(for: Date(), coordinates: location.coordinates)

            let format = NSLocalizedString("number_of_minutes", comment: "")
            let minuteString = String.localizedStringWithFormat(format, minutesRounded)
            let formattedMessage = String(format: generatedMessage.format, minuteString)

            let message = Message(format: formattedMessage)
            let attributedString = message.attributedString(textColor: tintColor.darker(by: 20), highlightColor: tintColor)

            messageLabel.attributedText = attributedString
        }
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
}
