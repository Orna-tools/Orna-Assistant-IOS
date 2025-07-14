import UIKit
import Vision

class OrnaImageProcessor {
    
    // MARK: - Constants
    
    // Stat keys that we want to extract from the screenshots
    static let statKeys = [
        "hp", "mana", "attack", "magic", "defense", 
        "resistance", "dexterity", "ward", "crit", "foresight"
    ]
    
    // Regular expressions for extracting stats
    static let statPatterns: [String: String] = [
        "hp": "HP[:\\s]+(\\d+)",
        "mana": "Mana[:\\s]+(\\d+)",
        "attack": "Attack[:\\s]+(\\d+)",
        "magic": "Magic[:\\s]+(\\d+)",
        "defense": "Defense[:\\s]+(\\d+)",
        "resistance": "Resistance[:\\s]+(\\d+)",
        "dexterity": "Dexterity[:\\s]+(\\d+)",
        "ward": "Ward[:\\s]+(\\d+)",
        "crit": "Crit[:\\s]+(\\d+)",
        "foresight": "Foresight[:\\s]+(\\d+)"
    ]
    
    // MARK: - Image Pre-processing
    
    /// Pre-processes an image to optimize it for OCR
    /// - Parameter image: The original image
    /// - Returns: The processed image
    static func preprocessImage(_ image: UIImage) -> UIImage {
        guard let ciImage = CIImage(image: image) else { return image }
        
        // Create a context for CIImage processing
        let context = CIContext()
        
        // Apply a series of filters to enhance the image for OCR
        
        // 1. Convert to grayscale
        let grayscaleFilter = CIFilter(name: "CIColorControls")
        grayscaleFilter?.setValue(ciImage, forKey: kCIInputImageKey)
        grayscaleFilter?.setValue(0.0, forKey: kCIInputSaturationKey) // 0 = grayscale
        
        // 2. Enhance contrast
        let contrastFilter = CIFilter(name: "CIColorControls")
        contrastFilter?.setValue(grayscaleFilter?.outputImage, forKey: kCIInputImageKey)
        contrastFilter?.setValue(1.5, forKey: kCIInputContrastKey) // Increase contrast
        
        // 3. Apply threshold to create black and white image
        let thresholdFilter = CIFilter(name: "CIColorThreshold")
        thresholdFilter?.setValue(contrastFilter?.outputImage, forKey: kCIInputImageKey)
        thresholdFilter?.setValue(0.5, forKey: "inputThreshold")
        
        // Get the output image
        guard let outputImage = thresholdFilter?.outputImage,
              let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else {
            return image
        }
        
        return UIImage(cgImage: cgImage)
    }
    
    /// Detects the type of screen in the Orna game
    /// - Parameter image: The screenshot image
    /// - Returns: The detected screen type
    static func detectScreenType(_ image: UIImage) -> String {
        // This is a placeholder. In a real implementation, you would analyze the image
        // to determine what type of screen it is (item details, character stats, etc.)
        return "itemDetails"
    }
    
    // MARK: - Text Recognition
    
    /// Recognizes text in an image using Vision framework
    /// - Parameters:
    ///   - image: The image to process
    ///   - completion: Completion handler with recognized text
    static func recognizeText(in image: UIImage, completion: @escaping (String?) -> Void) {
        // Pre-process the image
        let processedImage = preprocessImage(image)
        
        guard let cgImage = processedImage.cgImage else {
            completion(nil)
            return
        }
        
        // Create a text recognition request
        let request = VNRecognizeTextRequest { request, error in
            if let error = error {
                print("Text recognition error: \(error)")
                completion(nil)
                return
            }
            
            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                completion(nil)
                return
            }
            
            // Extract text from observations
            let recognizedText = observations.compactMap { observation in
                observation.topCandidates(1).first?.string
            }.joined(separator: "\n")
            
            completion(recognizedText)
        }
        
        // Configure the request
        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = false // Disable for stat numbers
        
