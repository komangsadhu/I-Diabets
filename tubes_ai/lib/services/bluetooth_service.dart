import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'dart:typed_data';

class BluetoothService {
  BluetoothConnection? _connection;

  Future<void> connectToESP(
    String address,
    Function(String) onDataReceived,
  ) async {
    try {
      _connection = await BluetoothConnection.toAddress(address);
      print('✅ Connected to $address');

      _connection?.input
          ?.listen((Uint8List data) {
            final incoming = String.fromCharCodes(data).trim();
            print('📥 Received: $incoming');
            onDataReceived(incoming);
          })
          .onDone(() {
            print('🔌 Disconnected from $address');
          });
    } catch (e) {
      print('❌ Connection failed: $e');
    }
  }

  void sendData(String data) {
    _connection?.output.add(Uint8List.fromList(data.codeUnits));
    _connection?.output.allSent;
  }

  void disconnect() {
    _connection?.dispose();
    _connection = null;
  }

  bool get isConnected => _connection != null && _connection!.isConnected;
}
