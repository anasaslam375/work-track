// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/services/payslip_service.dart';
import '../../../core/services/storage_service.dart';
import '../../../data/models/payslip_model.dart';

/// Controller for payslip OCR functionality
class PayslipController extends GetxController {
  final PayslipService _payslipService = Get.find<PayslipService>();
  final StorageService _storageService = Get.find<StorageService>();
  final ImagePicker _imagePicker = ImagePicker();

  // Observable variables
  final RxBool isProcessing = false.obs;
  final Rxn<File> selectedImage = Rxn<File>();
  final Rxn<PayslipModel> extractedData = Rxn<PayslipModel>();
  final RxString errorMessage = ''.obs;
  final RxList<PayslipModel> payslipHistory = <PayslipModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadPayslipHistory();
  }

  /// Load payslip history from storage
  void _loadPayslipHistory() {
    final data = _storageService.read<List>('payslip_history');
    if (data != null) {
      payslipHistory.value = data
          .map((json) => PayslipModel.fromJson(Map<String, dynamic>.from(json)))
          .toList();
    }
  }

  /// Save payslip to history
  Future<void> _saveToHistory(PayslipModel payslip) async {
    payslipHistory.insert(0, payslip); // Add to beginning
    final data = payslipHistory.map((p) => p.toJson()).toList();
    await _storageService.write('payslip_history', data);
  }

  /// Pick image from camera
  Future<void> pickFromCamera() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );

      if (image != null) {
        selectedImage.value = File(image.path);
        errorMessage.value = '';
        await _processImage();
      }
    } catch (e) {
      _handleError('Failed to capture image: $e');
    }
  }

  /// Pick image from gallery
  Future<void> pickFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null) {
        selectedImage.value = File(image.path);
        errorMessage.value = '';
        await _processImage();
      }
    } catch (e) {
      _handleError('Failed to select image: $e');
    }
  }

  /// Process selected image with OCR
  Future<void> _processImage() async {
    if (selectedImage.value == null) return;

    try {
      isProcessing.value = true;
      errorMessage.value = '';

      final result = await _payslipService.processPayslipImage(
        selectedImage.value!,
      );

      if (result != null) {
        extractedData.value = result;
        await _saveToHistory(result);

        Get.snackbar(
          'Success',
          'Payslip processed successfully!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        _handleError('Failed to extract data from image');
      }
    } catch (e) {
      _handleError('Error processing image: $e');
    } finally {
      isProcessing.value = false;
    }
  }

  /// Handle errors
  void _handleError(String message) {
    errorMessage.value = message;
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  /// Retry processing current image
  Future<void> retryProcessing() async {
    if (selectedImage.value != null) {
      await _processImage();
    }
  }

  /// Clear current session
  void clearSession() {
    isProcessing.value = false;
    selectedImage.value = null;
    extractedData.value = null;
    errorMessage.value = '';
  }

  /// Get latest payslip for dashboard
  PayslipModel? get latestPayslip {
    return payslipHistory.isNotEmpty ? payslipHistory.first : null;
  }

  /// Show image picker options
  void showImagePickerOptions() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Select Image Source',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildImageSourceOption(
                  icon: Icons.camera_alt,
                  label: 'Camera',
                  onTap: () {
                    Get.back();
                    pickFromCamera();
                  },
                ),
                _buildImageSourceOption(
                  icon: Icons.photo_library,
                  label: 'Gallery',
                  onTap: () {
                    Get.back();
                    pickFromGallery();
                  },
                ),
              ],
            ),

            const SizedBox(height: 20),
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSourceOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 40, color: Colors.blue),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
