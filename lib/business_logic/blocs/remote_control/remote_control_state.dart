import 'package:equatable/equatable.dart';
import 'package:pc_remote_control_app/data/models/remote_command.dart';

enum CommandStatus { initial, sending, sent, error }

class RemoteControlState extends Equatable {
  final CommandStatus status;
  final RemoteCommand? lastCommand;
  final String? errorMessage;

  const RemoteControlState({
    this.status = CommandStatus.initial,
    this.lastCommand,
    this.errorMessage,
  });

  RemoteControlState copyWith({
    CommandStatus? status,
    RemoteCommand? lastCommand,
    String? errorMessage,
  }) {
    return RemoteControlState(
      status: status ?? this.status,
      lastCommand: lastCommand ?? this.lastCommand,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, lastCommand, errorMessage];
}
