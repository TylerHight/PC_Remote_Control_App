import 'package:equatable/equatable.dart';
import 'package:pc_remote_control_app/data/models/remote_command.dart';

abstract class RemoteControlEvent extends Equatable {
  const RemoteControlEvent();

  @override
  List<Object?> get props => [];
}

class SendCommand extends RemoteControlEvent {
  final RemoteCommand command;

  const SendCommand(this.command);

  @override
  List<Object?> get props => [command];
}
