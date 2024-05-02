import 'dart:io';
import 'dart:typed_data';

import 'package:password_manager_back/src/controllers/api/api.dart';
import 'package:password_manager_back/src/data/database/database.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_web_socket/shelf_web_socket.dart';
// import 'package:socket_io/socket_io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

List<Socket> clients = [];

void main() async {
  var connection = Database();

  Api server = Api(connection);

  // var handler = webSocketHandler((webSocket) {
  //   webSocket as WebSocketChannel;
  //   webSocket.stream.listen((message) {
  //     webSocket.sink.add("echo $message");
  //   });
  // });
  //
  // shelf_io.serve(handler, '127.0.0.1', 3000).then((server) {
  //   print('Serving at ws://${server.address.host}:${server.port}');
  // });

  var servedServer = await shelf_io.serve(server.handler, 'localhost', 8080);

  print('Serving at http://${servedServer.address.host}:${servedServer.port}');
  //
  // final ip = InternetAddress.anyIPv4;
  final server1 = await ServerSocket.bind('127.0.0.1', 3000);
  print("WSServer is running on: 127.0.0.1:3000");
  server1.listen((Socket client) {
    clients.add(client);
    print('getConnection - ${client.remoteAddress.address}:${client.remotePort}');
  });

  // var io = Server();
  //
  //
  // io.on('connection', (client) {
  //   print('connection default namespace');
  //   client.on('msg', (data) {
  //     print('data from default => $data');
  //     client.emit('fromServer', "ok");
  //   });
  // });
  // await io.listen(3000);

  // print(await io.ready);
}
