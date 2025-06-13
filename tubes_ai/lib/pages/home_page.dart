import 'package:flutter/material.dart';
import '/services/bluetooth_service.dart';
import 'bluetooth_scan_page.dart';
import 'recomendation_page.dart';

class HomePageSensor extends StatefulWidget {
  const HomePageSensor({super.key});

  @override
  State<HomePageSensor> createState() => _HomePageSensorState();
}

class _HomePageSensorState extends State<HomePageSensor> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _bmiController = TextEditingController();
  final TextEditingController _glucoseController = TextEditingController();
  final TextEditingController _bpController = TextEditingController();

  String _result = "";
  bool _isConnected = false;

  BluetoothService? _bluetoothService;

  void _predictDiabetes() {
    final age = int.tryParse(_ageController.text) ?? 0;
    final bmi = double.tryParse(_bmiController.text) ?? 0.0;
    final glucose = double.tryParse(_glucoseController.text) ?? 0.0;
    final bp = double.tryParse(_bpController.text) ?? 0.0;

    String result;

    // LOGIKA KEPUTUSAN SIMULASI DECISION TREE BERDASARKAN DATASET
    if (glucose > 140) {
      if (bmi > 30) {
        result = "Berisiko Diabetes";
      } else {
        if (bp > 80) {
          result = "Berisiko Diabetes";
        } else {
          result = "Tidak Berisiko Diabetes";
        }
      }
    } else {
      if (age > 50) {
        result = "Berisiko Diabetes";
      } else {
        result = "Tidak Berisiko Diabetes";
      }
    }

    setState(() {
      _result = result;
    });

    if (result == "Berisiko Diabetes") {
      Future.delayed(const Duration(milliseconds: 300), () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const RecommendationPage()),
        );
      });
    }
  }

  @override
  void dispose() {
    _ageController.dispose();
    _bmiController.dispose();
    _glucoseController.dispose();
    _bpController.dispose();
    super.dispose();
  }

  Widget buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool readOnly = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.grey[100],
        ),
        keyboardType: TextInputType.number,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F4F7),
      appBar: AppBar(
        title: const Text('Deteksi Dini Diabetes'),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: Icon(
              _isConnected ? Icons.bluetooth_connected : Icons.bluetooth,
              color: Colors.white,
            ),
            onPressed: () async {
              final selectedDevice = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BluetoothScanPage(),
                ),
              );

              if (selectedDevice != null) {
                _bluetoothService = BluetoothService();
                _bluetoothService!.connectToESP(selectedDevice.address, (data) {
                  setState(() {
                    _isConnected = true;
                    List<String> parts = data.split('|');
                    for (String part in parts) {
                      if (part.contains("TEMP:")) {
                        _bmiController.text = part.split(':')[1];
                      } else if (part.contains("BPM:")) {
                        _bpController.text = part.split(':')[1];
                      }
                    }
                  });
                });
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  buildInputField(
                    controller: _ageController,
                    label: 'Usia',
                    icon: Icons.cake,
                  ),
                  buildInputField(
                    controller: _bmiController,
                    label: 'BMI (dari suhu)',
                    icon: Icons.thermostat,
                    readOnly: true,
                  ),
                  buildInputField(
                    controller: _glucoseController,
                    label: 'Kadar Glukosa (mg/dL)',
                    icon: Icons.bloodtype,
                  ),
                  buildInputField(
                    controller: _bpController,
                    label: 'Tekanan Darah (dari BPM)',
                    icon: Icons.monitor_heart,
                    readOnly: true,
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: _predictDiabetes,
                    icon: const Icon(Icons.analytics_outlined),
                    label: const Text("Prediksi"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _result,
                    style: TextStyle(
                      fontSize: 20,
                      color:
                          _result.contains("Berisiko")
                              ? Colors.red
                              : Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
