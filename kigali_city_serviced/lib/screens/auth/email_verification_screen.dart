import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({Key? key}) : super(key: key);

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  bool _isChecking = false;

  void _checkEmailVerification() async {
    setState(() => _isChecking = true);
    
    final authProvider = context.read<AuthProvider>();
    await authProvider.checkEmailVerification();
    
    setState(() => _isChecking = false);
  }

  @override
  void initState() {
    super.initState();
    // Auto-check after 3 seconds
    Future.delayed(const Duration(seconds: 3), _checkEmailVerification);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.mail_outline,
              size: 80,
              color: Colors.blue[900],
            ),
            const SizedBox(height: 32),
            Text(
              'Verify Your Email',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[900],
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Consumer<AuthProvider>(
              builder: (context, authProvider, _) {
                return Column(
                  children: [
                    Text(
                      'A verification email has been sent to ${authProvider.currentUser?.email}',
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _isChecking ? null : _checkEmailVerification,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isChecking
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('I have verified my email',
                                style: TextStyle(fontSize: 16)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () =>
                          authProvider.sendEmailVerification(),
                      child: const Text('Resend verification email'),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
