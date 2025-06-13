import 'package:flutter/material.dart';

class RecommendationPage extends StatelessWidget {
  const RecommendationPage({super.key});

  Widget _buildCard(String title, String description, IconData icon) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      color: Colors.white,
      child: ListTile(
        leading: Icon(icon, size: 32, color: Colors.teal),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(description),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F4F7),
      appBar: AppBar(
        title: const Text('Rekomendasi Penyembuhan'),
        backgroundColor: Colors.teal,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            '✅ Langkah-Langkah Penyembuhan & Manajemen Diabetes',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),

          _buildCard(
            'Pola Makan Sehat',
            'Konsumsi serat tinggi (sayur, buah, biji-bijian), hindari gula berlebih dan karbo olahan.',
            Icons.restaurant_menu,
          ),
          _buildCard(
            'Aktivitas Fisik Teratur',
            'Berjalan, berenang, atau bersepeda minimal 30 menit sehari secara konsisten.',
            Icons.directions_walk,
          ),
          _buildCard(
            'Monitoring Gula Darah',
            'Cek kadar glukosa secara berkala dan catat hasil untuk evaluasi medis.',
            Icons.monitor_heart,
          ),
          _buildCard(
            'Konsultasi Medis',
            'Temui dokter untuk evaluasi dan penyesuaian obat sesuai kebutuhan.',
            Icons.local_hospital,
          ),
          _buildCard(
            'Manajemen Stres',
            'Lakukan relaksasi seperti meditasi, yoga, atau aktivitas menyenangkan.',
            Icons.self_improvement,
          ),

          const SizedBox(height: 30),
          Center(
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back),
              label: const Text("Kembali"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                minimumSize: const Size(150, 45),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
