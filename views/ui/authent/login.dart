import 'package:classico/constants/app_constants.dart';
import 'package:classico/controllers/exports.dart';
import 'package:classico/views/common/app_bar.dart';
import 'package:classico/views/common/app_style.dart';
import 'package:classico/views/common/custom_btn.dart';
import 'package:classico/views/common/custom_textfield.dart';
import 'package:classico/views/common/height_spacer.dart';
import 'package:classico/views/common/reusable_text.dart';
import 'package:classico/views/ui/authent/signup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:classico/views/ui/onboarding/onboarding_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  Future<void> loginUser() async {
    final url = Uri.parse('http://localhost:3000/login');

    if (_formKey.currentState!.validate()) {
      try {
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'email': email.text,
            'password': password.text,
          }),
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final token = data['token'];
          print('Login successful: $token');
          // Navigate to HomePage after successful login
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const OnboardingScreen()),
          );
        } else {
          final errorData = jsonDecode(response.body);
          print('Login failed: ${errorData['message']}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Login failed: ${errorData['message']}')),
          );
        }
      } catch (error) {
        print('Error: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred. Please try again.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginNotifier>(
      builder: (context, loginNotifier, child) {
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(50),
            child: CustomAppBar(
              text: "Login",
              child: GestureDetector(
                onTap: () => Get.back(),
                child: const Icon(CupertinoIcons.arrow_left),
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  HeightSpacer(size: 50),
                  ReusableText(
                    text: "Welcome Back",
                    style: appstyle(30, Color(kDark.value), FontWeight.w600),
                  ),
                  ReusableText(
                    text: "Fill in the details to log in to your account",
                    style:
                        appstyle(16, Color(kDarkGrey.value), FontWeight.w500),
                  ),
                  HeightSpacer(size: 50),
                  CustomTextfield(
                    controller: email,
                    keyboardType: TextInputType.emailAddress,
                    hintText: "Email",
                    obscureText: false,
                    validator: (value) {
                      if (value == null || !value.contains("@")) {
                        return "Please enter a valid email";
                      }
                      return null;
                    },
                  ),
                  HeightSpacer(size: 30),
                  CustomTextfield(
                    controller: password,
                    keyboardType: TextInputType.text,
                    hintText: "Password",
                    obscureText: loginNotifier.obscureText,
                    validator: (value) {
                      if (value == null || value.length < 7) {
                        return "Please enter a valid password";
                      }
                      return null;
                    },
                    suffixIcon: GestureDetector(
                      onTap: loginNotifier.togglePasswordVisibility,
                      child: Icon(
                        loginNotifier.obscureText
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Color(kDark.value),
                      ),
                    ),
                  ),
                  HeightSpacer(size: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () => Get.to(() => const RegistrationPage()),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Don't have an account? ",
                              style: appstyle(
                                  14, Color(kLightBlue.value), FontWeight.w500),
                            ),
                            TextSpan(
                              text: "Sign up",
                              style: appstyle(
                                  14, Color(kOrange.value), FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  HeightSpacer(size: 50),
                  CustomButton(
                    OnTap: loginUser,
                    text: "Login",
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
