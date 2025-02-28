import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pc_remote_control_app/business_logic/blocs/remote_control/remote_control_event.dart';
import 'package:pc_remote_control_app/business_logic/blocs/remote_control/remote_control_state.dart';
import 'package:pc_remote_control_app/data/repositories/remote_control_repository.dart';

class RemoteControlBloc extends Bloc<RemoteControlEvent, RemoteControlState> {
  final RemoteControlRepository remoteControlRepository;

  RemoteControlBloc({required this.remoteControlRepository})
      : super(const RemoteControlState()) {
    on<SendCommand>(_onSendCommand);
  }

  Future<void> _onSendCommand(
    SendCommand event,
    Emitter<RemoteControlState> emit,
  ) async {
    emit(state.copyWith(
      status: CommandStatus.sending,
      lastCommand: event.command,
    ));

    try {
      final success = await remoteControlRepository.sendCommand(event.command);
      if (success) {
        emit(state.copyWith(status: CommandStatus.sent));
      } else {
        emit(state.copyWith(
          status: CommandStatus.error,
          errorMessage: 'Failed to send command',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: CommandStatus.error,
        errorMessage: 'Error sending command: $e',
      ));
    }
  }
}
