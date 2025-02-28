import 'dart:async';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:pc_remote_control_app/data/models/device.dart';
import 'package:pc_remote_control_app/data/models/remote_command.dart';

abstract class RemoteControlRepository {
  Future<bool> connectToDevice(Device device);
  Future<bool> disconnectFromDevice();
  Future<bool> sendCommand(RemoteCommand command);
  Stream<bool> get connectionStatus;
  Device? get currentDevice;
  Future<void> startScan();
  Future<void> stopScan();
  Stream<List<Device>> get discoveredDevices;
}

class RemoteControlRepositoryImpl implements RemoteControlRepository {
  Device? _currentDevice;
  final _connectionStatusController = StreamController<bool>.broadcast();
  final _discoveredDevicesController = StreamController<List<Device>>.broadcast();
  final List<Device> _discoveredDevices = [];

  @override
  Device? get currentDevice => _currentDevice;

  @override
  Stream<bool> get connectionStatus => _connectionStatusController.stream;

  @override
  Future<bool> connectToDevice(Device device) async {
    // In a real app, this would establish a connection to the device
    // For demo purposes, we'll simulate a successful connection
    await Future.delayed(const Duration(milliseconds: 800));
    
    if (device.bleDevice != null) {
      try {
        await device.bleDevice!.connect();
      } catch (e) {
        print('Error connecting to BLE device: $e');
      }
    }
    _currentDevice = device.copyWith(isConnected: true);
    _connectionStatusController.add(true);
    return true;
  }

  @override
  Future<bool> disconnectFromDevice() async {
    // In a real app, this would close the connection to the device
    await Future.delayed(const Duration(milliseconds: 500));
    if (_currentDevice != null) {
      if (_currentDevice!.bleDevice != null) {
        try {
          await _currentDevice!.bleDevice!.disconnect();
        } catch (e) {}
      }
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
  
  @override
  Stream<List<Device>> get discoveredDevices => _discoveredDevicesController.stream;

  @override
  Future<void> startScan() async {
    _discoveredDevices.clear();
    
    // Check if Bluetooth is on
    if (await FlutterBluePlus.isAvailable == false) {
      print('Bluetooth not available');
      return;
    }
    
    // Start scanning
    try {
      FlutterBluePlus.scanResults.listen((results) {
        for (ScanResult result in results) {
          // Only add devices with names
          if (result.device.platformName.isNotEmpty) {
            final device = Device(
              id: result.device.remoteId.str,
              name: result.device.platformName,
              bleDevice: result.device,
              rssi: result.rssi,
            );
            
            // Check if device already exists in the list
            final existingIndex = _discoveredDevices.indexWhere((d) => d.id == device.id);
            if (existingIndex >= 0) {
              _discoveredDevices[existingIndex] = device;
            } else {
              _discoveredDevices.add(device);
            }
            
            _discoveredDevicesController.add(List.from(_discoveredDevices));
          }
        }
      });
      
      await FlutterBluePlus.startScan(timeout: const Duration(seconds: 10));
    } catch (e) {
      print('Error scanning: $e');
    }
  }

  @override
  Future<void> stopScan() async {
    await FlutterBluePlus.stopScan();
  }

  void dispose() {
    _connectionStatusController.close();
    _discoveredDevicesController.close();
  }
}
