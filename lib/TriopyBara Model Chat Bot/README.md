# 🤖 Qwen2-1.5B Fine-Tuned Chatbot: End-to-End Pipeline

This project provides a complete pipeline to fine-tune and deploy a Qwen2-1.5B chatbot using [LLaMA Factory](https://github.com/hiyouga/LLaMA-Factory), optimized for Google Colab and Flutter mobile app integration.

---

## 📌 Overview

* **Base Model**: Qwen2-1.5B-Instruct (and other small models)
* **Fine-Tuning Technique**: LoRA (Low-Rank Adaptation)
* **Training Platform**: Google Colab with GPU acceleration
* **Deployment API**: FastAPI + Uvicorn + Ngrok
* **Mobile Integration**: Ready-to-use endpoints for Flutter apps

---

## 🛠️ Setup Instructions

### 1. Fine-Tuning the Model

Run the fine-tuning pipeline notebook to:

* Setup LLaMA Factory
* Select a base model (`qwen2`, `tinyllama`, `phi3`, `gemma`)
* Customize a dataset (with identity and authorship)
* Configure LoRA training parameters
* Train and verify the output files
* Package the model for deployment

### Output:

* LoRA model weights: `adapter_model.safetensors`
* Config files: `adapter_config.json`, `tokenizer_config.json`
* Usage script: `test_model.py`
* Documentation: `README.md`, `requirements.txt`

---

### 2. Deploying with FastAPI (Colab-Based Server)

* Load the fine-tuned model from Google Drive
* Merge with base model if LoRA adapter is used
* Start a FastAPI server with `/chat`, `/health`, `/model-status`, and `/docs` endpoints
* Public access via Ngrok tunnel

```bash
# Example API request
POST /chat
{
  "message": "Hello, who are you?",
  "user_id": "mobile_user"
}
```

### Deployment Output:

* Public API URL (Ngrok): `https://xxxxx.ngrok.io`
* Supports: streaming, token limits, temperature settings

---

## 🧠 Model Details

* **Model**: Qwen2-1.5B-Instruct
* **Training Time**: \~25 mins on Colab Free GPU
* **LoRA Size**: \~35MB
* **Adapter Targets**: `q_proj, v_proj`
* **Dataset**: identity (custom), Claude, Alpaca (subset)

---

## 📱 Flutter App Integration

* Call the `/chat` endpoint directly using `http` package
* Handle `ChatResponse` fields: `response`, `generation_time`, `model_info`

```dart
const API_URL = 'https://xxxxx.ngrok.io/chat';
final res = await http.post(
  Uri.parse(API_URL),
  headers: {'Content-Type': 'application/json'},
  body: jsonEncode({"message": "Xin chao!", "user_id": "mobile_user"})
);
```

---

## 📁 File Structure

```
/finetuned_model_package
├── adapter_model.safetensors
├── adapter_config.json
├── tokenizer_config.json
├── requirements.txt
├── test_model.py
└── README.md
```

---

## 🚀 Quick Start

```bash
pip install torch transformers peft accelerate safetensors
python test_model.py
```

---

## 🔧 Tips

* Use temperature \~0.7 for balanced creativity
* Ensure \~6GB VRAM for best performance
* Model supports Vietnamese and English

---

## 👨‍💻 Authors

* Developed by:

    * Đặng Thanh Quang
    * Đinh Đức Tài
    * Đặng Việt Thành

---

## 🧩 License & Acknowledgements

* Model base: [Qwen2-1.5B](https://huggingface.co/Qwen/Qwen2-1.5B-Instruct)
* Fine-tuning: [LLaMA Factory](https://github.com/hiyouga/LLaMA-Factory)
* Deployment tools: FastAPI, Pyngrok, Uvicorn

---

## 📬 Contact

For questions or contributions, please reach out via GitHub or your preferred platform. Happy building! 🚀
