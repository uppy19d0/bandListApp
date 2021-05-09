import 'package:BandList/pages/home.dart';
import 'package:BandList/pages/status.dart';
import 'package:BandList/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => SocketService())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        initialRoute: 'home',
        routes: {'home': (_) => HomePage(), 'status': (_) => StatusPage()},
      ),
    );
  }
}
