import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pc_remote_control_app/business_logic/blocs/connection/connection_event.dart';
import 'package:pc_remote_control_app/business_logic/blocs/connection/connection_state.dart';
import 'package:pc_remote_control_app/data/repositories/remote_control_repository.dart';

class ConnectionBloc extends Bloc<ConnectionEvent, ConnectionState> {
  final RemoteControlRepository remoteControlRepository;
  late StreamSubscription<bool> _connectionStatusSubscription;

  ConnectionBloc({required this.remoteControlRepository})
      : super(const ConnectionState()) {
    on<ConnectToDevice>(_onConnectToDevice);
    on<DisconnectFromDevice>(_onDisconnectFromDevice);
    on<ConnectionStatusChanged>(_onConnectionStatusChanged);

    _connectionStatusSubscription = remoteControlRepository.connectionStatus.listen(
      (isConnected) => add(ConnectionStatusChanged(isConnected)),
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

  @override
  Future<void> close() {
    _connectionStatusSubscription.cancel();
    return super.close();
  }
}
