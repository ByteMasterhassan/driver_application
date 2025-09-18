// import 'dart:io';
// import 'package:flutter/material.dart';
// import './../login_screen/login_screen.dart';
// import '../approval_screen/approval_screen.dart';

// // Import step widgets
// import '../registration_page/registration_components/user_info.dart';
// import '../registration_page/registration_components/profile_picture.dart';
// import '../registration_page/registration_components/car_details.dart';

// class RegistrationScreen extends StatefulWidget {
//   @override
//   _RegistrationScreenState createState() => _RegistrationScreenState();
// }

// class _RegistrationScreenState extends State<RegistrationScreen> {
//   final PageController _pageController = PageController();
//   int _currentStep = 0;
//   bool _isLoading = false;

//   // Step 1 controllers
//   late final TextEditingController _nameController;
//   late final TextEditingController _emailController;
//   late final TextEditingController _phoneController;
//   late final TextEditingController _passwordController;
//   late final TextEditingController _confirmPasswordController;
//   late final TextEditingController _usernameController;
//   late final TextEditingController _dobController;

//   // Step 3 car details controllers
//   // late final TextEditingController makeController;
//   // late final TextEditingController modelController;
//   // late final TextEditingController yearController;
//   // late final TextEditingController rateController;

// late final TextEditingController brandController;
// late final TextEditingController modelController;
// late final TextEditingController colorController;
// late final TextEditingController yearController;
// late final TextEditingController numberPlateController;
// late final TextEditingController luggageController;
// late final TextEditingController passengersController;
// late final TextEditingController flatRateController;
// late final TextEditingController pricePerKmController;

//   // Step 2 profile picture
//   File? _profileImage;

//   // Step 3 car images
//   final List<File> _carImages = [];

//   @override
//   void initState() {
//     super.initState();
//     // ✅ Initialize controllers here
//     _nameController = TextEditingController();
//     _emailController = TextEditingController();
//     _phoneController = TextEditingController();
//     _passwordController = TextEditingController();
//     _confirmPasswordController = TextEditingController();
//     _usernameController = TextEditingController();   // 🔹 initialize
//     _dobController = TextEditingController(); 

//     brandController = TextEditingController();
//     modelController = TextEditingController();
//     colorController = TextEditingController();
//     yearController = TextEditingController();
//     numberPlateController = TextEditingController();
//     luggageController = TextEditingController();
//     passengersController = TextEditingController();
//     flatRateController = TextEditingController();
//     pricePerKmController = TextEditingController();
//   }

//   void _nextStep() {
//     if (_currentStep < 2) {
//       setState(() => _currentStep++);
//       _pageController.nextPage(
//         duration: const Duration(milliseconds: 400),
//         curve: Curves.easeInOut,
//       );
//     } else {
//       _register();
//     }
//   }

//   void _prevStep() {
//     if (_currentStep > 0) {
//       setState(() => _currentStep--);
//       _pageController.previousPage(
//         duration: const Duration(milliseconds: 400),
//         curve: Curves.easeInOut,
//       );
//     }
//   }

//   void _register() async {
//     setState(() => _isLoading = true);
//     await Future.delayed(const Duration(seconds: 2));
//     setState(() => _isLoading = false);

//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => ApprovalScreen()),
//     );
//   }

//   @override
//   void dispose() {
//     // Always dispose controllers to prevent memory leaks
//     _nameController.dispose();
//     _emailController.dispose();
//     _phoneController.dispose();
//     _passwordController.dispose();
//     _confirmPasswordController.dispose();
//     _usernameController.dispose();   // 🔹 clean up
//     _dobController.dispose(); 

//     brandController.dispose();
//     modelController.dispose();
//     yearController.dispose();
//     colorController.dispose();
//     numberPlateController.dispose();
//     luggageController.dispose();
//     passengersController.dispose();
//     flatRateController.dispose();
//     pricePerKmController.dispose();

//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             stops: [0.26, 1.0],
//             colors: [Color(0xFF121212), Color(0xFF1F1F1F)],
//           ),
//         ),
//         child: Column(
//           children: [
//             const SizedBox(height: 50),

//             // Header with Back button
//             Row(
//               children: [
//                 if (_currentStep > 0)
//                   IconButton(
//                     icon: const Icon(
//                       Icons.arrow_back,
//                       color: Color(0xFFD7B65D),
//                     ),
//                     onPressed: _prevStep,
//                   ),
//                 Expanded(
//                   child: Center(
//                     child: Text(
//                       "Step ${_currentStep + 1} of 3",
//                       style: const TextStyle(
//                         color: Colors.white70,
//                         fontSize: 16,
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 48),
//               ],
//             ),
//             const SizedBox(height: 10),

