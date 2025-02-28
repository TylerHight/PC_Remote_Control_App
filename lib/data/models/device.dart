class Device {
  final String id;
  final String name;
  final String ipAddress;
  final bool isConnected;

  const Device({
    required this.id,
    required this.name,
    required this.ipAddress,
    this.isConnected = false,
  });

  Device copyWith({
    String? id,
    String? name,
    String? ipAddress,
    bool? isConnected,
  }) {
    return Device(
      id: id ?? this.id,
      name: name ?? this.name,
      ipAddress: ipAddress ?? this.ipAddress,
      isConnected: isConnected ?? this.isConnected,
    );
  }

  @override
  String toString() {
    return 'Device{id: $id, name: $name, ipAddress: $ipAddress, isConnected: $isConnected}';
  }
}
