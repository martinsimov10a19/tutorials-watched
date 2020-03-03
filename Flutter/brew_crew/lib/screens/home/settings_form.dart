import 'package:brew_crew/services/database.dart';
import 'package:brew_crew/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:brew_crew/shared/constants.dart';
import 'package:brew_crew/models/user.dart';
import 'package:provider/provider.dart';

class SettingsForm extends StatefulWidget {
  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {

  final _formKey = GlobalKey<FormState>();
  final List<String> sugars = ['0','1','2','3','4'];

  String _currentName;
  String _currentSugars;
  int _currentStrength;


  @override
  Widget build(BuildContext context) {
    
    final user = Provider.of<User>(context);

    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: user.uid).userData,
      builder: (context, snapshot) {
        if(snapshot.hasData) {

          UserData userData = snapshot.data;

          return Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Text(
                  'Update your brew settings',
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  initialValue: userData.name,
                  decoration: textInputDecoration,
                  validator: (value) => value.isEmpty ? 'Please enter a name...' : null,
                  onChanged: (value) => setState(() => _currentName = value),
                ),
                SizedBox(height: 20.0),
                // dropdown
                DropdownButtonFormField(
                  decoration: textInputDecoration,
                  value: _currentSugars ?? userData.sugars,
                  items: sugars.map((sugar) {
                    return DropdownMenuItem(
                      value: sugar,
                      child: Text(
                        '$sugar sugars',
                      ),
                    );
                  }).toList(),
                  onChanged: (value) => setState(() => _currentSugars = value),
                ),
                Slider(
                  value: (_currentStrength ?? userData.strength).toDouble(),
                  activeColor: Colors.brown[_currentStrength ?? userData.strength],
                  inactiveColor: Colors.brown[_currentStrength ?? userData.strength],
                  min: 100.0,
                  max: 900.0,
                  divisions: 8,
                  onChanged: (value) => setState(() => _currentStrength = value.round()),
                ),
                // slider

                RaisedButton(
                  onPressed: () async {
                    if(_formKey.currentState.validate()){
                      await DatabaseService(uid: user.uid).updateUserData(
                        _currentSugars ?? userData.sugars,
                        _currentName ?? userData.name,
                        _currentStrength ?? userData.strength
                      );
                      Navigator.pop(context);
                    }
                  },
                  color: Colors.pink[400],
                  child: Text(
                    'Update',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return Loading();
        }
      }
    );
  }
}