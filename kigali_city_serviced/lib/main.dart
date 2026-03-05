import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'providers/auth_provider.dart';
import 'providers/listing_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/auth/email_verification_screen.dart';
import 'screens/home/home_screen.dart';
import 'utils/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  bool _isLoginMode = true;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ListingProvider()),
      ],
      child: MaterialApp(
        title: 'Kigali City Services',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.light,
        home: Consumer<AuthProvider>(
          builder: (context, authProvider, _) {
            // Not authenticated - show auth screens
            if (!authProvider.isAuthenticated) {
              return _isLoginMode
                  ? LoginScreen(
                      onSignUpTap: () {
                        setState(() => _isLoginMode = false);
                      },
                    )
                  : SignUpScreen(
                      onLoginTap: () {
                        setState(() => _isLoginMode = true);
                      },
                    );
            }

            // Authenticated but email not verified - show verification screen
            if (!authProvider.isEmailVerified) {
              return const EmailVerificationScreen();
            }

            // Authenticated and email verified - show home screen
            return const HomeScreen();
          },
        ),
      ),
    );
  }
}