//             Expanded(
//               child: PageView(
//                 controller: _pageController,
//                 physics: const NeverScrollableScrollPhysics(),
//                 children: [
//                   UserInfoStep(
//                     nameController: _nameController,
//                     emailController: _emailController,
//                     phoneController: _phoneController,
//                     passwordController: _passwordController,
//                     confirmPasswordController: _confirmPasswordController,
//                     usernameController: _usernameController,
//                     dobController: _dobController,
//                     onNext: _nextStep,
//                     isLoading: _isLoading,
//                   ),
//                   ProfilePictureStep(
//                     profileImage: _profileImage,
//                     onImageSelected:
//                         (file) => setState(() => _profileImage = file),
//                     onNext: _nextStep,
//                     isLoading: _isLoading,
//                   ),
//                   CarDetailsStep(
//                     carImages: _carImages,
//                     onImageAdded: (file) => setState(() => _carImages.add(file)),
//                     onNext: _nextStep,
//                     isLoading: _isLoading,

//                     // ✅ Updated controllers according to new fields
//                     brandController: brandController,         // vehicleBrand
//                     modelController: modelController,         // vehicleModel
//                     colorController: colorController,         // vehicleColor
//                     yearController: yearController,           // productionYear
//                     numberPlateController: numberPlateController, // numberPlate
//                     luggageController: luggageController,     // luggage
//                     passengersController: passengersController, // passengers
//                     flatRateController: flatRateController,   // flat_rate
//                     pricePerKmController: pricePerKmController, // pricePerKm
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'dart:io';
import 'package:flutter/material.dart';
import './../login_screen/login_screen.dart';
import '../approval_screen/approval_screen.dart';

// Import step widgets
import '../registration_page/registration_components/user_info.dart';
import '../registration_page/registration_components/profile_picture.dart';
import '../registration_page/registration_components/car_details.dart';

// ✅ Import the service
import '../registration_page/registration_service/registration_service.dart';

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
  late final TextEditingController _usernameController;
  late final TextEditingController _dobController;

  // Step 3 controllers
  late final TextEditingController brandController;
  late final TextEditingController modelController;
  late final TextEditingController colorController;
  late final TextEditingController yearController;
  late final TextEditingController numberPlateController;
  late final TextEditingController luggageController;
  late final TextEditingController passengersController;
  late final TextEditingController flatRateController;
  late final TextEditingController pricePerKmController;

  // Step 2 profile picture
  File? _profileImage;

  // Step 3 car images
  final List<File> _carImages = [];

  @override
  void initState() {
    super.initState();
    // Initialize controllers
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _usernameController = TextEditingController();
    _dobController = TextEditingController();

    brandController = TextEditingController();
    modelController = TextEditingController();
    colorController = TextEditingController();
    yearController = TextEditingController();
    numberPlateController = TextEditingController();
    luggageController = TextEditingController();
    passengersController = TextEditingController();
    flatRateController = TextEditingController();
    pricePerKmController = TextEditingController();
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

  /// 🔹 Register driver + vehicle using the service
  void _register() async {
    setState(() => _isLoading = true);

    try {
      final success = await RegisterService().registerDriverAndVehicle(
        // Step 1 user info
        name: _nameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        password: _passwordController.text,
        confirmPassword: _confirmPasswordController.text,
        username: _usernameController.text,
        dateOfBirth: _dobController.text,
        profileImage: _profileImage, // Step 2 profile picture

        // Step 3 vehicle info
        vehicleBrand: brandController.text,
        vehicleModel: modelController.text,
        vehicleColor: colorController.text,
        productionYear: yearController.text,
        numberPlate: numberPlateController.text,
        luggage: luggageController.text,
        passengers: passengersController.text,
        flatRate: flatRateController.text,
        pricePerKm: pricePerKmController.text,
        carImages: _carImages,
      );

      if (success) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ApprovalScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Registration failed, please try again.")),
        );
      }
    } catch (e) {
      debugPrint("❌ Registration error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Something went wrong: $e")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    // Dispose controllers
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _usernameController.dispose();
    _dobController.dispose();

    brandController.dispose();
    modelController.dispose();
    yearController.dispose();
    colorController.dispose();
    numberPlateController.dispose();
    luggageController.dispose();
    passengersController.dispose();
    flatRateController.dispose();
    pricePerKmController.dispose();

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
                    usernameController: _usernameController,
                    dobController: _dobController,
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
                    onImageAdded: (file) => setState(() => _carImages.add(file)),
                    onNext: _nextStep,
                    isLoading: _isLoading,

                    brandController: brandController,
                    modelController: modelController,
                    colorController: colorController,
                    yearController: yearController,
                    numberPlateController: numberPlateController,
                    luggageController: luggageController,
                    passengersController: passengersController,
                    flatRateController: flatRateController,
                    pricePerKmController: pricePerKmController,
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
