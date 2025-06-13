import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:permission_handler/permission_handler.dart'; // Tambahkan ini
import 'pages/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Firebase
  await Firebase.initializeApp();

  // ====== PERMINTAAN IZIN BLUETOOTH ======
  await Permission.bluetooth.request(); // Untuk Android <13
  await Permission.bluetoothScan.request(); // Untuk Android 12+
  await Permission.bluetoothConnect.request(); // Untuk Android 12+
  await Permission.location.request(); // Kadang tetap dibutuhkan untuk pairing

  runApp(const DiabetesApp());
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
      home: const LoginPage(), // Tetap ke halaman login
    );
  }
}
