// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:reminder/screens/login_screen.dart';
import 'package:reminder/state/auth/providers/auth_state_provider.dart';
import 'package:reminder/state/auth/notifiers/models/auth_result.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _displayNameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _signup() async {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text;
      final password = _passwordController.text;
      final displayName = _displayNameController.text;

      final result = await ref
          .read(authStateProvider.notifier)
          .signUpWithEmail(email, password, displayName);

      if (result == AuthResult.failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Signup failed. Please try again.')),
        );
      } else if (result == AuthResult.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Signup successful!')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Lottie.asset(
                  'assets/animation/lottie2.json',
                  height: 280,
                  reverse: false,
                  repeat: true,
                  fit: BoxFit.cover,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 25),
                child: Text(
                  "Sign up",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25, right: 40),
                child: TextFormField(
                  controller: _displayNameController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.person,
                      color: Colors.grey[600],
                    ),
                    hintText: 'Username',
                    labelText: 'Username',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a username';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25, right: 40),
                child: TextFormField(
                  controller: _emailController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.email_rounded,
                      color: Colors.grey[600],
                    ),
                    hintText: 'Email ID',
                    labelText: 'Email',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25, right: 40),
                child: TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.lock,
                      color: Colors.grey[600],
                    ),
                    hintText: 'Password',
                    labelText: 'Password',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: _signup,
                child: Padding(
                  padding: const EdgeInsets.only(
                    right: 50,
                    left: 50,
                    top: 20,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    height: 50,
                    width: size.width,
                    child: const Center(
                      child: Text(
                        "Sign up",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 23,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(
                  "Already have an account? ",
                  style: TextStyle(color: Colors.blue[500]),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()),
                    );
                  },
                  child: Text(
                    "Login",
                    style: TextStyle(
                      color: Colors.blue[500],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
