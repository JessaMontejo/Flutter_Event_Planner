import 'package:event_planner/addevent.dart';
import 'package:event_planner/vieweditevent.dart';
import 'package:event_planner/viewevents.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Menu extends StatefulWidget {
  final VoidCallback signOut;
  Menu(this.signOut);
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  signOut() {
    setState(() {
      widget.signOut();
    });
  }

  String username = "", email = "";
  getpref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      username = preferences.getString("username");
      email = preferences.getString("email");
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getpref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text('Event Planner'),
        backgroundColor: Colors.blue,
      ),
      backgroundColor: Colors.blue[100],
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text("$username", style: TextStyle(fontSize: 20.0)),
              accountEmail: Text("$email", style: TextStyle(fontSize: 20.0)),
              decoration: BoxDecoration(color: Colors.blue),
            ),
            Divider(),
            ListTile(
              title: Text('Sign out', style: TextStyle(fontSize: 20.0)),
              trailing: Icon(Icons.exit_to_app),
              onTap: () {
                signOut();
                Fluttertoast.showToast(
                    msg: 'You Have Sucessfully Logout',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 5,
                    backgroundColor: Colors.green,
                    textColor: Colors.white);
              },
            ),
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(30),
        child: GridView.count(
          crossAxisCount: 2,
          children: <Widget>[
            Card(
              margin: EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => Addevent()));
                },
                splashColor: Colors.blue,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                        Icons.add,
                        size: 70,
                      ),
                      Text('Add Event', style: TextStyle(fontSize: 17.0)),
                    ],
                  ),
                ),
              ),
            ),
            Card(
              margin: EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => ViewEvents()));
                },
                splashColor: Colors.blue,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                        Icons.local_library,
                        size: 70,
                      ),
                      Text('View Event', style: TextStyle(fontSize: 17.0)),
                    ],
                  ),
                ),
              ),
            ),
            Card(
              margin: EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => Vieweditevent()));
                },
                splashColor: Colors.blue,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                        Icons.edit,
                        size: 70,
                      ),
                      Text('Edit Event', style: TextStyle(fontSize: 17.0)),
                    ],
                  ),
                ),
              ),
            ),
            Card(
              margin: EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {},
                splashColor: Colors.blue,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                        Icons.exit_to_app,
                        size: 70,
                      ),
                      Text('Sign Out', style: TextStyle(fontSize: 17.0)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
