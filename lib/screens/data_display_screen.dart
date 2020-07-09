import 'package:flutter/material.dart';
import 'package:learn_sqflite/model/model.dart';
import 'package:learn_sqflite/screens/data_entry_or_edit_screen.dart';

class DataDisplayScreen extends StatefulWidget {

  final database;
  DataDisplayScreen({@required this.database});

  @override
  _DataDisplayScreenState createState() => _DataDisplayScreenState();
}

class _DataDisplayScreenState extends State<DataDisplayScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Display Data'),
      ),
      body: FutureBuilder(
        future: widget.database.displayData(), // read data from database
        builder: (BuildContext context, AsyncSnapshot snap) {
          return (!snap.hasData)
              ? Center(child: CircularProgressIndicator())
              : (snap.data.length == 0) // if database is empty then it shows text message
                  ? Center(
                      child: Text('There is no data'),
                    )
                  : ListView.builder(
                      itemCount: snap.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Row(
                          children: <Widget>[
                            Expanded(
                              child: ListTile(
                                leading: Text(index.toString()),
                                title: Text(snap.data[index].toString()),
                                onTap: () {
                                  Model model = Model(
                                    id: snap.data[index]['id'],
                                    name: snap.data[index]['name'],
                                    age: snap.data[index]['age'],
                                  );
                                  Navigator.of(context)
                                      .push(
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              DataEntryEditScreen(
                                            database: widget.database,
                                            isEntry: false,
                                            model: model,
                                          ),
                                        ),
                                      )
                                      .whenComplete( // when complete, pop back to HomeScreen
                                          () => Navigator.of(context).pop(),
                                  );
                                },
                              ),
                            ),
                            IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  setState(() {
                                    int id = snap.data[index]['id'];
                                    widget.database.deleteData(id); // delete particular data
                                  });
                                }),
                          ],
                        );
                      },
                    );
        },
      ),
    );
  }
}
