import 'package:brew_crew/services/database.dart';
import 'package:brew_crew/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:brew_crew/shared/constants.dart';
import 'package:brew_crew/models/custom_user.dart';
import 'package:provider/provider.dart';

class SettingsForm extends StatefulWidget {
  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {

  final _formKey = GlobalKey<FormState>();
  final List<String> sugars = ['0', '1', '2', '3', '4'];

  // form values
  String _currentName;
  String _currentSugars;
  int _currentStrength;

  @override
  Widget build(BuildContext context) {

    final customUser = Provider.of<CustomUser>(context);

    return StreamBuilder<CustomUserData>(
      stream: DatabaseService(uid: customUser.uid).customUserData,
      builder: (context, snapshot) {
        if(snapshot.hasData){
          
          CustomUserData customUserData = snapshot.data;
          return Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Text(
                  'Update your brew settings',
                  style: TextStyle(fontSize: 18.0),
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  initialValue: customUserData.name,
                  decoration: textInputDecoration,
                  validator: (val) => val.isEmpty ? 'Please enter a name' : null,
                  onChanged: (val) => setState(() => _currentName = val),
                ),
                SizedBox(height: 20.0),
                //dropdown
                DropdownButtonFormField(
                  decoration: textInputDecoration,
                  value: _currentSugars ?? customUserData.sugars,
                  items: sugars.map((sugar){
                    return DropdownMenuItem(
                      value: sugar,
                      child: Text('$sugar sugars'),
                    );
                  }).toList(),
                  onChanged: (val) => setState(() => _currentSugars = val ),
                ),
                //slider
                Slider(
                  min: 100.0,
                  max: 900.0,
                  divisions: 8,
                  onChanged: (val) => setState( () => _currentStrength = val.round()),
                  value: (_currentStrength ?? customUserData.strength).toDouble(),
                  activeColor: Colors.brown[_currentStrength ?? customUserData.strength],
                  inactiveColor: Colors.brown[_currentStrength ?? customUserData.strength],
                ),
                RaisedButton(
                  color: Colors.pink[400],
                  child: Text(
                    'Update',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    if(_formKey.currentState.validate()){
                      await DatabaseService(uid: customUser.uid).updateUserData(
                        _currentSugars ?? customUserData.sugars,
                        _currentName ?? customUserData.name,
                        _currentStrength ?? customUserData.strength
                      );
                      Navigator.pop(context);
                    }
                  },
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