import 'package:brew_crew/services/auth.dart';
import 'package:brew_crew/shared/constants.dart';
import 'package:brew_crew/shared/loading.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {

  final Function toggleView;
  SignIn({ this.toggleView });


  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  // text field state
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
        title: Text('Sign in to Brew Crew'),
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.person),
            onPressed: () {
              widget.toggleView();
            },
            label: Text('Register'),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal:50.0),
        child: Column(
          children: <Widget>[
            
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  
                  SizedBox(height: 20.0),
                  TextFormField(
                    decoration: textInputDecoration.copyWith(hintText: 'Email'),
                    validator: (val) {
                    return val.isEmpty ? 'Enter an email' : null;
                  },
                    onChanged: (val) {
                      setState(() {
                        email = val;
                      });
                    },
                  ),
                  
                  SizedBox(height: 20.0),
                  TextFormField(
                    decoration: textInputDecoration.copyWith(hintText: 'Password'),
                    obscureText: true,
                    validator: (val) {
                      return val.length < 6 ? 'Enter the password 6+ chars long' : null;
                    },
                    onChanged: (val){
                      setState(() {
                        password = val;
                      });
                    },
                  ),

                  SizedBox(height: 20.0),
                  RaisedButton(
                    color: Colors.pink[400],
                    child: Text(
                      'Sign in',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      //print('Email: $email');
                      //print('Password: $password');
                       if(_formKey.currentState.validate()) {
                        setState(() {
                          loading = true;
                        });
                        dynamic result = await _auth.signInWithEmailAndPassword(email, password);
                        if(result == null){
                          setState(() {
                            error = 'Could not sign in with those credentials';
                            loading = false;
                          });
                        } 

                        /*No else because if result != null i.e user successfully registers with the email and password 
                        and it return custom user object which is automatically 
                        listened by the stream and inside the wrapper widget it switches control to home screen*/
                      }
                    },
                  )
                  
                ]
              ),
            ),

            SizedBox(height: 50.0),
            RaisedButton(
              child: Text('Sign in Anon'),
              onPressed: () async {
                dynamic result = await _auth.signInAnon();
                if (result == null){
                  print('Error in Signing In');
                } else {
                  print('Signed in: ${result.uid}');
                }
              },
            ),

            SizedBox(height: 12.0),
            Text(
              error,
              style: TextStyle(color: Colors.red, fontSize: 14.0),
            )

          ],
        ),
      ),
    );
  }
}