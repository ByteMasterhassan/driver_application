import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePictureStep extends StatefulWidget {
  final File? profileImage;
  final Function(File) onImageSelected;
  final VoidCallback onNext;
  final bool isLoading;

  const ProfilePictureStep({
    Key? key,
    required this.profileImage,
    required this.onImageSelected,
    required this.onNext,
    required this.isLoading,
  }) : super(key: key);

  @override
  _ProfilePictureStepState createState() => _ProfilePictureStepState();
}

class _ProfilePictureStepState extends State<ProfilePictureStep> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(
      source: source,
      maxWidth: 600,
      imageQuality: 80, // compressed for performance
    );

    if (pickedFile != null) {
      widget.onImageSelected(File(pickedFile.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(20.0),
            width: 340,
            decoration: _cardDecoration(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Upload Profile Picture",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFD7B65D)),
                ),
                const SizedBox(height: 20),

                // Profile image preview
                CircleAvatar(
                  radius: 70,
                  backgroundColor: Colors.grey[800],
                  backgroundImage: widget.profileImage != null
                      ? FileImage(widget.profileImage!)
                      : null,
                  child: widget.profileImage == null
                      ? const Icon(Icons.person,
                          size: 70, color: Colors.white70)
                      : null,
                ),
                const SizedBox(height: 20),

                // Camera button
                ElevatedButton.icon(
                  style: _uploadButtonStyle(),
                  icon: const Icon(Icons.camera_alt),
                  label: Text(widget.profileImage == null
                      ? "Take Photo"
                      : "Retake Photo"),
                  onPressed: () => _pickImage(ImageSource.camera),
                ),
                const SizedBox(height: 12),

                // Gallery button (hide after upload if you want)
                if (widget.profileImage == null)
                  ElevatedButton.icon(
                    style: _uploadButtonStyle(),
                    icon: const Icon(Icons.image),
                    label: const Text("Choose from Gallery"),
                    onPressed: () => _pickImage(ImageSource.gallery),
                  ),
              ],
            ),
          ),
        ),
      ),

      // Continue button pinned at bottom
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SizedBox(
          width: double.infinity,
          child: _buildNextButton("Continue"),
        ),
      ),
    );
  }

  Widget _buildNextButton(String text) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFD7B65D),
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
      ),
      onPressed: widget.isLoading ? null : widget.onNext,
      child: widget.isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
              ),
            )
          : Text(text),
    );
  }

  ButtonStyle _uploadButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFFD7B65D),
      foregroundColor: Colors.black,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: const Color(0xFF2A2A2A),
      borderRadius: BorderRadius.circular(20.0),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.6),
          blurRadius: 12,
          offset: const Offset(0, 6),
        ),
      ],
    );
  }
}
