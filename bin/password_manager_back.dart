import 'dart:io';

import 'package:shelf/shelf_io.dart' as shelf_io;

import 'src/controllers/api/api.dart';
import 'src/data/database/database.dart';

List<Socket> clients = [];

void main() async {
  var connection = Database();

  Api server = Api(connection);

  final securityContext = SecurityContext();

  securityContext.useCertificateChain(
      "/etc/letsencrypt/live/pmanager-api.ru/fullchain.pem");


    var servedServer = await shelf_io.serve(
      server.handler, '127.0.0.1', 8080,
      securityContext: securityContext,
   );


  print('Serving at https://${servedServer.address.host}:${servedServer.port}');
  final server1 = await ServerSocket.bind('127.0.0.1', 3000);
  print("WSServer is running on: 127.0.0.1:3000");
  server1.listen((Socket client) {
    clients.add(client);
    print(
        'getConnection - ${client.remoteAddress.address}:${client.remotePort}');
  });
}
