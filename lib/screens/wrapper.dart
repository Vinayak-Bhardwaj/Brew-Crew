import 'package:brew_crew/models/custom_user.dart';
import 'package:brew_crew/screens/authenticate/authenticate.dart';
import 'package:brew_crew/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final customUser = Provider.of<CustomUser>(context);
    
    //Return either home or authenticate widget
    if(customUser == null) {
      return Authenticate();
    } else {
      return Home();
    }
  }
}