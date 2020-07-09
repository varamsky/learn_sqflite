import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:learn_sqflite/model/model.dart';

class DataEntryEditScreen extends StatefulWidget {
  bool isEntry;
  var database;
  Model model;

  DataEntryEditScreen(
      {@required this.database, @required this.isEntry, this.model});

  @override
  _DataEntryEditScreenState createState() => _DataEntryEditScreenState();
}

class _DataEntryEditScreenState extends State<DataEntryEditScreen> {
  String ageErrorText;
  String nameErrorText;

  TextEditingController nameController;
  TextEditingController ageController;

  @override
  void initState() {
    super.initState();

    // if this class is called to insert data then the TextEditingController is empty by default i.e., TextField is empty
    // if this class is called to update data then the TextEditingController is set to current data i.e., TextField is shows current data
    nameController = (widget.isEntry)
        ? TextEditingController()
        : TextEditingController(text: widget.model.name);
    ageController = (widget.isEntry)
        ? TextEditingController()
        : TextEditingController(text: widget.model.age.toString());

    nameErrorText = '';
    ageErrorText = '';
  }

  @override
  void dispose() {
    super.dispose();

    //disposing off TextEditingControllers after use
    nameController.dispose();
    ageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter Data'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(
                      hintText: 'Enter name', errorText: nameErrorText),
                  controller: nameController,
                  onChanged: (_) {
                    // nameErrorText is set to null when user tries to fix the text entered else user will continue to see error message even when user tries to fix text.
                    if (nameErrorText != '' || nameErrorText != null) {
                      setState(() {
                        nameErrorText = '';
                      });
                    }
                  },
                  onSubmitted: (String text) {
                    nameController.text = text;
                  },
                ),
                TextField(
                  decoration: InputDecoration(
                      hintText: 'Enter age', errorText: ageErrorText),
                  controller: ageController,
                  onChanged: (_) {
                    // ageErrorText is set to null when user tries to fix the text entered else user will continue to see error message even when user tries to fix text.
                    if (ageErrorText != '' || ageErrorText != null) {
                      setState(() {
                        ageErrorText = '';
                      });
                    }
                  },
                  onSubmitted: (String text) {
                    ageController.text = text;
                  },
                ),
                RaisedButton(
                    child: Text((widget.isEntry) ? 'Submit' : 'Update'),
                    onPressed: () {
                      print('button pressed');
                      if (nameController.text == null ||
                          nameController.text == '') {
                        nameErrorText = 'name must not be null';
                      } else if (int.tryParse(ageController.text) == null) {
                        setState(() {
                          ageErrorText = 'age must be numeric';
                        });
                      } else {
                        Model newModel;
                        if (widget.isEntry)
                          newModel = Model(
                              // commenting this enables database to generate id by itself
                              //id: int.parse(idController.text),
                              name: nameController.text,
                              age: int.parse(ageController.text));
                        else
                          newModel = Model(
                              id: widget.model.id,
                              name: nameController.text,
                              age: int.parse(ageController.text));
                        (widget.isEntry)
                            ? widget.database.insertData(newModel.toMap())
                            : widget.database.updateData(newModel);
                        Navigator.of(context).pop();
                      }
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
