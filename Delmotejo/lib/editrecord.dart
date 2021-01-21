import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'events.dart';

class Editrecord extends StatefulWidget {
  final Eventsdetails model;
  final VoidCallback reload;
  Editrecord(this.model, this.reload);
  @override
  _EditrecordState createState() => _EditrecordState();
}

class _EditrecordState extends State<Editrecord> {
  final _key = new GlobalKey<FormState>();
  String eventnow, pax, venue;

  final DateFormat dateFormat = DateFormat('MM-dd-yyyy HH:mm');
  TimeOfDay selecttime = new TimeOfDay.now();
  Future<TimeOfDay> _selectedTime(BuildContext context) {
    return showTimePicker(context: context, initialTime: selecttime);
  }

  DateTime selectdate;
  Future<DateTime> _selectDate(BuildContext context) => showDatePicker(
      context: context,
      initialDate: DateTime.now().add(Duration(seconds: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime(3000));
  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      save();
    }
  }

  save() async {
    String trans_dt = selectdate.toString();
    final response = await http
        .post('http://192.168.2.115/eventplanner/editrecord.php', body: {
      'eventnow': eventnow,
      'pax': pax,
      'venue': venue,
      'trans_dt': trans_dt,
      'clientid': widget.model.id,
    });
    final data = jsonDecode(response.body);
    int value = data['value'];
    if (value == 1) {
      setState(() {
        Navigator.pop(context);
      });
      Fluttertoast.showToast(
          msg: 'Event successfully updated',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 6,
          backgroundColor: Colors.green,
          textColor: Colors.white);
    } else {
      setState(() {
        Navigator.pop(context);
      });
      Fluttertoast.showToast(
          msg: 'Fail to update the record',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 6,
          backgroundColor: Color(0xffb5171d),
          textColor: Colors.white);
      String message = data['message'];
      print(message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text(
          "Event Edit record",
        ),
        backgroundColor: Colors.blue,
      ),
      backgroundColor: Colors.blue[100],
      body: Form(
        key: _key,
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 10.0,
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Edit Record Form',
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.w900),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                  child: TextFormField(
                    onSaved: (e) => eventnow = e,
                    decoration: InputDecoration(
                        labelText: 'Event',
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                          color: Color(0xff083663),
                        )),
                        border: OutlineInputBorder()),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                  child: TextFormField(
                    onSaved: (e) => pax = e,
                    decoration: InputDecoration(
                        labelText: 'How many pax?',
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                          color: Color(0xff083663),
                        )),
                        border: OutlineInputBorder()),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                  child: TextFormField(
                    onSaved: (e) => venue = e,
                    decoration: InputDecoration(
                        labelText: 'Venue of Event',
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                          color: Color(0xff083663),
                        )),
                        border: OutlineInputBorder()),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                  child: InkWell(
                    onTap: () async {
                      final selectdate = await _selectDate(context);
                      if (selectdate == null) return;

                      final selecttime = await _selectedTime(context);
                      if (selecttime == null) return;

                      setState(() {
                        this.selectdate = DateTime(
                          selectdate.year,
                          selectdate.month,
                          selectdate.day,
                          selecttime.hour,
                          selecttime.minute,
                        );
                      });
                    },
                    child: InputDecorator(
                      decoration: InputDecoration(
                          labelText: 'Date And Time of Event',
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Color(0xff083663)))),
                      baseStyle: TextStyle(
                        fontSize: 16.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            selectdate == null
                                ? '00-00-0000 00:00'
                                : dateFormat.format(selectdate),
                            style: TextStyle(
                                fontSize: 16.0, color: Color(0xff083663)),
                          ),
                          Icon(
                            Icons.calendar_today,
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? Color(0xff083663)
                                    : Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                Container(
                  height: 50,
                  width: 250,
                  child: RaisedButton(
                    onPressed: () {
                      check();
                    },
                    color: Colors.green,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30.0))),
                    textColor: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Edit Record',
                          style: TextStyle(fontSize: 15),
                        ),
                        SizedBox(
                          height: 20,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
