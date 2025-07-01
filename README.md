![iPhone 15 Pro](https://github.com/user-attachments/assets/3534a86a-1ca5-431b-af8f-a47b16e2edcd)

# **Shadee - Your Personal Complexion Match Assistant**

Shadee is an iOS application that helps users quickly and confidently find the complexion shade that fits them best. Using machine learning and computer vision, Shadee analyzes a user’s skin tone and undertone to recommend the most suitable foundation shades.

**Features**
1. Skin Tone & Undertone Detection
Uses a Vision ML model (based on MST-10 scale) to analyze skin from photos and determine both skin tone and undertone.
2. Guided Photo Capture
Provides clear, step-by-step instructions and real-time validation indicators to ensure high-quality, consistent photos.
3. Instant Analysis & Recommendations
Processes photos on-device and returns personalized shade recommendations within seconds.
4. Save & Review
Allows users to save their analysis results for future reference when shopping online or in-store.

**Tech Stack**
1. Swift – Core language for iOS app development.
2. SwiftUI – Declarative UI framework for building clean, modern interfaces.
3. CoreML – For integrating the trained skin tone & undertone ML model.
4. Vision Framework – For processing and validating photos.
5. Custom Data Annotation – Manual labeling of large datasets using MST-10 scale with masked non-skin regions.
6. Color Constant API – For precise color extraction and classification.
7. SwiftLint – Static code analysis tool to enforce style and conventions.

**How It Works**
1. Open the App
Start from a clean, simple home screen.
2. Take Analysis
Read the guidance modal to prepare.
Use the rear camera with flash enabled.
Align your face with the on-screen overlay.
Real-time validation shows if conditions are met.
3. Start Analysis
If all validation indicators are green, proceed.
Retake photos as needed.
4. Processing
Shadee uses CoreML + Vision to analyze skin tone and undertone.
Loading animation plays while processing.
5. Get Results
View and save your personalized complexion shade recommendations.

**What Makes Shadee Unique?**
1. User-Centered Design:
Clear guidance and friendly validation make it easy for non-technical users to get accurate results.
2. Mobile-First ML:
Optimized for speed and performance on iOS devices.
3. Localization & Relevance:
Focused on real-world photo conditions and a diverse range of skin tones.

**Future Improvements**
1. Increase dataset volume and diversity to improve accuracy.
2. Experiment with advanced model architectures for undertone prediction.
3. Add confidence scores for more transparent results.
4. Explore hybrid models combining photo and user metadata.
5. Enhance accessibility and localization.

## Repository
🔗 [Shadee GitHub Repository](https://github.com/mirabellachn/Larva-Team)
