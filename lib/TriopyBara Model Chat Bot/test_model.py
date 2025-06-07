"""
Test script for fine-tuned unsloth/Qwen2-1.5B-Instruct-bnb-4bit model
"""
import torch
from transformers import AutoModelForCausalLM, AutoTokenizer
from peft import PeftModel

def test_model():
    print("🚀 Loading fine-tuned model...")

    # Model names (adjust if needed)
    base_model_name = "Qwen2-1.5B-Instruct"

    try:
        # Load tokenizer và base model
        tokenizer = AutoTokenizer.from_pretrained(base_model_name)
        base_model = AutoModelForCausalLM.from_pretrained(
            base_model_name,
            torch_dtype=torch.float16,
            device_map="auto"
        )

        # Load LoRA adapter
        model = PeftModel.from_pretrained(base_model, "./")
        print("✅ Model loaded successfully!")

        # Test questions
        questions = [
            "Hello, who are you?",
            "Explain artificial intelligence",
            "Write a Python function to sort a list"
        ]

        print("\n🧪 Testing model responses...")
        for i, question in enumerate(questions, 1):
            print(f"\n{i}. Q: {question}")

            prompt = f"<|im_start|>user\n{question}<|im_end|>\n<|im_start|>assistant\n"
            inputs = tokenizer(prompt, return_tensors="pt").to(model.device)

            with torch.no_grad():
                outputs = model.generate(
                    **inputs,
                    max_new_tokens=100,
                    temperature=0.7,
                    do_sample=True,
                    pad_token_id=tokenizer.eos_token_id
                )

            response = tokenizer.decode(outputs[0], skip_special_tokens=True)
            answer = response[len(prompt):].strip()
            print(f"   A: {answer}")

        print("\n✅ All tests completed successfully!")

    except Exception as e:
        print(f"❌ Error: {e}")
        print("💡 Make sure you have installed: pip install -r requirements.txt")

if __name__ == "__main__":
    test_model()
