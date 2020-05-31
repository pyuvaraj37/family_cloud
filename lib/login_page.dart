import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'authenticate.dart';

class LoginPage extends StatefulWidget{
  LoginPage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _LoginPageState createState() => _LoginPageState();

}

class _LoginPageState extends State<LoginPage> {
  
  final _formKey = new GlobalKey<FormState>();
  String _username; 
  String _password;


  @override 
  Widget build(BuildContext context)  {

    final title = Text(
      "Family Cloud Login",
      textAlign: TextAlign.center,
    );

    final username = TextFormField(
      obscureText: false,
      decoration: InputDecoration(
        hintText: "Username",
      ),
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter your username!';
        }
        return null; 
       },
      onSaved: (input) {
        _username = input; 
      },
    );

    final password = TextFormField(
      obscureText: true,
      decoration: InputDecoration(
        hintText: "Password",
      ),
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter your password!';
        }
        return null; 
      },
      onSaved: (input) {
        _password = input;
      },
    );

    final loginBtn = Material(
      child: MaterialButton(
        onPressed: () {
          final form = _formKey.currentState;
          form.save();
          if (form.validate()) {
            print('Submit form!');
            Provider.of<AuthService>(context).loginUser(_username, _password);
          }
        },
        child: Text(
          'Login', 
          style: TextStyle(
            color: Colors.white
          ),
        ),
        color: Colors.purple,
      )
    );

    return Scaffold(
      body: Center(
        child: Container(
          color: Colors.white,
          child: new Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  title,
                  SizedBox(height: 45.0),
                  username,
                  SizedBox(height: 25.0),
                  password,
                  SizedBox(
                    height: 35.0,
                  ),
                  loginBtn,
                  SizedBox(
                    height: 15.0,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool authenticate(String username, String password) {
    return true; 
  }



}