import 'package:equatable/equatable.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:pc_remote_control_app/data/models/device.dart';

enum ConnectionStatus { initial, scanning, connecting, connected, disconnecting, disconnected, error }

class ConnectionState extends Equatable {
  final ConnectionStatus status;
  final Device? device;
  final String? errorMessage;
  final List<Device> discoveredDevices;
  final bool isScanning;

  const ConnectionState({
    this.status = ConnectionStatus.initial,
    this.device,
    this.errorMessage,
    this.discoveredDevices = const [],
    this.isScanning = false,
  });

  ConnectionState copyWith({
    ConnectionStatus? status,
    Device? device,
    String? errorMessage,
    List<Device>? discoveredDevices,
    bool? isScanning,
  }) {
    return ConnectionState(
      status: status ?? this.status,
      device: device ?? this.device,
      errorMessage: errorMessage ?? this.errorMessage,
      discoveredDevices: discoveredDevices ?? this.discoveredDevices,
      isScanning: isScanning ?? this.isScanning,
    );
  }

  @override
  List<Object?> get props => [status, device, errorMessage, discoveredDevices, isScanning];
}
