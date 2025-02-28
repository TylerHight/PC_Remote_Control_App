import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pc_remote_control_app/business_logic/blocs/connection/connection_event.dart';
import 'package:pc_remote_control_app/data/models/device.dart';
import 'package:pc_remote_control_app/business_logic/blocs/connection/connection_state.dart';
import 'package:pc_remote_control_app/data/repositories/remote_control_repository.dart';

class ConnectionBloc extends Bloc<ConnectionEvent, ConnectionState> {
  final RemoteControlRepository remoteControlRepository;
  late StreamSubscription<bool> _connectionStatusSubscription;
  late StreamSubscription<List<Device>> _deviceDiscoverySubscription;

  ConnectionBloc({required this.remoteControlRepository})
      : super(const ConnectionState()) {
    on<ConnectToDevice>(_onConnectToDevice);
    on<DisconnectFromDevice>(_onDisconnectFromDevice);
    on<ConnectionStatusChanged>(_onConnectionStatusChanged);
    on<StartScan>(_onStartScan);
    on<StopScan>(_onStopScan);
    on<DeviceDiscovered>(_onDeviceDiscovered);
    on<ScanComplete>(_onScanComplete);

    _connectionStatusSubscription = remoteControlRepository.connectionStatus.listen(
      (isConnected) => add(ConnectionStatusChanged(isConnected)),
      onError: (error) => print('Connection status error: $error')
    );

    _deviceDiscoverySubscription = remoteControlRepository.discoveredDevices.listen(
      (devices) => add(ScanComplete(devices)),
    );
  }

  Future<void> _onConnectToDevice(
    ConnectToDevice event,
    Emitter<ConnectionState> emit,
  ) async {
    emit(state.copyWith(status: ConnectionStatus.connecting));
    try {
      final success = await remoteControlRepository.connectToDevice(event.device);
      if (success) {
        emit(state.copyWith(
          status: ConnectionStatus.connected,
          device: event.device.copyWith(isConnected: true),
        ));
      } else {
        emit(state.copyWith(
          status: ConnectionStatus.error,
          errorMessage: 'Failed to connect to device',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: ConnectionStatus.error,
        errorMessage: 'Error connecting to device: $e',
      ));
    }
  }

  Future<void> _onDisconnectFromDevice(
    DisconnectFromDevice event,
    Emitter<ConnectionState> emit,
  ) async {
    emit(state.copyWith(status: ConnectionStatus.disconnecting));
    try {
      final success = await remoteControlRepository.disconnectFromDevice();
      if (success) {
        emit(const ConnectionState(status: ConnectionStatus.disconnected));
      } else {
        emit(state.copyWith(
          status: ConnectionStatus.error,
          errorMessage: 'Failed to disconnect from device',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: ConnectionStatus.error,
        errorMessage: 'Error disconnecting from device: $e',
      ));
    }
  }

  void _onConnectionStatusChanged(
    ConnectionStatusChanged event,
    Emitter<ConnectionState> emit,
  ) {
    final newStatus = event.isConnected
        ? ConnectionStatus.connected
        : ConnectionStatus.disconnected;
    emit(state.copyWith(status: newStatus));
  }

  Future<void> _onStartScan(
    StartScan event,
    Emitter<ConnectionState> emit,
  ) async {
    emit(state.copyWith(
      status: ConnectionStatus.scanning,
      isScanning: true,
      discoveredDevices: [],
    ));
    
    try {
      await remoteControlRepository.startScan();
    } catch (e) {
      emit(state.copyWith(
        status: ConnectionStatus.error,
        errorMessage: 'Failed to start scanning: $e',
        isScanning: false,
      ));
    }
  }

  Future<void> _onStopScan(
    StopScan event,
    Emitter<ConnectionState> emit,
  ) async {
    await remoteControlRepository.stopScan();
    emit(state.copyWith(isScanning: false));
  }

  void _onDeviceDiscovered(DeviceDiscovered event, Emitter<ConnectionState> emit) {
    emit(state.copyWith(discoveredDevices: [...state.discoveredDevices, event.device]));
  }

  void _onScanComplete(ScanComplete event, Emitter<ConnectionState> emit) {
    emit(state.copyWith(discoveredDevices: event.devices, isScanning: false));
  }

  @override
  Future<void> close() {
    _connectionStatusSubscription.cancel();
    _deviceDiscoverySubscription.cancel();
    return super.close();
  }
}
