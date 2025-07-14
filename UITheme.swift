import UIKit

// MARK: - UITheme
/// A centralized place for app-wide UI styling
struct UITheme {
    
    // MARK: - Colors
    struct Colors {
        // Primary colors
        static let primary = UIColor(red: 0.2, green: 0.4, blue: 0.8, alpha: 1.0) // Blue
        static let secondary = UIColor(red: 0.8, green: 0.4, blue: 0.2, alpha: 1.0) // Orange
        static let accent = UIColor(red: 0.2, green: 0.8, blue: 0.4, alpha: 1.0) // Green
        
        // Background colors
        static let background = UIColor.systemBackground
        static let secondaryBackground = UIColor.secondarySystemBackground
        static let cardBackground = UIColor.tertiarySystemBackground
        
        // Text colors
        static let primaryText = UIColor.label
        static let secondaryText = UIColor.secondaryLabel
        static let tertiaryText = UIColor.tertiaryLabel
        
        // Status colors
        static let success = UIColor.systemGreen
        static let warning = UIColor.systemYellow
        static let error = UIColor.systemRed
        static let info = UIColor.systemBlue
    }
    
    // MARK: - Typography
    struct Typography {
        // Heading fonts
        static let largeTitle = UIFont.systemFont(ofSize: 34, weight: .bold)
        static let title1 = UIFont.systemFont(ofSize: 28, weight: .bold)
        static let title2 = UIFont.systemFont(ofSize: 22, weight: .bold)
        static let title3 = UIFont.systemFont(ofSize: 20, weight: .semibold)
        
        // Body fonts
        static let body = UIFont.systemFont(ofSize: 17, weight: .regular)
        static let bodyBold = UIFont.systemFont(ofSize: 17, weight: .bold)
        static let callout = UIFont.systemFont(ofSize: 16, weight: .regular)
        static let subheadline = UIFont.systemFont(ofSize: 15, weight: .regular)
        static let footnote = UIFont.systemFont(ofSize: 13, weight: .regular)
        static let caption1 = UIFont.systemFont(ofSize: 12, weight: .regular)
        static let caption2 = UIFont.systemFont(ofSize: 11, weight: .regular)
    }
    
    // MARK: - Layout
    struct Layout {
        static let standardSpacing: CGFloat = 16
        static let compactSpacing: CGFloat = 8
        static let wideSpacing: CGFloat = 24
        
        static let cornerRadius: CGFloat = 12
        static let buttonHeight: CGFloat = 50
        static let cardCornerRadius: CGFloat = 16
    }
    
    // MARK: - Button Styles
    static func applyPrimaryButtonStyle(to button: UIButton) {
        button.backgroundColor = Colors.primary
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = Typography.bodyBold
        button.layer.cornerRadius = Layout.cornerRadius
        button.clipsToBounds = true
        
        // Add shadow
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 4
        button.layer.shadowOpacity = 0.1
        button.layer.masksToBounds = false
    }
    
    static func applySecondaryButtonStyle(to button: UIButton) {
        button.backgroundColor = Colors.secondaryBackground
        button.setTitleColor(Colors.primary, for: .normal)
        button.titleLabel?.font = Typography.bodyBold
        button.layer.cornerRadius = Layout.cornerRadius
        button.clipsToBounds = true
        button.layer.borderWidth = 1
        button.layer.borderColor = Colors.primary.cgColor
    }
    
    // MARK: - Card View Style
    static func applyCardStyle(to view: UIView) {
        view.backgroundColor = Colors.cardBackground
        view.layer.cornerRadius = Layout.cardCornerRadius
        view.clipsToBounds = true
        
        // Add shadow
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 6
        view.layer.shadowOpacity = 0.1
        view.layer.masksToBounds = false
    }
    
    // MARK: - Text View Style
    static func applyTextViewStyle(to textView: UITextView) {
        textView.backgroundColor = Colors.cardBackground
        textView.textColor = Colors.primaryText
        textView.font = Typography.body
        textView.layer.cornerRadius = Layout.cornerRadius
        textView.clipsToBounds = true
        textView.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
    }
    
    // MARK: - Image View Style
    static func applyImageViewStyle(to imageView: UIImageView) {
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = Colors.secondaryBackground
        imageView.layer.cornerRadius = Layout.cornerRadius
        imageView.clipsToBounds = true
    }
}