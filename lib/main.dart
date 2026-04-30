import 'package:flutter/material.dart';
import 'package:payer/screens/insurance_list_screen.dart';
import 'screens/login_screen.dart';
//import 'screens/home_screen.dart';
import 'services/session_service.dart';

void main() async {
  // Flutter binding ensure karna kyunke hum async kaam kar rahe hain
  WidgetsFlutterBinding.ensureInitialized();

  // Session check karna takay user ko dobara login na karna paray
  int? userId = await SessionService.getUserId();

  runApp(PayerApp(startUserId: userId));
}

class PayerApp extends StatelessWidget {
  final int? startUserId;

  PayerApp({this.startUserId});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Payer Insurance App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        // Figma colors ke mutabiq theme customize kar saktay hain
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Colors.black),
        ),
      ),
      // Agar userId null nahi hai to seedha Home par bhejein
      home: startUserId != null ? HomeScreen() : LoginScreen(),

      // Routes define kar saktay hain agar asani chahiye
      routes: {
        '/login': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),
      },
    );
  }
}
