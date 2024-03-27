import 'dart:io';
import 'dart:typed_data';

import 'package:password_manager_back/src/controllers/api/api.dart';
import 'package:password_manager_back/src/data/database/database.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;

void main() async {
  var connection = Database();

  Api server = Api(connection);

  final ip = InternetAddress.anyIPv4;
  final server1 = await ServerSocket.bind(ip, 3000);
  print("WSServer is running on: ${ip.address}:3000");
  server1.listen((Socket event) {
    handleConnection(event);
  });

  var servedServer = await shelf_io.serve(server.handler, 'localhost', 8080);

  print('Serving at http://${servedServer.address.host}:${servedServer.port}');



//todo desktop
// final socket = await Socket.connect("0.0.0.0", 3000);
  // print('Connected to: ${socket.remoteAddress.address}:${socket.remotePort}');
  // socket.listen((Uint8List data) {
  //   final serverResponse = String.fromCharCodes(data);
  //
  //     print(serverResponse.toString());
  // });
}

void handleConnection(Socket client) {
  print(
    "Connection from ${client.remoteAddress.address}:${client.remotePort}",
  );

  client.write('object');

  client.listen(
    (Uint8List data) async {
      final message = String.fromCharCodes(data);

      print(message);
    }, // handle errors
    onError: (error) {
      print(error);
      client.close();
    },

    // handle the client closing the connection
    onDone: () {
      print('Client left');
      client.close();
    },
  );
}
