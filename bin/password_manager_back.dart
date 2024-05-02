import 'dart:io';

import 'package:password_manager_back/src/controllers/api/api.dart';
import 'package:password_manager_back/src/data/database/database.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;

List<Socket> clients = [];

void main() async {
  var connection = Database();

  Api server = Api(connection);

  var servedServer = await shelf_io.serve(server.handler, '178.208.85.222', 8080);

  print('Serving at http://${servedServer.address.host}:${servedServer.port}');
  final server1 = await ServerSocket.bind('178.208.85.222', 3000);
  print("WSServer is running on: 178.208.85.222:3000");
  server1.listen((Socket client) {
    clients.add(client);
    print('getConnection - ${client.address.address}:${client.remotePort}');
  });
}
