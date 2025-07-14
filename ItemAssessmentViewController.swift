import UIKit
import Vision
import VisionKit
import Photos

class ItemAssessmentViewController: UIViewController, VNDocumentCameraViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: - UI Elements
    private let headerView = UIView()
    private let instructionLabel = UILabel()
    private let imageContainerView = UIView()
    private let imageView = UIImageView()
    private let buttonStackView = UIStackView()
    private let captureButton = UIButton(type: .system)
    private let galleryButton = UIButton(type: .system)
    private let resultContainerView = UIView()
    private let resultTitleLabel = UILabel()
    private let resultTextView = UITextView()
    private let assessButton = UIButton(type: .system)

    // MARK: - Properties
    private var capturedImage: UIImage?
    private var recognizedText: String = ""
    private var isProcessing = false

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Item Assessment"
        view.backgroundColor = UITheme.Colors.background
        setupUI()
    }

    // MARK: - UI Setup
    private func setupUI() {
        setupHeaderView()
        setupImageSection()
        setupButtonSection()
        setupResultSection()
        setupAssessButton()
        setupConstraints()
    }

    private func setupHeaderView() {
        // Configure header view
        headerView.backgroundColor = UITheme.Colors.primary
        headerView.translatesAutoresizingMaskIntoConstraints = false

        // Configure instruction label
        instructionLabel.text = "Capture a screenshot of the item to assess"
        instructionLabel.textAlignment = .center
        instructionLabel.font = UITheme.Typography.callout
        instructionLabel.textColor = .white
        instructionLabel.numberOfLines = 0
        instructionLabel.translatesAutoresizingMaskIntoConstraints = false

        // Add subviews
        headerView.addSubview(instructionLabel)
        view.addSubview(headerView)

        // Set up constraints for instruction label within header view
        NSLayoutConstraint.activate([
            instructionLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: UITheme.Layout.standardSpacing),
            instructionLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: UITheme.Layout.standardSpacing),
            instructionLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -UITheme.Layout.standardSpacing),
            instructionLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -UITheme.Layout.standardSpacing)
        ])
    }

    private func setupImageSection() {
        // Configure image container view
        UITheme.applyCardStyle(to: imageContainerView)
        imageContainerView.translatesAutoresizingMaskIntoConstraints = false

        // Configure image view
        UITheme.applyImageViewStyle(to: imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false

        // Add placeholder image
        imageView.image = UIImage(systemName: "photo.fill")
        imageView.tintColor = UITheme.Colors.secondaryText

        // Add subviews
        imageContainerView.addSubview(imageView)
        view.addSubview(imageContainerView)

        // Set up constraints for image view within container
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: imageContainerView.topAnchor, constant: UITheme.Layout.standardSpacing),
            imageView.leadingAnchor.constraint(equalTo: imageContainerView.leadingAnchor, constant: UITheme.Layout.standardSpacing),
            imageView.trailingAnchor.constraint(equalTo: imageContainerView.trailingAnchor, constant: -UITheme.Layout.standardSpacing),
            imageView.bottomAnchor.constraint(equalTo: imageContainerView.bottomAnchor, constant: -UITheme.Layout.standardSpacing)
        ])
    }

    private func setupButtonSection() {
        // Configure button stack view
        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .fillEqually
        buttonStackView.spacing = UITheme.Layout.standardSpacing
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false

        // Configure capture button
        setupButton(captureButton, title: "Take Photo", icon: "camera.fill", action: #selector(captureButtonTapped))

        // Configure gallery button
        setupButton(galleryButton, title: "Gallery", icon: "photo.on.rectangle", action: #selector(galleryButtonTapped))

        // Add buttons to stack view
        buttonStackView.addArrangedSubview(captureButton)
        buttonStackView.addArrangedSubview(galleryButton)

        // Add stack view to main view
        view.addSubview(buttonStackView)
    }

    private func setupResultSection() {
        // Configure result container view
        UITheme.applyCardStyle(to: resultContainerView)
        resultContainerView.translatesAutoresizingMaskIntoConstraints = false

        // Configure result title label
        resultTitleLabel.text = "Assessment Results"
        resultTitleLabel.font = UITheme.Typography.title3
        resultTitleLabel.textColor = UITheme.Colors.primary
        resultTitleLabel.translatesAutoresizingMaskIntoConstraints = false

        // Configure result text view
        UITheme.applyTextViewStyle(to: resultTextView)
        resultTextView.text = "Capture an image to begin assessment..."
        resultTextView.isEditable = false
        resultTextView.translatesAutoresizingMaskIntoConstraints = false

        // Add subviews
        resultContainerView.addSubview(resultTitleLabel)
        resultContainerView.addSubview(resultTextView)
        view.addSubview(resultContainerView)

        // Set up constraints within result container
        NSLayoutConstraint.activate([
            resultTitleLabel.topAnchor.constraint(equalTo: resultContainerView.topAnchor, constant: UITheme.Layout.standardSpacing),
            resultTitleLabel.leadingAnchor.constraint(equalTo: resultContainerView.leadingAnchor, constant: UITheme.Layout.standardSpacing),
            resultTitleLabel.trailingAnchor.constraint(equalTo: resultContainerView.trailingAnchor, constant: -UITheme.Layout.standardSpacing),

            resultTextView.topAnchor.constraint(equalTo: resultTitleLabel.bottomAnchor, constant: UITheme.Layout.compactSpacing),
            resultTextView.leadingAnchor.constraint(equalTo: resultContainerView.leadingAnchor, constant: UITheme.Layout.standardSpacing),
            resultTextView.trailingAnchor.constraint(equalTo: resultContainerView.trailingAnchor, constant: -UITheme.Layout.standardSpacing),
            resultTextView.bottomAnchor.constraint(equalTo: resultContainerView.bottomAnchor, constant: -UITheme.Layout.standardSpacing)
        ])
    }

    private func setupAssessButton() {
        // Configure assess button
        var config = UIButton.Configuration.filled()
        config.title = "Assess Item"
        config.image = UIImage(systemName: "wand.and.stars")
        config.imagePadding = 8
        config.baseBackgroundColor = UITheme.Colors.accent
        config.baseForegroundColor = .white
        config.cornerStyle = .large

        assessButton.configuration = config
        assessButton.addTarget(self, action: #selector(assessButtonTapped), for: .touchUpInside)
        assessButton.isEnabled = false
        assessButton.translatesAutoresizingMaskIntoConstraints = false

        // Add button to main view
        view.addSubview(assessButton)
    }

    private func setupButton(_ button: UIButton, title: String, icon: String, action: Selector) {
        var config = UIButton.Configuration.filled()
        config.title = title
        config.image = UIImage(systemName: icon)
        config.imagePadding = 8
        config.baseBackgroundColor = UITheme.Colors.primary
        config.baseForegroundColor = .white
        config.cornerStyle = .large

        button.configuration = config
        button.addTarget(self, action: action, for: .touchUpInside)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Header view constraints
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            // Image container constraints
            imageContainerView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: UITheme.Layout.standardSpacing),
            imageContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UITheme.Layout.standardSpacing),
            imageContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -UITheme.Layout.standardSpacing),
            imageContainerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3),

            // Button stack view constraints
            buttonStackView.topAnchor.constraint(equalTo: imageContainerView.bottomAnchor, constant: UITheme.Layout.standardSpacing),
            buttonStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UITheme.Layout.standardSpacing),
            buttonStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -UITheme.Layout.standardSpacing),
            buttonStackView.heightAnchor.constraint(equalToConstant: UITheme.Layout.buttonHeight),

            // Result container constraints
            resultContainerView.topAnchor.constraint(equalTo: buttonStackView.bottomAnchor, constant: UITheme.Layout.standardSpacing),
            resultContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UITheme.Layout.standardSpacing),
            resultContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -UITheme.Layout.standardSpacing),

            // Assess button constraints
            assessButton.topAnchor.constraint(equalTo: resultContainerView.bottomAnchor, constant: UITheme.Layout.standardSpacing),
            assessButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            assessButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            assessButton.heightAnchor.constraint(equalToConstant: UITheme.Layout.buttonHeight),
            assessButton.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -UITheme.Layout.standardSpacing)
        ])
    }

    // MARK: - Actions

    @objc private func captureButtonTapped() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = .camera
            present(imagePickerController, animated: true)
        } else {
            showAlert(title: "Camera Unavailable", message: "Camera is not available on this device.")
        }
    }

    @objc private func galleryButtonTapped() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true)
    }

    @objc private func assessButtonTapped() {
        guard let image = capturedImage else { return }

        // Disable the button to prevent multiple taps
        assessButton.isEnabled = false

        // Update UI to show processing state
        showProcessingState()

        // Start recognition
        recognizeText(in: image)
    }

    // MARK: - UIImagePickerControllerDelegate

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            // Store the captured image
            capturedImage = image

            // Update the image view with animation
            UIView.transition(with: imageView, duration: 0.3, options: .transitionCrossDissolve, animations: {
                self.imageView.image = image
                self.imageView.tintColor = nil // Remove tint color from placeholder
            })

            // Enable the assess button
            assessButton.isEnabled = true

            // Update the result text view
            resultTextView.text = "Image captured. Press 'Assess Item' to analyze."

            // Add a subtle animation to the assess button to draw attention
            UIView.animate(withDuration: 0.3, animations: {
                self.assessButton.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            }, completion: { _ in
                UIView.animate(withDuration: 0.2) {
                    self.assessButton.transform = CGAffineTransform.identity
                }
            })
        }

        picker.dismiss(animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }

    // MARK: - Text Recognition

    private func showProcessingState() {
        // Update UI to indicate processing
        isProcessing = true

        // Change the assess button appearance
        var config = assessButton.configuration
        config?.title = "Processing..."
        config?.showsActivityIndicator = true
        assessButton.configuration = config

        // Update result text
        resultTextView.text = "Processing image...\n\nThis may take a few moments as we analyze the item details."
    }

    private func hideProcessingState() {
        // Update UI to indicate processing is complete
        isProcessing = false

        // Restore the assess button appearance
        var config = assessButton.configuration
        config?.title = "Assess Item"
        config?.showsActivityIndicator = false
        assessButton.configuration = config
        assessButton.isEnabled = true
    }

    private func recognizeText(in image: UIImage) {
        // Use the OrnaImageProcessor to recognize text
        OrnaImageProcessor.recognizeText(in: image) { text in
            DispatchQueue.main.async {
                // Hide processing state
                self.hideProcessingState()

                if let recognizedText = text {
                    self.recognizedText = recognizedText
                    self.resultTextView.text = "Text recognized. Analyzing..."
                    self.assessItem(with: recognizedText)
                } else {
                    self.showRecognitionFailure()
                }
            }
        }
    }

    private func showRecognitionFailure() {
        // Update the result text view
        resultTextView.text = "Failed to recognize text. Try a clearer image with better lighting."

        // Show alert with more detailed information
        showAlert(
            title: "Recognition Failed",
            message: "Could not recognize text in the image. Here are some tips:\n\n• Ensure good lighting\n• Hold the device steady\n• Make sure text is clearly visible\n• Try cropping the image to focus on the item stats"
        )
    }

    // MARK: - Item Assessment

    private func assessItem(with text: String) {
        // Extract stats from the recognized text
        let stats = OrnaImageProcessor.extractStats(from: text)

        // Create a comprehensive assessment
        let assessment = OrnaImageProcessor.createAssessment(stats: stats, text: text)

        // Display the assessment with animation
        UIView.transition(with: resultTextView, duration: 0.4, options: .transitionCrossDissolve, animations: {
            self.resultTextView.text = assessment
        })

        // Highlight the result container to draw attention
        UIView.animate(withDuration: 0.3, animations: {
            self.resultContainerView.transform = CGAffineTransform(scaleX: 1.02, y: 1.02)
            self.resultContainerView.layer.shadowOpacity = 0.3
        }, completion: { _ in
            UIView.animate(withDuration: 0.2) {
                self.resultContainerView.transform = CGAffineTransform.identity
                self.resultContainerView.layer.shadowOpacity = 0.1
            }
        })

        // Log the extracted stats for debugging
        print("Extracted stats: \(stats)")
    }

    // MARK: - Helper Methods

    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
}
