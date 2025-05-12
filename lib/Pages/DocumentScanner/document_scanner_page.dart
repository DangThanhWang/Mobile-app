import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:translator/translator.dart';

class DocumentScannerPage extends StatefulWidget {
  const DocumentScannerPage({Key? key}) : super(key: key);

  @override
  _DocumentScannerPageState createState() => _DocumentScannerPageState();
}

class _DocumentScannerPageState extends State<DocumentScannerPage> with WidgetsBindingObserver {
  List<CameraDescription>? cameras;
  CameraController? controller;
  File? imageFile;
  String scannedText = "";
  String translatedText = "";
  bool isScanning = false;
  bool isTranslating = false;
  bool isCameraInitialized = false;
  bool hasError = false;
  String errorMessage = "";

  final translator = GoogleTranslator();
  String sourceLanguage = 'auto';
  String targetLanguage = 'vi'; // Mặc định là tiếng Việt

  final TextRecognizer _textRecognizer = GoogleMlKit.vision.textRecognizer();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();

    // Xử lý lỗi OpenGL
    FlutterError.onError = (FlutterErrorDetails details) {
      if (details.exception.toString().contains('OpenGL')) {
        print('Caught OpenGL error and prevented app crash');
      } else {
        FlutterError.presentError(details);
      }
    };
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Xử lý khi ứng dụng bị tạm dừng hoặc tiếp tục
    if (controller == null || !controller!.value.isInitialized) return;

    if (state == AppLifecycleState.inactive) {
      controller?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

  Future<void> _initializeCamera() async {
    try {
      final status = await Permission.camera.request();
      if (status.isGranted) {
        try {
          cameras = await availableCameras();
          if (cameras != null && cameras!.isNotEmpty) {
            controller = CameraController(
              cameras![0],
              ResolutionPreset.medium, // Giảm xuống medium để tránh lỗi OpenGL
              enableAudio: false,
              imageFormatGroup: ImageFormatGroup.jpeg,
            );

            try {
              await controller!.initialize();
              if (mounted) {
                setState(() {
                  isCameraInitialized = true;
                  hasError = false;
                });
              }
            } catch (e) {
              setState(() {
                hasError = true;
                errorMessage = "Không thể khởi tạo camera: $e";
                print(errorMessage);
              });
            }
          } else {
            setState(() {
              hasError = true;
              errorMessage = "Không tìm thấy camera trên thiết bị";
            });
          }
        } catch (e) {
          setState(() {
            hasError = true;
            errorMessage = "Lỗi khi truy cập camera: $e";
            print(errorMessage);
          });
        }
      } else {
        setState(() {
          hasError = true;
          errorMessage = "Quyền truy cập camera bị từ chối";
        });
      }
    } catch (e) {
      setState(() {
        hasError = true;
        errorMessage = "Lỗi không xác định: $e";
        print(errorMessage);
      });
    }
  }

  Future<void> _takePicture() async {
    if (controller == null || !controller!.value.isInitialized) {
      _showSnackBar("Camera chưa được khởi tạo. Vui lòng thử lại.");
      return;
    }

    try {
      // Hiển thị thông báo đang chụp
      _showSnackBar("Đang chụp ảnh...");

      final XFile image = await controller!.takePicture();
      setState(() {
        imageFile = File(image.path);
      });

      // Quét văn bản trong hình ảnh
      _scanImage(image);
    } catch (e) {
      _showSnackBar("Lỗi khi chụp ảnh: $e");
      print("Lỗi chụp ảnh: $e");
    }
  }

  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80, // Giảm chất lượng để tối ưu hiệu suất
      );

