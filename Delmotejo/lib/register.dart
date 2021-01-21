import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'FadeAnimation.dart';
import 'main.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  String username, password, email;

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      save();
    }
  }

  save() async {
    debugPrint("Success");
    final response =
        await http.post("http://192.168.2.115/eventplanner/register.php", body: {
      'username': username,
      'password': password,
      'email': email,
    });

    debugPrint(response.body.toString());
    final data = jsonDecode(response.body);
    int value = data['value'];
    String message = data['message'];
    debugPrint(data.toString());
    if (value == 1) {
      setState(() {
        Navigator.pop(context);
      });
      loginToast(message);
    } else {
      print(message);
      failedToast(message);
    }
  }

  loginToast(String toast) {
    return Fluttertoast.showToast(
        msg: 'You Have Sucessfully Register',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.green,
        textColor: Colors.white);
  }

  failedToast(String toast) {
    return Fluttertoast.showToast(
        msg: 'Account Already Exists',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        backgroundColor: Color(0xffb5171d),
        textColor: Colors.white);
  }

  final _key = new GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
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
                            "Sign up",
                            style: TextStyle(color: Colors.white, fontSize: 40),
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
                            style: TextStyle(color: Colors.white, fontSize: 40),
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
                                          color:
                                              Color.fromRGBO(225, 95, 27, .3),
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
                                                  color: Colors.grey[200]))),
                                      child: TextFormField(
                                        validator: (e) {
                                          if (e.isEmpty) {
                                            return "Please insert username";
                                          }
                                          return null;
                                        },
                                        onSaved: (e) => username = e,
                                        decoration: InputDecoration(
                                            hintText: "username",
                                            hintStyle:
                                                TextStyle(color: Colors.grey),
                                            border: InputBorder.none),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: Colors.grey[200]))),
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
                                            hintStyle:
                                                TextStyle(color: Colors.grey),
                                            border: InputBorder.none),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: Colors.grey[200]))),
                                      child: TextFormField(
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        validator: (e) {
                                          if (e.isEmpty) {
                                            return "Please insert email";
                                          }
                                          return null;
                                        },
                                        onSaved: (e) => email = e,
                                        decoration: InputDecoration(
                                            hintText: "email",
                                            hintStyle:
                                                TextStyle(color: Colors.grey),
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
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => MyApp()));
                                },
                                child: Center(
                                  child: Text(
                                    'Back',
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
  }
}
