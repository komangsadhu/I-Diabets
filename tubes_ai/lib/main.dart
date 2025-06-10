import 'package:firebase_core/firebase_core.dart'; // Import Firebase Core
import 'package:flutter/material.dart';
import 'pages/login_page.dart';

void main() async {
  // Pastikan Firebase diinisialisasi terlebih dahulu sebelum aplikasi berjalan
  WidgetsFlutterBinding.ensureInitialized(); // Memastikan binding siap
  await Firebase.initializeApp(); // Inisialisasi Firebase
  runApp(const DiabetesApp()); // Jalankan aplikasi setelah Firebase siap
}

class DiabetesApp extends StatelessWidget {
  const DiabetesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Penentuan Diabetes',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: false,
      ),
      home: const LoginPage(), // Tampilkan LoginPage saat pertama kali
    );
  }
}