      if (pickedFile != null) {
        setState(() {
          imageFile = File(pickedFile.path);
        });
        _scanImage(pickedFile);
      }
    } catch (e) {
      _showSnackBar("Lỗi khi chọn ảnh: $e");
      print("Lỗi chọn ảnh: $e");
    }
  }

  Future<void> _scanImage(XFile file) async {
    setState(() {
      isScanning = true;
      scannedText = "";
    });

    try {
      final inputImage = InputImage.fromFilePath(file.path);
      final RecognizedText recognizedText = await _textRecognizer.processImage(inputImage);

      String text = "";
      for (TextBlock block in recognizedText.blocks) {
        for (TextLine line in block.lines) {
          text += "${line.text}\n";
        }
      }

      setState(() {
        scannedText = text;
        isScanning = false;
      });

      if (text.isNotEmpty) {
        _translateText(text);
      } else {
        _showSnackBar("Không tìm thấy văn bản trong hình ảnh");
      }
    } catch (e) {
      setState(() {
        scannedText = "Lỗi khi quét văn bản: $e";
        isScanning = false;
      });
      print("Lỗi quét văn bản: $e");
    }
  }

  Future<void> _translateText(String text) async {
    if (text.isEmpty) return;

    setState(() {
      isTranslating = true;
    });

    try {
      final translation = await translator.translate(
        text,
        from: sourceLanguage,
        to: targetLanguage,
      );

      setState(() {
        translatedText = translation.text;
        isTranslating = false;
      });
    } catch (e) {
      setState(() {
        translatedText = "Lỗi dịch thuật: $e";
        isTranslating = false;
      });
      print("Lỗi dịch thuật: $e");
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _copyToClipboard(String text) {
    if (text.isNotEmpty) {
      // Copy văn bản vào clipboard
      // Implement clipboard functionality here
      _showSnackBar("Đã sao chép vào clipboard");
    }
  }

  Widget _buildCameraPreview() {
    if (hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Colors.red, size: 48),
            SizedBox(height: 16),
            Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.red),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _initializeCamera,
              child: Text("Thử lại"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF7C72E5),
              ),
            ),
          ],
        ),
      );
    } else if (imageFile != null) {
      // Hiển thị hình ảnh đã chụp hoặc chọn
      return Image.file(
        imageFile!,
        fit: BoxFit.contain,
      );
    } else if (controller != null && controller!.value.isInitialized) {
      // Hiển thị camera preview
      return CameraPreview(controller!);
    } else {
      // Đang tải camera
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text("Đang tải camera..."),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    _textRecognizer.close();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quét & Dịch Tài Liệu"),
        backgroundColor: const Color(0xFF7C72E5),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.translate, color: Colors.white),
            onSelected: (String language) {
              setState(() {
                targetLanguage = language;
                if (scannedText.isNotEmpty) {
                  _translateText(scannedText);
                }
              });
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(value: 'vi', child: Text('Tiếng Việt')),
              PopupMenuItem(value: 'en', child: Text('Tiếng Anh')),
              PopupMenuItem(value: 'fr', child: Text('Tiếng Pháp')),
              PopupMenuItem(value: 'ja', child: Text('Tiếng Nhật')),
              PopupMenuItem(value: 'ko', child: Text('Tiếng Hàn')),
              PopupMenuItem(value: 'zh', child: Text('Tiếng Trung')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Camera Preview hoặc Hình ảnh đã chụp
          Expanded(
            flex: 3,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Container(
                margin: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: _buildCameraPreview(),
              ),
            ),
          ),

          // Kết quả văn bản
          Expanded(
            flex: 4,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Văn bản gốc
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Văn bản quét được:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                        if (scannedText.isNotEmpty)
                          IconButton(
                            icon: Icon(Icons.copy, size: 20),
                            onPressed: () => _copyToClipboard(scannedText),
                            tooltip: 'Sao chép',
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    if (isScanning)
                      Center(
                        child: Column(
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 8),
                            Text("Đang quét văn bản..."),
                          ],
                        ),
                      )
                    else
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Text(
                          scannedText.isEmpty ? "Chưa có văn bản" : scannedText,
                          style: TextStyle(
                            fontSize: 14,
                            color: scannedText.isEmpty ? Colors.grey : Colors.black87,
                          ),
                        ),
                      ),

                    // Văn bản dịch
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Bản dịch:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                        if (translatedText.isNotEmpty)
                          IconButton(
                            icon: Icon(Icons.copy, size: 20),
                            onPressed: () => _copyToClipboard(translatedText),
                            tooltip: 'Sao chép',
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    if (isTranslating)
                      Center(
                        child: Column(
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 8),
                            Text("Đang dịch..."),
                          ],
                        ),
                      )
                    else
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEDE9FF),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFF7C72E5).withOpacity(0.3)),
                        ),
                        child: Text(
                          translatedText.isEmpty ? "Chưa có bản dịch" : translatedText,
                          style: TextStyle(
                            fontSize: 14,
                            color: translatedText.isEmpty ? Colors.grey : Colors.black87,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Nút chụp ảnh
            _buildCircularButton(
              icon: Icons.camera_alt,
              label: "Chụp ảnh",
              onPressed: _takePicture,
              color: const Color(0xFF7C72E5),
            ),

            // Nút chọn ảnh từ thư viện
            _buildCircularButton(
              icon: Icons.photo_library,
              label: "Thư viện",
              onPressed: _pickImage,
              color: Colors.orange,
            ),

            // Nút xóa
            _buildCircularButton(
              icon: Icons.refresh,
              label: "Làm mới",
              onPressed: () {
                setState(() {
                  imageFile = null;
                  scannedText = "";
                  translatedText = "";
                });
              },
              color: Colors.redAccent,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircularButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton(
          heroTag: "btn_$label",
          onPressed: onPressed,
          backgroundColor: color,
          child: Icon(icon, color: Colors.white),
        ),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}