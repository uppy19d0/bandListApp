import 'package:BandList/src/models/band.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [
    Band(id: '1', name: 'Codplay', votes: 5),
    Band(id: '2', name: 'The Chainsmorkers', votes: 5),
    Band(id: '3', name: 'Graffen', votes: 5),
    Band(id: '4', name: 'Queen', votes: 5),
    Band(id: '4', name: 'Flutter', votes: 5),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Banda Favorita")),
        body: ListView.builder(
          itemBuilder: (_, i) => _bandTile(bands[i]),
          itemCount: bands.length,
        ),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add), elevation: 1, onPressed: addNewBand));
  }

  Widget _bandTile(Band band) {
    return Dismissible(
      direction: DismissDirection.startToEnd,
      onDismissed: (dirrection) {
        print("$dirrection");
      },
      background: Container(
          color: Colors.red,
          child: Align(
              child:
                  Text('Delete Band', style: TextStyle(color: Colors.white))),
          padding: EdgeInsets.only(left: 8.0)),
      key: Key(band.id),
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
      ),
    );
  }

  addNewBand() {
    final textController = new TextEditingController();
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text('New band name:'),
              content: TextField(
                controller: textController,
              ),
              actions: [
                MaterialButton(
                  onPressed: verificInput(textController.text),
                  child: Text("Add",
                      style: TextStyle(
                          color: Colors.green, fontWeight: FontWeight.bold)),
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
              ]);
        });
  }

  verificInput(String inputDialog) {
    if (inputDialog.length > 1) {
      print(inputDialog);
      bands.add(
          Band(id: DateTime.now().toString(), name: inputDialog, votes: 3));
      // setState(() {});
    }

    Navigator.pop(context);
  }
}
