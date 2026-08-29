# 🛡️ Aarogya-Rakshak: Medical Emergency Financial Clarity (Client)

> **Privacy-first, offline-capable mobile application to decode complex hospital bills and insurance policies.**

Aarogya-Rakshak is designed for the iQOO Hackathon 2026 (HealthTech track). It addresses the critical issue of financial uncertainty during high-stress medical emergencies by processing hospital estimates and insurance policies entirely on-device, calculating estimated out-of-pocket expenses, and highlighting questions to ask the hospital.

### 🌟 Key Features
- **Offline-First Processing**: No cloud APIs are used for core AI tasks, ensuring maximum privacy and zero latency issues in hospitals with poor connectivity.
- **On-Device LLM**: Runs a quantized LLM directly on the Snapdragon NPU for intelligent document understanding.
- **Deterministic Calculation**: Separates AI parsing from arithmetic for zero hallucination in financial math.

---

## 🛠️ Tech Stack

- **Framework:** Flutter (Dart)
- **State Management:** GetX (or Provider)
- **On-Device OCR:** Google ML Kit (Vision API)
- **Local AI Inference:** `mediapipe_genai` (or `mlc_llm`)
- **Local Database:** `sqflite` or `isar` (for offline persistence)
- **Networking:** `dio` or `http` (for optional secure sync)

---

## 🏗️ Hybrid Architecture Pipeline

To guarantee accuracy and prevent LLM "hallucinations" in math, Aarogya-Rakshak uses a specialized pipeline:

1. 📸 **Capture**: The user takes a photo of their insurance policy and hospital estimate.
2. 📝 **OCR (Offline)**: Google ML Kit extracts raw text from the images locally.
3. 🧠 **Understand (Local AI)**: A quantized local LLM (e.g., Llama-3-8B-Instruct or Gemma-2b-it in `.tflite`/`.bin` format) parses the text into a strict JSON schema to extract entities (e.g., `sum_insured`, `room_rent_limit`, `total_billed`, `consumables`).
4. 🧮 **Calculate (Dart Code)**: A deterministic Dart calculation engine applies rule-based logic to compute the final estimated out-of-pocket expenses (e.g., applying `co_pay_percentage`, filtering exclusions).
5. 💡 **Advise (Local AI)**: The LLM reviews the calculated constraints and generates context-aware advice (e.g., "Ask the billing desk if the ₹5000 'Miscellaneous' charge can be itemized").
6. ☁️ **Sync (Optional Cloud)**: If enabled, structured JSON (no raw images) is encrypted and synced to the secure Node.js backend.

---

## 👨‍💻 Flutter Developer Guidance (What to Build & Action Plan)

To implement the hybrid architecture efficiently, follow this step-by-step action plan:

### 1. Core UI Screens
- **Home/Dashboard:** Display previous offline calculations, an option to start a new scan, and an optional "Sync to Cloud" button.
- **Document Scanner (Camera View):** A custom camera interface guiding the user to capture crisp, well-lit images of their insurance policy and hospital bill.
- **Processing Screen:** A loading state screen that visually breaks down the offline processing steps to the user (e.g., "Extracting text...", "AI analyzing clauses...", "Calculating financials...").
- **Final Financial Snapshot View:** The core output screen displaying the calculated `Payable Amount`, `Out-of-Pocket Estimate`, extracted JSON summary, and the AI-generated advice/questions for the hospital.

### 2. Core Services to Implement
- **`CameraService`**: Wraps the Flutter `camera` plugin to handle capturing high-resolution photos securely.
- **`OCRService`**: Integrates `google_mlkit_text_recognition` to take the captured image and return raw, unformatted text strings.
- **`LLMService`**: The most critical service. Loads the `.tflite` model via `mediapipe_genai` (or `mlc_llm`), constructs a strict prompt forcing a JSON response, feeds the OCR text, and parses the output into a typed Dart model.
- **`CalculationEngine`**: A pure Dart utility class that takes the parsed AI entities and deterministically calculates the final financial figures without relying on the LLM's math capabilities.

### 3. State Management Flow
Using GetX (or Provider), the data should flow linearly without blocking the main UI thread:
1. **User action:** Triggers `CameraService`.
2. **Image data:** Passed to `OCRService` (State: `isExtractingText = true`).
3. **String data:** Passed to `LLMService` (State: `isAnalyzing = true`).
4. **Parsed JSON:** Passed to `CalculationEngine` (State: `isCalculating = true`).
5. **Final Result:** Updates the ViewModel, navigating the user to the Final Financial Snapshot View.

---

## 📁 Folder Structure

```text
lib/
├── controllers/    # State management controllers (GetX)
├── models/         # Data models and entities
├── services/       # OCR, Local LLM, and Cloud Sync services
├── utils/          # Deterministic Calculation Engine
└── views/          # Flutter UI screens and widgets
```

---

## 📋 Prerequisites

Ensure you have the following installed before setting up the project:
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (latest stable version)
- Android Studio with Android NDK installed (required for compiling local LLM inference engines like MediaPipe or MLC)
- A physical Android device (Snapdragon NPU recommended for optimal local AI performance)

---

## 🚀 Setup & Run Instructions

### 1. Clone the repository and install dependencies
```bash
git clone <repository_url>
cd client
flutter pub get
```

### 2. Download and Place the Local LLM Model
Because the LLM runs locally, you must manually provide the quantized model weights.
1. Download your preferred quantized model (e.g., `.tflite` for MediaPipe or `.bin` for MLC).
2. Place the model file inside the `assets/models/` directory.

```text
client/
└── assets/
    └── models/
        └── gemma-2b-it-q4.tflite   <-- PLACE MODEL HERE
```
3. Ensure the `pubspec.yaml` has the assets declared:
```yaml
flutter:
  assets:
    - assets/models/
```

### 3. Run the App
Connect your physical device and run:
```bash
flutter run
```
> [!IMPORTANT]  
> Testing on an emulator may cause severe performance issues or crashes when loading the local LLM. A physical device is strongly recommended for development and testing.

---

## ⚙️ Environment Variables

For the optional secure cloud sync feature to work, you may need to configure your backend endpoint. Create a `.env` file in the root of the `client/` directory (if you are using `flutter_dotenv`):

```env
API_BASE_URL=http://<YOUR_BACKEND_IP>:3000/api
```
