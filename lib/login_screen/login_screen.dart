import 'package:flutter/material.dart';
import '../dashboard_screen/dashboard_screen.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../dashboard_screen/service/dashboard_service.dart';
import '../registration_page/registration_screen.dart';  // ✅ import register page
import '../forgot_password/forgot_password_screen.dart';  // ✅ import forgot password page
import './login_service/login_service.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // fallback
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.26, 1.0],
            colors: [
              Color(0xFF121212), // top dark
              Color(0xFF1F1F1F), // bottom slightly lighter dark
            ],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // driver logo/icon
                  Icon(
                    Icons.local_taxi_rounded,
                    size: 80,
                    color: const Color(0xFFD7B65D),
                  ),
                  const SizedBox(height: 16),

                  // title
                  Text(
                    "Driver Login",
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      color: Color(0xFFD7B65D), // gold accent
                    ),
                  ),
                  const SizedBox(height: 30),

                  // card
                  Container(
                    padding: const EdgeInsets.all(20.0),
                    width: 340,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A2A2A),
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.6),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // email field
                        TextField(
                          controller: _emailController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xFF1A1A1A),
                            labelText: 'Email',
                            prefixIcon: const Icon(Icons.email, color: Color(0xFFD7B65D)),
                            labelStyle: const TextStyle(color: Colors.white70),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Color(0xFFD7B65D)),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Color(0xFFD7B65D), width: 2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 20),

                        // password field
                        TextField(
                          controller: _passwordController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xFF1A1A1A),
                            labelText: 'Password',
                            prefixIcon: const Icon(Icons.lock, color: Color(0xFFD7B65D)),
                            labelStyle: const TextStyle(color: Colors.white70),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Color(0xFFD7B65D)),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Color(0xFFD7B65D), width: 2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          obscureText: true,
                        ),

                        // forgot password
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ForgotPasswordScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              "Forgot Password?",
                              style: TextStyle(color: Colors.white70),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // login button
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFD7B65D),
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            textStyle: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          // onPressed: _isLoading
                          //     ? null
                          //     : () async {
                          //         setState(() => _isLoading = true);

                          //         // simulate login for now
                          //         await Future.delayed(const Duration(seconds: 1));

                          //         setState(() => _isLoading = false);

                          //         Navigator.push(
                          //           context,
                          //           MaterialPageRoute(
                          //             builder: (context) => DashboardScreen(
                          //               dashboardService: DashboardService(
                          //                 baseUrl: dotenv.env['API_BASE_URL'] ?? '',
                          //                 client: http.Client(),
                          //               ),
                          //             ),
                          //           ),
                          //         );
                          //       },
                          onPressed: _isLoading
                            ? null
                            : () async {
                                setState(() => _isLoading = true);

                                final loginService = LoginService(
                                  baseUrl: dotenv.env['API_BASE_URL'] ?? "http://localhost:5000/api",
                                  client: http.Client(),
                                );

                                final result = await loginService.loginDriver(
                                  email: _emailController.text.trim(),
                                  password: _passwordController.text.trim(),
                                );

                                setState(() => _isLoading = false);

                                if (result["success"] == true) {
                                  // ✅ Navigate to dashboard
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DashboardScreen(
                                        dashboardService: DashboardService(
                                          baseUrl: dotenv.env['API_BASE_URL'] ?? '',
                                          client: http.Client(),
                                        ),
                                      ),
                                    ),
                                  );
                                } else {
                                  // ❌ Show snackbar error
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(result["error"] ?? "Login failed"),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              },
                          child: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                                  ),
                                )
                              : const Text("Login"),
                        ),

                        const SizedBox(height: 16),

                        // don't have account -> register
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Don't have an account? ",
                              style: TextStyle(color: Colors.white70),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RegistrationScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                "Register Now",
                                style: TextStyle(
                                  color: Color(0xFFD7B65D),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
