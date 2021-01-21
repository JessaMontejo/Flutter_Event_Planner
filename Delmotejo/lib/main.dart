import 'package:event_planner/register.dart';
import 'package:flutter/material.dart';
import 'FadeAnimation.dart';
import 'menu.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

enum LoginStatus { notSignIn, signIn }

class _MyHomePageState extends State<MyHomePage> {
  LoginStatus _loginStatus = LoginStatus.notSignIn;

  String username, password;
  final _key = new GlobalKey<FormState>();
  bool _secureText = true;

  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      login();
    }
  }

  login() async {
    debugPrint("Success");
    final response =
        await http.post("http://192.168.2.115/eventplanner/login.php", body: {
      'username': username,
      'password': password,
    });

    debugPrint(response.body.toString());
    final data = jsonDecode(response.body);
    int value = data['value'];
    String message = data['message'];
    String userAPI = data['username'];
    String emailAPI = data['email'];
    String id = data['userid'];

    print(id);
    debugPrint(data.toString());
    if (value == 1) {
      setState(() {
        _loginStatus = LoginStatus.signIn;
        savePref(value, userAPI, emailAPI, id);
      });
      print(message);
      loginToast(message);
    } else {
      print(message);
      failedToast(message);
    }
  }

  loginToast(String toast) {
    return Fluttertoast.showToast(
        msg: 'You Have Sucessfully Login',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.green,
        textColor: Colors.white);
  }

  failedToast(String toast) {
    return Fluttertoast.showToast(
        msg: 'Your Account Dosent Exist',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        backgroundColor: Color(0xffb5171d),
        textColor: Colors.white);
  }

  savePref(
    int value,
    String username,
    String email,
    String id,
  ) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt('value', value);
      preferences.setString('username', username);
      preferences.setString('email', email);
      preferences.setString('id', id);
    });
  }

  var value;
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      value = preferences.getInt('value');
      _loginStatus = value == 1 ? LoginStatus.signIn : LoginStatus.notSignIn;
    });
  }

  signOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", null);
      preferences.setString('username', null);
      preferences.setString('email', null);
      preferences.setString('id', null);
      _loginStatus = LoginStatus.notSignIn;
    });
  }

  @override
  void initState() {
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    switch (_loginStatus) {
      case LoginStatus.notSignIn:
        return new Scaffold(
          body: Form(
            key: _key,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  gradient: LinearGradient(begin: Alignment.topCenter, colors: [
                Colors.blue[900],
                Colors.blue[800],
                Colors.blue[400]
              ])),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 80,
                  ),
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        FadeAnimation(
                            1,
                            Center(
                              child: Text(
                                "Login",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 40),
                              ),
                            )),
                        SizedBox(
                          height: 10,
                        ),
                        FadeAnimation(
                            1.3,
                            Center(
                              child: Text(
                                "Event Planner",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 40),
                              ),
                            )),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(60),
                              topRight: Radius.circular(60))),
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.all(30),
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: 60,
                              ),
                              FadeAnimation(
                                  1.4,
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Color.fromRGBO(
                                                  225, 95, 27, .3),
                                              blurRadius: 20,
                                              offset: Offset(0, 10))
                                        ]),
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  bottom: BorderSide(
                                                      color:
                                                          Colors.grey[200]))),
                                          child: TextFormField(
                                            keyboardType:
                                                TextInputType.emailAddress,
                                            validator: (e) {
                                              if (e.isEmpty) {
                                                return "Please insert username";
                                              }
                                              return null;
                                            },
                                            onSaved: (e) => username = e,
                                            decoration: InputDecoration(
                                                hintText: "username",
                                                hintStyle: TextStyle(
                                                    color: Colors.grey),
                                                border: InputBorder.none),
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  bottom: BorderSide(
                                                      color:
                                                          Colors.grey[200]))),
                                          child: TextFormField(
                                            obscureText: true,
                                            validator: (e) {
                                              if (e.isEmpty) {
                                                return "Please insert password";
                                              }
                                              return null;
                                            },
                                            onSaved: (e) => password = e,
                                            decoration: InputDecoration(
                                                hintText: "Password",
                                                hintStyle: TextStyle(
                                                    color: Colors.grey),
                                                border: InputBorder.none),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                              SizedBox(
                                height: 40,
                              ),
                              Container(
                                width: 300,
                                height: 50.0,
                                child: Material(
                                  borderRadius: BorderRadius.circular(25.0),
                                  shadowColor: Color(0xff083663),
                                  color: Colors.blue,
                                  elevation: 7.0,
                                  child: MaterialButton(
                                    onPressed: () {
                                      check();
                                    },
                                    child: Center(
                                      child: Text(
                                        'Login',
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Montserrat'),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 15.0),
                              Container(
                                width: 300,
                                height: 50.0,
                                child: Material(
                                  borderRadius: BorderRadius.circular(25.0),
                                  shadowColor: Color(0xff083663),
                                  color: Colors.green,
                                  elevation: 7.0,
                                  child: MaterialButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) => Signup()));
                                    },
                                    child: Center(
                                      child: Text(
                                        'Sign up',
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Montserrat'),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
        break;
      case LoginStatus.signIn:
        return Menu(signOut);
        break;
    }
  }
}
