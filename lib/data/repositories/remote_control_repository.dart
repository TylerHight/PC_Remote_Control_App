import 'dart:async';
import 'package:pc_remote_control_app/data/models/device.dart';
import 'package:pc_remote_control_app/data/models/remote_command.dart';

abstract class RemoteControlRepository {
  Future<bool> connectToDevice(Device device);
  Future<bool> disconnectFromDevice();
  Future<bool> sendCommand(RemoteCommand command);
  Stream<bool> get connectionStatus;
  Device? get currentDevice;
}

class RemoteControlRepositoryImpl implements RemoteControlRepository {
  Device? _currentDevice;
  final _connectionStatusController = StreamController<bool>.broadcast();
  
  @override
  Device? get currentDevice => _currentDevice;

  @override
  Stream<bool> get connectionStatus => _connectionStatusController.stream;

  @override
  Future<bool> connectToDevice(Device device) async {
    // In a real app, this would establish a connection to the device
    // For demo purposes, we'll simulate a successful connection
    await Future.delayed(const Duration(seconds: 1));
    _currentDevice = device.copyWith(isConnected: true);
    _connectionStatusController.add(true);
    return true;
  }

  @override
  Future<bool> disconnectFromDevice() async {
    // In a real app, this would close the connection to the device
    await Future.delayed(const Duration(milliseconds: 500));
    if (_currentDevice != null) {
      _currentDevice = _currentDevice!.copyWith(isConnected: false);
    }
    _connectionStatusController.add(false);
    return true;
  }

  @override
  Future<bool> sendCommand(RemoteCommand command) async {
    // In a real app, this would send the command to the connected device
    // For demo purposes, we'll just print the command and return success
    print('Sending command: $command');
    await Future.delayed(const Duration(milliseconds: 200));
    return true;
  }

  void dispose() {
    _connectionStatusController.close();
  }
}
