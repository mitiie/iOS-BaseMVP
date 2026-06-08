import UIKit

extension UIButton {
    static func primary(title: String) -> UIButton {
        let button = UIButton(type: .system)
        var configuration = UIButton.Configuration.filled()
        configuration.title = title
        configuration.cornerStyle = .medium
        configuration.baseBackgroundColor = .systemBlue
        configuration.baseForegroundColor = .white
        button.configuration = configuration
        return button
    }

    static func secondary(title: String) -> UIButton {
        let button = UIButton(type: .system)
        var configuration = UIButton.Configuration.tinted()
        configuration.title = title
        configuration.cornerStyle = .medium
        button.configuration = configuration
        return button
    }
}
