import 'package:flutter/material.dart';
import '/services/bluetooth_service.dart';
import 'bluetooth_scan_page.dart';

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
    if (glucose > 140 || bmi > 30 || bp > 90 || age > 45) {
      result = "Berisiko Diabetes";
    } else {
      result = "Tidak Berisiko Diabetes";
    }

    setState(() {
      _result = result;
    });
  }

  @override
  void dispose() {
    _ageController.dispose();
    _bmiController.dispose();
    _glucoseController.dispose();
    _bpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aplikasi Penentuan Diabetes'),
        actions: [
          IconButton(
            icon: Icon(
              _isConnected
                  ? Icons.bluetooth_connected
                  : Icons.bluetooth_disabled,
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
          const SizedBox(width: 16),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _ageController,
                decoration: const InputDecoration(
                  labelText: 'Usia',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _bmiController,
                decoration: const InputDecoration(
                  labelText: 'BMI (diisi otomatis dari suhu)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _glucoseController,
                decoration: const InputDecoration(
                  labelText: 'Kadar Glukosa (mg/dL)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _bpController,
                decoration: const InputDecoration(
                  labelText: 'Tekanan Darah (diisi otomatis dari BPM)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _predictDiabetes,
                child: const Text("Prediksi"),
              ),
              const SizedBox(height: 20),
              Text(
                _result,
                style: TextStyle(
                  fontSize: 20,
                  color:
                      _result.contains("Berisiko") ? Colors.red : Colors.green,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
