import 'package:flutter/material.dart';

import 'package:groupproject_group5/app/app_routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    this.onSignIn,
    this.onSignUp,
    this.onStaffPortal,
  });

  final VoidCallback? onSignIn;
  final VoidCallback? onSignUp;
  final VoidCallback? onStaffPortal;

  void _signIn(BuildContext context) {
    if (onSignIn != null) {
      onSignIn!();
    } else {
      Navigator.of(context).pushNamed(AppRoutes.login);
    }
  }

  void _signUp(BuildContext context) {
    if (onSignUp != null) {
      onSignUp!();
    } else {
      Navigator.of(context).pushNamed(AppRoutes.register);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              Color(0xFFF8F8EC),
              Color(0xFFF8F8EC),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: <Widget>[
              const Spacer(flex: 1),

              Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromRGBO(0, 0, 0, 0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    'images/home_city_image.png',
                    fit: BoxFit.cover,
                    width: 180,
                    height: 180,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                'Screen time: Build your city',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1E73BE),
                  height: 1.2,
                ),
              ),

              const Spacer(flex: 1),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () => _signIn(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF46AA57),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 8,
                    ),
                    child: const Text(
                      'Sign in',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: OutlinedButton(
                    onPressed: () => _signUp(context),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF46AA57), width: 2),
                      foregroundColor: const Color(0xFF46AA57),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Sign up',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),

              const Spacer(flex: 1),
              if (onStaffPortal != null)
                TextButton(
                  onPressed: onStaffPortal,
                  child: Text(
                    'Staff portal',
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 14,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
