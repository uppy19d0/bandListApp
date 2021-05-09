import 'dart:io';

import 'package:BandList/models/band.dart';
import 'package:BandList/services/socket_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [];

  @override
  void initState() {
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.on('active-bands', _handleLoadBand);

    // TODO: implement initState
    super.initState();
  }

  _handleLoadBand(dynamic payload) {
    this.bands = (payload as List).map((band) => Band.FromMap(band)).toList();
    setState(() {});
  }

  @override
  void dispose() {
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.off('activate-bands');
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);

    return Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text(
              "BandFavorite",
              style: TextStyle(color: Colors.black87),
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 1,
          actions: [
            Container(
              margin: EdgeInsets.only(right: 10),
              child: socketService.serverStatus == ServerStatus.Online
                  ? Icon(
                      Icons.check_circle,
                      color: Colors.blue[300],
                    )
                  : Icon(
                      Icons.close,
                      color: Colors.red[300],
                    ),
            )
          ],
        ),
        body: Column(children: <Widget>[
          _ShowGraph(),
          Expanded(
            child: ListView.builder(
              itemBuilder: (_, i) => _bandTile(bands[i]),
              itemCount: bands.length,
            ),
          ),
        ]),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add), elevation: 1, onPressed: addNewBand));
  }

  Widget _bandTile(Band band) {
    final _socketService = Provider.of<SocketService>(context, listen: false);

    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (_) => _socketService.emit('delete-band', {'id': band.id}),
      background: Container(
          color: Colors.red,
          child: Align(
              child:
                  Text('Delete Band', style: TextStyle(color: Colors.white))),
          padding: EdgeInsets.only(left: 8.0)),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(band.name.substring(0, 2)),
          backgroundColor: Colors.blue[100],
        ),
        title: Text(band.name),
        trailing: Text(
          band.votes.toString(),
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        onTap: () {
          // socket
          _socketService.socket.emit('vote-band', {'id': band.id});
          print(band.id);
        },
      ),
    );
  }

  addNewBand() {
    final textController = new TextEditingController();
    if (Platform.isAndroid) {
      return showDialog(
          context: context,
          builder: (context) => AlertDialog(
                  title: Text('New band name:'),
                  content: TextField(
                    controller: textController,
                  ),
                  actions: [
                    MaterialButton(
                      onPressed: () => verificInput(textController.text),
                      child: Text("Add",
                          style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold)),
                    ),
                    MaterialButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Cancelar",
                        style: TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold),
                      ),
                    )
                  ]));
    }
    showCupertinoDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
              title: Text('New band name:'),
              content: CupertinoTextField(
                controller: textController,
              ),
              actions: [
                CupertinoDialogAction(
                  isDefaultAction: true,
                  onPressed: () => verificInput(textController.text),
                  child: Text("Add",
                      style: TextStyle(
                          color: Colors.green, fontWeight: FontWeight.bold)),
                ),
                CupertinoDialogAction(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Cancelar",
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ));
  }

  verificInput(String name) {
    if (name.length > 1) {
      final socketService = Provider.of<SocketService>(context, listen: false);
      socketService.emit('add-band', {'name': name});
    }

    Navigator.pop(context);
  }

  Widget _ShowGraph() {
    Map<String, double> dataMap = new Map();

    bands.forEach((band) {
      dataMap.putIfAbsent(band.name, () => band.votes.toDouble());
    });
    //  {
    //   "Flutter": 5,
    //   "React": 3,
    //   "Xamarin": 2,
    //   "Ionic": 2,
    // };

    final List<Color> colorList = [
      Colors.blue[50],
      Colors.blue[200],
      Colors.red[50],
      Colors.pink[50],
      Colors.pink[200],
      Colors.yellow[50],
      Colors.yellow[200]
    ];
    return Container(
        width: double.infinity,
        height: 200,
        child: PieChart(
          dataMap: dataMap,
          animationDuration: Duration(milliseconds: 800),
          chartLegendSpacing: 32,
          chartRadius: MediaQuery.of(context).size.width / 3.2,
          colorList: colorList,
          initialAngleInDegree: 0,
          chartType: ChartType.ring,
          ringStrokeWidth: 32,
          legendOptions: LegendOptions(
            showLegendsInRow: false,
            legendPosition: LegendPosition.right,
            showLegends: true,
            legendShape: BoxShape.circle,
            legendTextStyle: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          chartValuesOptions: ChartValuesOptions(
            showChartValueBackground: true,
            showChartValues: true,
            showChartValuesInPercentage: false,
            showChartValuesOutside: false,
            decimalPlaces: 1,
          ),
        ));
  }
}
