import 'package:app/Definitons/size_config.dart';

double animatedPositionedLEftValue(int currentIndex) {
  switch (currentIndex) {
    case 0:
      return AppSizes.blockSizeHorizontal * 5.5;
    case 1:
      return AppSizes.blockSizeHorizontal * 22.5;
    case 2:
      return AppSizes.blockSizeHorizontal * 39.5;
    case 3:
      return AppSizes.blockSizeHorizontal * 56.5;
    case 4:
      return AppSizes.blockSizeHorizontal * 73.5;
    default:
      return 0;
  }
}

// ============================================================================
// API CONFIGURATIONS
// ============================================================================

// Google API Key (kept for other services if needed)
const API_KEY = 'AIzaSyDoD2FNKWnr6xtGGJwNCCQ6tmjtHqua8JE';

// Qwen Model Configuration
// 🔧 QUAN TRỌNG: Thay đổi URL này thành URL Gradio của bạn
const QWEN_MODEL_URL = 'https://25f65b1c3ee36b41bc.gradio.live';

// Ví dụ URLs:
// const QWEN_MODEL_URL = 'https://abc123def456.gradio.live';
// const QWEN_MODEL_URL = 'https://1234567890abcdef.gradio.live';

// Timeout settings cho Qwen API
const QWEN_TIMEOUT_SECONDS = 30;

// Model fallback settings
const ENABLE_FALLBACK_TO_GEMINI = false; // Set true nếu muốn fallback về Gemini khi Qwen fail

// ============================================================================
// DATABASE CONFIGURATIONS
// ============================================================================

// MongoDB Configuration
const MONGO_URL =
    'mongodb+srv://dinhductai2004:Tai03102004@englishapp.3ryiky2.mongodb.net/EnglishApp?retryWrites=true&w=majority&appName=EnglishApp';

// Collection names
const COLLECTION_Users = 'Users';
const COLLECTION_Rooms = 'Rooms';

// ============================================================================
// MODEL INFORMATION
// ============================================================================

// Model metadata for UI display
const MODEL_INFO = {
  'name': 'Qwen2-1.5B Fine-tuned',
  'version': '1.0',
  'platform': 'Google Colab GPU T4',
  'languages': ['Tiếng Việt', 'English'],
  'specialization': 'Học tiếng Anh',
  'response_time': '2-5 giây',
  'author': 'Custom Fine-tuned',
};

// Debug settings
const DEBUG_QWEN_API = true; // Set false trong production