import UIKit

class ViewController: UIViewController {

    private let welcomeLabel = UILabel()
    private let itemAssessmentButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        // Set up the title for the app
        title = "Orna Assistant"

        // Set up the view background
        view.backgroundColor = .systemBackground

        // Configure welcome label
        welcomeLabel.text = "Welcome to Orna Assistant"
        welcomeLabel.textAlignment = .center
        welcomeLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false

        // Configure item assessment button
        itemAssessmentButton.setTitle("Item Assessment", for: .normal)
        itemAssessmentButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        itemAssessmentButton.backgroundColor = .systemBlue
        itemAssessmentButton.setTitleColor(.white, for: .normal)
        itemAssessmentButton.layer.cornerRadius = 10
        itemAssessmentButton.addTarget(self, action: #selector(itemAssessmentButtonTapped), for: .touchUpInside)
        itemAssessmentButton.translatesAutoresizingMaskIntoConstraints = false

        // Add subviews
        view.addSubview(welcomeLabel)
        view.addSubview(itemAssessmentButton)

        // Set up constraints
        NSLayoutConstraint.activate([
            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            welcomeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            welcomeLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 20),
            welcomeLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20),

            itemAssessmentButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            itemAssessmentButton.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 50),
            itemAssessmentButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            itemAssessmentButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    @objc private func itemAssessmentButtonTapped() {
        let itemAssessmentVC = ItemAssessmentViewController()
        navigationController?.pushViewController(itemAssessmentVC, animated: true)
    }
}
