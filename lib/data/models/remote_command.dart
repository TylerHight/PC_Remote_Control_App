enum CommandType {
  playPause,
  stop,
  next,
  previous,
  volumeUp,
  volumeDown,
  mute,
  forward,
  rewind,
  nextEpisode,
  previousEpisode,
  home,
  back,
  up,
  down,
  left,
  right,
  select,
  menu,
  info,
}

class RemoteCommand {
  final CommandType type;
  final Map<String, dynamic>? additionalParams;

  const RemoteCommand({
    required this.type,
    this.additionalParams,
  });

  @override
  String toString() {
    return 'RemoteCommand{type: $type, additionalParams: $additionalParams}';
  }
}
