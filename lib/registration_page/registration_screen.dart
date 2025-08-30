import 'dart:io';
import 'package:flutter/material.dart';
import './../login_screen/login_screen.dart';
import '../approval_screen/approval_screen.dart';

// Import step widgets
import '../registration_page/registration_components/user_info.dart';
import '../registration_page/registration_components/profile_picture.dart';
import '../registration_page/registration_components/car_details.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  bool _isLoading = false;

  // Step 1 controllers
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;

  // Step 3 car details controllers
  late final TextEditingController makeController;
  late final TextEditingController modelController;
  late final TextEditingController yearController;
  late final TextEditingController rateController;

  // Step 2 profile picture
  File? _profileImage;

  // Step 3 car images
  final List<File> _carImages = [];

  @override
  void initState() {
    super.initState();
    // ✅ Initialize controllers here
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();

    makeController = TextEditingController();
    modelController = TextEditingController();
    yearController = TextEditingController();
    rateController = TextEditingController();
  }

  void _nextStep() {
    if (_currentStep < 2) {
      setState(() => _currentStep++);
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _register();
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void _register() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _isLoading = false);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ApprovalScreen()),
    );
  }

  @override
  void dispose() {
    // Always dispose controllers to prevent memory leaks
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    makeController.dispose();
    modelController.dispose();
    yearController.dispose();
    rateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.26, 1.0],
            colors: [Color(0xFF121212), Color(0xFF1F1F1F)],
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 50),

            // Header with Back button
            Row(
              children: [
                if (_currentStep > 0)
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Color(0xFFD7B65D),
                    ),
                    onPressed: _prevStep,
                  ),
                Expanded(
                  child: Center(
                    child: Text(
                      "Step ${_currentStep + 1} of 3",
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 48),
              ],
            ),
            const SizedBox(height: 10),

            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  UserInfoStep(
                    nameController: _nameController,
                    emailController: _emailController,
                    phoneController: _phoneController,
                    passwordController: _passwordController,
                    confirmPasswordController: _confirmPasswordController,
                    onNext: _nextStep,
                    isLoading: _isLoading,
                  ),
                  ProfilePictureStep(
                    profileImage: _profileImage,
                    onImageSelected:
                        (file) => setState(() => _profileImage = file),
                    onNext: _nextStep,
                    isLoading: _isLoading,
                  ),
                  CarDetailsStep(
                    carImages: _carImages,
                    onImageAdded:
                        (file) => setState(() => _carImages.add(file)),
                    onNext: _nextStep,
                    isLoading: _isLoading,
                    makeController: makeController,
                    modelController: modelController,
                    yearController: yearController,
                    rateController: rateController,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
