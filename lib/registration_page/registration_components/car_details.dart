import 'dart:io';
import 'package:flutter/material.dart';

class CarDetailsStep extends StatelessWidget {
  final List<File> carImages;
  final Function(File) onImageAdded;
  final VoidCallback onNext;
  final bool isLoading;

  // Controllers for car info fields
  final TextEditingController makeController;
  final TextEditingController modelController;
  final TextEditingController yearController;
  final TextEditingController rateController;

  const CarDetailsStep({
    Key? key,
    required this.carImages,
    required this.onImageAdded,
    required this.onNext,
    required this.isLoading,
    required this.makeController,
    required this.modelController,
    required this.yearController,
    required this.rateController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20.0),
        width: 340,
        decoration: _cardDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Car Details",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFD7B65D))),
            const SizedBox(height: 16),

            // ===== Car Make =====
            _buildTextField("Car Make", makeController),
            const SizedBox(height: 10),

            // ===== Car Model =====
            _buildTextField("Car Model", modelController),
            const SizedBox(height: 10),

            // ===== Car Year =====
            _buildTextField("Car Year", yearController,
                keyboardType: TextInputType.number),
            const SizedBox(height: 10),

            // ===== Flat Rate =====
            _buildTextField("Flat Rate (e.g. per day)", rateController,
                keyboardType: TextInputType.number),
            const SizedBox(height: 20),

            const Text("Upload Car Images",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFD7B65D))),
            const SizedBox(height: 10),

            // ===== Images =====
            Expanded(
              child: GridView.builder(
                itemCount: carImages.length + 1,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                ),
                itemBuilder: (context, index) {
                  if (index == carImages.length) {
                    return GestureDetector(
                      onTap: () {
                        // TODO: Add car image
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[850],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFD7B65D)),
                        ),
                        child: const Icon(Icons.add_a_photo,
                            color: Color(0xFFD7B65D), size: 32),
                      ),
                    );
                  }
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(carImages[index], fit: BoxFit.cover),
                  );
                },
              ),
            ),
            // ===== Sticky Register button =====
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: _buildNextButton("Register"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFFD7B65D)),
        filled: true,
        fillColor: const Color(0xFF1E1E1E),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFFD7B65D)),
          borderRadius: BorderRadius.circular(12),
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
      onPressed: isLoading ? null : onNext,
      child: isLoading
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
