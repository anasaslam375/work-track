import 'dart:developer';
import 'dart:io';
import 'package:get/get.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:worktrack/app/modules/payslip/controllers/payslip_utils.dart';
import '../../data/models/payslip_model.dart';

/// Service for handling payslip OCR operations
class PayslipService extends GetxService {
  final TextRecognizer _textRecognizer = TextRecognizer();

  @override
  void onClose() {
    _textRecognizer.close();
    super.onClose();
  }

  /// Process image and extract payslip data using OCR
  Future<PayslipModel?> processPayslipImage(File imageFile) async {
    try {
      final inputImage = InputImage.fromFile(imageFile);
      final RecognizedText recognizedText = await _textRecognizer.processImage(
        inputImage,
      );
      PayslipModel payslip = PayslipExtractor.extractPayslipData(
        recognizedText.text,
      );
      log("Slip Data: ${payslip.toJson()}");
      return payslip;
    } catch (e) {
      print('OCR Error: $e');
      return null;
    }
  }
}