        // Process the image
        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        
        do {
            try requestHandler.perform([request])
        } catch {
            print("Failed to perform text recognition: \(error)")
            completion(nil)
        }
    }
    
    // MARK: - Stat Extraction
    
    /// Extracts stats from recognized text
    /// - Parameter text: The recognized text
    /// - Returns: Dictionary of extracted stats
    static func extractStats(from text: String) -> [String: Int] {
        var stats: [String: Int] = [:]
        
        // Process each stat pattern
        for (statName, pattern) in statPatterns {
            if let regex = try? NSRegularExpression(pattern: pattern, options: [.caseInsensitive]),
               let match = regex.firstMatch(in: text, options: [], range: NSRange(text.startIndex..., in: text)),
               let range = Range(match.range(at: 1), in: text),
               let value = Int(text[range]) {
                stats[statName] = value
            }
        }
        
        return stats
    }
    
    /// Determines if an item is a weapon based on its stats
    /// - Parameter stats: The item stats
    /// - Returns: True if the item is likely a weapon
    static func isWeapon(stats: [String: Int]) -> Bool {
        // A weapon typically has attack or magic stats
        return stats["attack"] != nil || stats["magic"] != nil
    }
    
    /// Determines if an item is two-handed based on its description
    /// - Parameter text: The item description text
    /// - Returns: True if the item is likely two-handed
    static func isTwoHanded(text: String) -> Bool {
        return text.lowercased().contains("two-handed") || text.lowercased().contains("2h")
    }
    
    /// Determines if an item is upgradable
    /// - Parameter text: The item description text
    /// - Returns: True if the item is upgradable
    static func isUpgradable(text: String) -> Bool {
        // Most equipment in Orna is upgradable
        return !text.lowercased().contains("cannot be upgraded")
    }
    
    /// Determines if an item is an off-hand item
    /// - Parameter text: The item description text
    /// - Returns: True if the item is an off-hand item
    static func isOffHand(text: String) -> Bool {
        return text.lowercased().contains("off-hand") || text.lowercased().contains("shield")
    }
    
    /// Determines if an item is a celestial weapon
    /// - Parameter text: The item description text
    /// - Returns: True if the item is a celestial weapon
    static func isCelestialWeapon(text: String) -> Bool {
        return text.lowercased().contains("celestial")
    }
    
    /// Determines the boss scaling of an item
    /// - Parameter text: The item description text
    /// - Returns: 1 for boss scaling, -1 for no boss scaling, 0 for unset
    static func getBossScaling(text: String) -> Int {
        if text.lowercased().contains("boss") {
            return 1
        } else if text.lowercased().contains("no boss") {
            return -1
        } else {
            return 0
        }
    }
    
    // MARK: - Assessment
    
    /// Creates an assessment result for the item
    /// - Parameters:
    ///   - stats: The extracted stats
    ///   - text: The full recognized text
    /// - Returns: A formatted assessment string
    static func createAssessment(stats: [String: Int], text: String) -> String {
        var assessment = "Item Assessment:\n\n"
        
        // Determine rarity
        if text.lowercased().contains("legendary") {
            assessment += "- Rarity: Legendary ⭐⭐⭐⭐⭐\n"
        } else if text.lowercased().contains("ornate") {
            assessment += "- Rarity: Ornate ⭐⭐⭐⭐\n"
        } else if text.lowercased().contains("famed") {
            assessment += "- Rarity: Famed ⭐⭐⭐\n"
        } else if text.lowercased().contains("superior") {
            assessment += "- Rarity: Superior ⭐⭐\n"
        } else if text.lowercased().contains("common") {
            assessment += "- Rarity: Common ⭐\n"
        } else {
            assessment += "- Rarity: Unknown\n"
        }
        
        // Add item type
        if isWeapon(stats: stats) {
            assessment += "- Type: Weapon\n"
            if isTwoHanded(text: text) {
                assessment += "- Two-handed: Yes\n"
            }
        } else if isOffHand(text: text) {
            assessment += "- Type: Off-hand\n"
        } else {
            assessment += "- Type: Armor/Accessory\n"
        }
        
        if isCelestialWeapon(text: text) {
            assessment += "- Celestial: Yes\n"
        }
        
        // Add boss scaling
        let bossScaling = getBossScaling(text: text)
        if bossScaling == 1 {
            assessment += "- Boss Scaling: Yes\n"
        } else if bossScaling == -1 {
            assessment += "- Boss Scaling: No\n"
        }
        
        // Add stats
        assessment += "\nStats:\n"
        for (stat, value) in stats.sorted(by: { $0.key < $1.key }) {
            assessment += "- \(stat.capitalized): \(value)\n"
        }
        
        // Add recommendation
        assessment += "\nRecommendation: "
        
        if text.lowercased().contains("legendary") || text.lowercased().contains("ornate") {
            assessment += "Keep this item! It's valuable."
        } else if text.lowercased().contains("famed") {
            assessment += "Consider keeping if it has good stats."
        } else {
            assessment += "This item can likely be sold or dismantled."
        }
        
        return assessment
    }
}