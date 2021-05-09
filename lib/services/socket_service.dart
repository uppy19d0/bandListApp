import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus { Online, Offline, Connecting }

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.Connecting;

  IO.Socket _socket;

  IO.Socket get socket => this._socket;

  ServerStatus get serverStatus => _serverStatus;

  Function get emit => this._socket.emit;
  
  SocketService() {
    this._initConfig();
  }

  void _initConfig() {
    this._socket = IO.io('http://192.168.1.30:3001', {
      'transports': ['websocket'],
      'autoConnect': true
    });
    this._socket.onConnect((_) {
      print('connect');
      this._serverStatus = ServerStatus.Online;
      notifyListeners();
    });
    this._socket.onDisconnect((_) {
      this._serverStatus = ServerStatus.Offline;
      notifyListeners();
    });
    this._socket.on('new-message', (payload) {
      print('Nuevo Mensaje:$payload');
    });
  }
}
