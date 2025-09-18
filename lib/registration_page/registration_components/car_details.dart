import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// import '../../registration_page/registration_service/registration_service.dart'

class CarDetailsStep extends StatelessWidget {
  final List<File> carImages;
  final Function(File) onImageAdded;
  final VoidCallback onNext;
  final bool isLoading;

  // Controllers for car info fields
  final TextEditingController brandController;     // vehicleBrand
  final TextEditingController modelController;     // vehicleModel
  final TextEditingController colorController;     // vehicleColor
  final TextEditingController yearController;      // productionYear
  final TextEditingController numberPlateController; // numberPlate
  final TextEditingController luggageController;   // luggage
  final TextEditingController passengersController; // passengers
  final TextEditingController flatRateController;  // flat_rate
  final TextEditingController pricePerKmController; // pricePerKm

  const CarDetailsStep({
    Key? key,
    required this.carImages,
    required this.onImageAdded,
    required this.onNext,
    required this.isLoading,
    required this.brandController,
    required this.modelController,
    required this.colorController,
    required this.yearController,
    required this.numberPlateController,
    required this.luggageController,
    required this.passengersController,
    required this.flatRateController,
    required this.pricePerKmController,
  }) : super(key: key);

  Future<void> _pickImage(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await showDialog<XFile?>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text("Select Image"),
        children: [
          SimpleDialogOption(
            onPressed: () async {
              final picked = await picker.pickImage(source: ImageSource.camera);
              Navigator.pop(ctx, picked);
            },
            child: const Text("Camera"),
          ),
          SimpleDialogOption(
            onPressed: () async {
              final picked = await picker.pickImage(source: ImageSource.gallery);
              Navigator.pop(ctx, picked);
            },
            child: const Text("Gallery"),
          ),
        ],
      ),
    );

    if (pickedFile != null) {
      onImageAdded(File(pickedFile.path));
    }
  }

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

            _buildTextField("Car Brand", brandController),
            const SizedBox(height: 10),

            _buildTextField("Car Model", modelController),
            const SizedBox(height: 10),

            _buildTextField("Car Color", colorController),
            const SizedBox(height: 10),

            _buildTextField("Production Year", yearController,
                keyboardType: TextInputType.number),
            const SizedBox(height: 10),

            _buildTextField("Number Plate", numberPlateController),
            const SizedBox(height: 10),

            _buildTextField("Luggage Capacity", luggageController,
                keyboardType: TextInputType.number),
            const SizedBox(height: 10),

            _buildTextField("Passenger Capacity", passengersController,
                keyboardType: TextInputType.number),
            const SizedBox(height: 10),

            _buildTextField("Flat Rate (per day)", flatRateController,
                keyboardType: TextInputType.number),
            const SizedBox(height: 10),

            _buildTextField("Price per Km", pricePerKmController,
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
                      onTap: () => _pickImage(context),
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
