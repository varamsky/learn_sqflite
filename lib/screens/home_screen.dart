import 'package:flutter/material.dart';
import 'package:learn_sqflite/screens/data_display_screen.dart';
import 'package:learn_sqflite/screens/data_entry_or_edit_screen.dart';
import 'package:learn_sqflite/database/database.dart';

class HomeScreen extends StatelessWidget {

  // getting an instance of MyDatabase
  MyDatabase _myDatabase = new MyDatabase();

  @override
  Widget build(BuildContext context) {

    // initializing the database
    _myDatabase.initDb();

    return Scaffold(
      appBar: AppBar(title: Text('Learn Sqflite'),),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              onPressed: (){
                print('Add Data Pressed');

                // navigating to DataEntryScreen
                // DataEntryEditScreen is used for both new data insert and to update present data
                // isEntry informs informs whether the class is called for data insert or data update (isEntry is true for insert and false for update)
                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => DataEntryEditScreen(database: _myDatabase,isEntry: true,),),);
              },
              child: Text('Add Data'),
              color: Colors.green,
            ),
            RaisedButton(
              onPressed: (){
                print('Display Data Pressed');

                // navigating to DataDisplayScreen
                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => DataDisplayScreen(database: _myDatabase)));
              },
              child: Text('Display Data'),
              color: Colors.amber,
            ),
            Builder(
              builder: (BuildContext context){
                return RaisedButton(
                  onPressed: () {
                    // method to delete all data
                    deleteData(context);
                  },
                  child: Text('Delete All Data'),
                  color: Colors.red,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  deleteData(BuildContext context) async{
    print('Delete All Data Pressed');

    // deleting all data
    int result = await _myDatabase.deleteAllData();
    print(result);

    // showing SnackBar to inform user
    if(result != -1)
      Scaffold.of(context).showSnackBar(SnackBar(content: Text('All data deleted')));
  }
}
