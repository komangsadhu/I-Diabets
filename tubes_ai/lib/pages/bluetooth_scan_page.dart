import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class BluetoothScanPage extends StatelessWidget {
  const BluetoothScanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pilih Perangkat Bluetooth")),
      body: FutureBuilder<List<BluetoothDevice>>(
        future: FlutterBluetoothSerial.instance.getBondedDevices(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Tidak ada perangkat terhubung."));
          }

          return ListView(
            children:
                snapshot.data!.map((device) {
                  return ListTile(
                    leading: const Icon(Icons.bluetooth),
                    title: Text(device.name ?? "Unknown"),
                    subtitle: Text(device.address),
                    onTap: () {
                      Navigator.pop(context, device);
                    },
                  );
                }).toList(),
          );
        },
      ),
    );
  }
}
