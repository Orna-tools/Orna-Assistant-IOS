import UIKit

class ViewController: UIViewController {

    // MARK: - UI Elements
    private let logoImageView = UIImageView()
    private let welcomeLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let featureStackView = UIStackView()
    private let itemAssessmentButton = UIButton(type: .system)
    private let monsterDatabaseButton = UIButton(type: .system)
    private let questTrackerButton = UIButton(type: .system)
    private let buildPlannerButton = UIButton(type: .system)

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: - UI Setup
    private func setupUI() {
        // Set up the title for the app
        title = "Orna Assistant"

        // Set up the view background
        view.backgroundColor = UITheme.Colors.background

        // Configure logo image view (placeholder for now)
        logoImageView.image = UIImage(systemName: "gamecontroller.fill")
        logoImageView.tintColor = UITheme.Colors.primary
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.translatesAutoresizingMaskIntoConstraints = false

        // Configure welcome label
        welcomeLabel.text = "ORNA ASSISTANT"
        welcomeLabel.textAlignment = .center
        welcomeLabel.font = UITheme.Typography.title1
        welcomeLabel.textColor = UITheme.Colors.primary
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false

        // Configure subtitle label
        subtitleLabel.text = "Your ultimate companion for Orna RPG"
        subtitleLabel.textAlignment = .center
        subtitleLabel.font = UITheme.Typography.subheadline
        subtitleLabel.textColor = UITheme.Colors.secondaryText
        subtitleLabel.numberOfLines = 0
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false

        // Configure feature stack view
        featureStackView.axis = .vertical
        featureStackView.spacing = UITheme.Layout.standardSpacing
        featureStackView.distribution = .fillEqually
        featureStackView.translatesAutoresizingMaskIntoConstraints = false

        // Configure item assessment button
        setupButton(itemAssessmentButton, title: "Item Assessment", icon: "photo.on.rectangle.angled", action: #selector(itemAssessmentButtonTapped))

        // Configure monster database button (for future use)
        setupButton(monsterDatabaseButton, title: "Monster Database", icon: "lizard.fill", action: #selector(featureNotAvailable))

        // Configure quest tracker button (for future use)
        setupButton(questTrackerButton, title: "Quest Tracker", icon: "list.bullet.clipboard", action: #selector(featureNotAvailable))

        // Configure build planner button (for future use)
        setupButton(buildPlannerButton, title: "Build Planner", icon: "person.fill.viewfinder", action: #selector(featureNotAvailable))

        // Add buttons to stack view
        featureStackView.addArrangedSubview(itemAssessmentButton)
        featureStackView.addArrangedSubview(monsterDatabaseButton)
        featureStackView.addArrangedSubview(questTrackerButton)
        featureStackView.addArrangedSubview(buildPlannerButton)

        // Add subviews
        view.addSubview(logoImageView)
        view.addSubview(welcomeLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(featureStackView)

        // Set up constraints
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: UITheme.Layout.wideSpacing),
            logoImageView.widthAnchor.constraint(equalToConstant: 80),
            logoImageView.heightAnchor.constraint(equalToConstant: 80),

            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            welcomeLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: UITheme.Layout.standardSpacing),
            welcomeLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: UITheme.Layout.standardSpacing),
            welcomeLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -UITheme.Layout.standardSpacing),

            subtitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: UITheme.Layout.compactSpacing),
            subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UITheme.Layout.wideSpacing),
            subtitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -UITheme.Layout.wideSpacing),

            featureStackView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: UITheme.Layout.wideSpacing * 2),
            featureStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UITheme.Layout.wideSpacing),
            featureStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -UITheme.Layout.wideSpacing),
            featureStackView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -UITheme.Layout.wideSpacing)
        ])

        // Set button heights
        itemAssessmentButton.heightAnchor.constraint(equalToConstant: UITheme.Layout.buttonHeight).isActive = true
        monsterDatabaseButton.heightAnchor.constraint(equalToConstant: UITheme.Layout.buttonHeight).isActive = true
        questTrackerButton.heightAnchor.constraint(equalToConstant: UITheme.Layout.buttonHeight).isActive = true
        buildPlannerButton.heightAnchor.constraint(equalToConstant: UITheme.Layout.buttonHeight).isActive = true
    }

    private func setupButton(_ button: UIButton, title: String, icon: String, action: Selector) {
        // Create configuration for the button
        var config = UIButton.Configuration.filled()
        config.title = title
        config.image = UIImage(systemName: icon)
        config.imagePadding = 10
        config.baseBackgroundColor = UITheme.Colors.primary
        config.baseForegroundColor = .white
        config.cornerStyle = .large

        // Apply configuration
        button.configuration = config
        button.addTarget(self, action: action, for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
    }

    // MARK: - Actions
    @objc private func itemAssessmentButtonTapped() {
        let itemAssessmentVC = ItemAssessmentViewController()
        navigationController?.pushViewController(itemAssessmentVC, animated: true)
    }

    @objc private func featureNotAvailable() {
        let alertController = UIAlertController(
            title: "Coming Soon",
            message: "This feature is not available yet. Stay tuned for updates!",
            preferredStyle: .alert
        )
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
}
