import 'dart:convert';

import 'package:event_planner/editrecord.dart';
import 'package:event_planner/events.dart';
import "package:flutter/material.dart";
import 'package:http/http.dart' as http;

class ViewEvents extends StatefulWidget {
  @override
  _ViewEventsState createState() => _ViewEventsState();
}

class _ViewEventsState extends State<ViewEvents> {
  var loading = false;
  final list = new List<Eventsdetails>();
  final GlobalKey<RefreshIndicatorState> _refresh =
      GlobalKey<RefreshIndicatorState>();
  Future<void> _listData() async {
    list.clear();
    setState(() {
      loading = true;
    });
    final response =
        await http.get("http://192.168.2.115/eventplanner/read.php");
    if (response.contentLength == 2) {
    } else {
      final data = jsonDecode(response.body);
      data.forEach((api) {
        final ab = new Eventsdetails(
          api['id'],
          api['eventnow'],
          api['pax'],
          api['venue'],
          api['trans_dt'],
        );
        list.add(ab);
      });
      setState(() {
        loading = false;
      });
    }
  }

  dialogDelete(String id) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: ListView(
              padding: EdgeInsets.all(16.0),
              shrinkWrap: true,
              children: <Widget>[
                Text(
                  "Are you sure want to delete this Event?",
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Text("No")),
                    SizedBox(
                      width: 16.0,
                    ),
                    InkWell(
                        onTap: () {
                          _delete(id);
                        },
                        child: Text("Yes")),
                  ],
                )
              ],
            ),
          );
        });
  }

  _delete(String id) async {
    final response = await http.post("", body: {"idProduct": id});
    final data = jsonDecode(response.body);
    int value = data['value'];
    String pesan = data['message'];
    if (value == 1) {
      setState(() {
        Navigator.pop(context);
        _listData();
      });
    } else {
      print(pesan);
    }
  }

  @override
  void initState() {
    super.initState();
    _listData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('View Event list'),
          backgroundColor: Colors.blue,
        ),
        backgroundColor: Colors.blue[100],
        body: RefreshIndicator(
          onRefresh: _listData,
          key: _refresh,
          child: loading
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, i) {
                    final x = list[i];
                    debugPrint(x.toString());
                    return Container(
                      padding: EdgeInsets.all(17.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Event:\t' + x.eventnow,
                                  style: TextStyle(
                                      fontSize: 17.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text('Pax:\t' + x.pax,
                                    style: TextStyle(fontSize: 17.0)),
                                Text('Venue #:\t' + x.venue,
                                    style: TextStyle(fontSize: 17.0)),
                                Text('Date and Time of Event :\t' + x.trans_dt,
                                    style: TextStyle(fontSize: 17.0)),
                                // Center(
                                //   child: Container(
                                //     width: 250,
                                //     child: RaisedButton(
                                //       onPressed: () {
                                //         Navigator.of(context).push(
                                //             MaterialPageRoute(
                                //                 builder: (context) =>
                                //                     Editrecord(x, _listData)));
                                //       },
                                //       color: Color(0xff083663),
                                //       shape: RoundedRectangleBorder(
                                //           borderRadius: BorderRadius.all(
                                //               Radius.circular(30.0))),
                                //       textColor: Colors.white,
                                //       child: Row(
                                //         mainAxisAlignment:
                                //             MainAxisAlignment.center,
                                //         children: <Widget>[
                                //           Icon(
                                //             Icons.edit,
                                //             color: Colors.white,
                                //           ),
                                //           Text(
                                //             'Update ',
                                //             style: TextStyle(fontSize: 15),
                                //           ),
                                //           SizedBox(
                                //             height: 17,
                                //           ),
                                //         ],
                                //       ),
                                //     ),
                                //   ),
                                // ),
                                // Center(
                                //   child: Container(
                                //     width: 250,
                                //     child: RaisedButton(
                                //       onPressed: () {
                                //         Navigator.of(context).push(
                                //             MaterialPageRoute(
                                //                 builder: (context) =>
                                //                     Editrecord(x, _listData)));
                                //       },
                                //       color: Color(0xff083663),
                                //       shape: RoundedRectangleBorder(
                                //           borderRadius: BorderRadius.all(
                                //               Radius.circular(30.0))),
                                //       textColor: Colors.white,
                                //       child: Row(
                                //         mainAxisAlignment:
                                //             MainAxisAlignment.center,
                                //         children: <Widget>[
                                //           Icon(
                                //             Icons.edit,
                                //             color: Colors.white,
                                //           ),
                                //           Text(
                                //             'Delete Event',
                                //             style: TextStyle(fontSize: 15),
                                //           ),
                                //           SizedBox(
                                //             height: 17,
                                //           ),
                                //         ],
                                //       ),
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ));
  }
}
