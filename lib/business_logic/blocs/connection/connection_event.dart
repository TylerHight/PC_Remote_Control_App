import 'package:equatable/equatable.dart';
import 'package:pc_remote_control_app/data/models/device.dart';

abstract class ConnectionEvent extends Equatable {
  const ConnectionEvent();

  @override
  List<Object?> get props => [];
}

class ConnectToDevice extends ConnectionEvent {
  final Device device;

  const ConnectToDevice(this.device);

  @override
  List<Object?> get props => [device];
}

class DisconnectFromDevice extends ConnectionEvent {}

class ConnectionStatusChanged extends ConnectionEvent {
  final bool isConnected;

  const ConnectionStatusChanged(this.isConnected);

  @override
  List<Object?> get props => [isConnected];
}
