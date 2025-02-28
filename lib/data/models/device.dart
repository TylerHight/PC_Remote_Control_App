import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class Device {
  final String id;
  final String name;
  final String? ipAddress;
  final bool isConnected;
  final BluetoothDevice? bleDevice;
  final int? rssi;

  const Device({
    required this.id,
    required this.name,
    this.ipAddress,
    this.isConnected = false,
    this.bleDevice,
    this.rssi,
  });

  Device copyWith({
    String? id,
    String? name,
    String? ipAddress,
    bool? isConnected,
    BluetoothDevice? bleDevice,
    int? rssi,
  }) {
    return Device(
      id: id ?? this.id,
      name: name ?? this.name,
      ipAddress: ipAddress ?? this.ipAddress,
      isConnected: isConnected ?? this.isConnected,
      bleDevice: bleDevice ?? this.bleDevice,
      rssi: rssi ?? this.rssi,
    );
  }
}
