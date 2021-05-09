import 'package:BandList/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatusPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text('ServerStatus:${socketService.serverStatus}')],
      )),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.message),
          onPressed: () => {
                print(socketService.serverStatus.index),
                socketService.emit('emit-message-flutter',
                    {'name': 'FLuter client', 'message': 'Hello of mobile'}),
              }),
    );
  }
}
