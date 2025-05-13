import 'package:etubm/firebase_options.dart';
import 'package:etubm/layouts/main_layout.dart';
import 'package:etubm/pages/login_page.dart';
import 'package:etubm/pages/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'layouts/theme_notifier.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

final themeNotifier = ThemeNotifier();
final ThemeData customDarkTheme = ThemeData.dark().copyWith(
  scaffoldBackgroundColor: Colors.black,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.black,
    iconTheme: IconThemeData(color: Colors.white),
    titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
  ),
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: Colors.white),
    bodyMedium: TextStyle(color: Colors.white70),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.grey[850],
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    hintStyle: TextStyle(color: Colors.white70),
  ),
  switchTheme: SwitchThemeData(
    thumbColor: MaterialStateProperty.all(Colors.blue),
    trackColor: MaterialStateProperty.all(Colors.blueGrey),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.blue[700],
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  ),
);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, currentTheme, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          themeMode: currentTheme,
          theme: ThemeData.light(),
          darkTheme: customDarkTheme,
          home: CheckLoginStatus(),
        );
      },
    );
  }
}

class CheckLoginStatus extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance
          .authStateChanges(), // Kullanıcı giriş-çıkışlarını dinler
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          ); // Yükleniyor ekranı
        }

        if (snapshot.hasData) {
          return MainLayout(
              child:
                  HomeScreen()); // Kullanıcı giriş yaptıysa ana ekrana yönlendir
        } else {
          return LoginScreen(); // Kullanıcı giriş yapmadıysa login ekranına yönlendir
        }
      },
    );
  }
}
