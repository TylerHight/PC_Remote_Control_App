import 'package:equatable/equatable.dart';
import 'package:pc_remote_control_app/data/models/device.dart';

enum ConnectionStatus { initial, connecting, connected, disconnecting, disconnected, error }

class ConnectionState extends Equatable {
  final ConnectionStatus status;
  final Device? device;
  final String? errorMessage;

  const ConnectionState({
    this.status = ConnectionStatus.initial,
    this.device,
    this.errorMessage,
  });

  ConnectionState copyWith({
    ConnectionStatus? status,
    Device? device,
    String? errorMessage,
  }) {
    return ConnectionState(
      status: status ?? this.status,
      device: device ?? this.device,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, device, errorMessage];
}
