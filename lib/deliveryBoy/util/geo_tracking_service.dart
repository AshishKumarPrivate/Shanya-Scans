import 'package:geolocator/geolocator.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SalesTrackingService {
  IO.Socket? socket;

  void initializeSocket() {
    socket = IO.io('https://your-server.com', IO.OptionBuilder()
        .setTransports(['websocket'])
        .disableAutoConnect()
        .build());

    socket!.connect();
    socket!.onConnect((_) {
      print("Connected to server");
    });
  }

  Future<void> sendLocationUpdates(String salesPersonId) async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) return;
    }

    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // Update every 10 meters
      ),
    ).listen((Position position) {
      socket!.emit('update_location', {
        "salesPersonId": salesPersonId,
        "latitude": position.latitude,
        "longitude": position.longitude
      });
    });
  }
}
