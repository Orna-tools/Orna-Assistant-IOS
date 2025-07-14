import UIKit
import Vision
import VisionKit
import Photos

class ItemAssessmentViewController: UIViewController, VNDocumentCameraViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // UI Elements
    private let instructionLabel = UILabel()
    private let imageView = UIImageView()
    private let captureButton = UIButton(type: .system)
    private let galleryButton = UIButton(type: .system)
    private let resultTextView = UITextView()
    private let assessButton = UIButton(type: .system)

    // Properties
    private var capturedImage: UIImage?
    private var recognizedText: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Item Assessment"
        view.backgroundColor = .systemBackground
        setupUI()
    }

    private func setupUI() {
        // Configure instruction label
        instructionLabel.text = "Capture a screenshot of the item to assess"
        instructionLabel.textAlignment = .center
        instructionLabel.font = UIFont.systemFont(ofSize: 16)
        instructionLabel.numberOfLines = 0
        instructionLabel.translatesAutoresizingMaskIntoConstraints = false

        // Configure image view
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .systemGray6
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false

        // Configure capture button
        captureButton.setTitle("Take Screenshot", for: .normal)
        captureButton.addTarget(self, action: #selector(captureButtonTapped), for: .touchUpInside)
        captureButton.translatesAutoresizingMaskIntoConstraints = false

        // Configure gallery button
        galleryButton.setTitle("Choose from Gallery", for: .normal)
        galleryButton.addTarget(self, action: #selector(galleryButtonTapped), for: .touchUpInside)
        galleryButton.translatesAutoresizingMaskIntoConstraints = false

        // Configure result text view
        resultTextView.isEditable = false
        resultTextView.font = UIFont.systemFont(ofSize: 14)
        resultTextView.layer.cornerRadius = 8
        resultTextView.layer.borderWidth = 1
        resultTextView.layer.borderColor = UIColor.systemGray4.cgColor
        resultTextView.translatesAutoresizingMaskIntoConstraints = false

        // Configure assess button
        assessButton.setTitle("Assess Item", for: .normal)
        assessButton.addTarget(self, action: #selector(assessButtonTapped), for: .touchUpInside)
        assessButton.isEnabled = false
        assessButton.translatesAutoresizingMaskIntoConstraints = false

        // Add subviews
        view.addSubview(instructionLabel)
        view.addSubview(imageView)
        view.addSubview(captureButton)
        view.addSubview(galleryButton)
        view.addSubview(resultTextView)
        view.addSubview(assessButton)

        // Set up constraints
        NSLayoutConstraint.activate([
            instructionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            instructionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            instructionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            imageView.topAnchor.constraint(equalTo: instructionLabel.bottomAnchor, constant: 20),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3),

            captureButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            captureButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            captureButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.45),

            galleryButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            galleryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            galleryButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.45),

            resultTextView.topAnchor.constraint(equalTo: captureButton.bottomAnchor, constant: 20),
            resultTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            resultTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            resultTextView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25),

            assessButton.topAnchor.constraint(equalTo: resultTextView.bottomAnchor, constant: 20),
            assessButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            assessButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            assessButton.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
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
            showAlert(title: "Error", message: "Camera is not available")
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
        recognizeText(in: image)
    }

    // MARK: - UIImagePickerControllerDelegate

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            capturedImage = image
            imageView.image = image
            assessButton.isEnabled = true
            resultTextView.text = "Image captured. Press 'Assess Item' to analyze."
        }
        picker.dismiss(animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }

    // MARK: - Text Recognition

    private func recognizeText(in image: UIImage) {
        // Show loading indicator
        let loadingIndicator = UIActivityIndicatorView(style: .large)
        loadingIndicator.center = view.center
        loadingIndicator.startAnimating()
        view.addSubview(loadingIndicator)

        // Use the OrnaImageProcessor to recognize text
        OrnaImageProcessor.recognizeText(in: image) { text in
            DispatchQueue.main.async {
                loadingIndicator.removeFromSuperview()

                if let recognizedText = text {
                    self.recognizedText = recognizedText
                    self.resultTextView.text = "Text recognized. Analyzing..."
                    self.assessItem(with: recognizedText)
                } else {
                    self.resultTextView.text = "Failed to recognize text. Try a clearer image."
                    self.showAlert(title: "Recognition Failed", message: "Could not recognize text in the image. Try a clearer image or different lighting.")
                }
            }
        }
    }

    // MARK: - Item Assessment

    private func assessItem(with text: String) {
        // Extract stats from the recognized text
        let stats = OrnaImageProcessor.extractStats(from: text)

        // Create a comprehensive assessment
        let assessment = OrnaImageProcessor.createAssessment(stats: stats, text: text)

        // Display the assessment
        resultTextView.text = assessment

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
