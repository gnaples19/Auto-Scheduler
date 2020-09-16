import 'package:flutter/material.dart';

void main() => runApp(MyMaterialApp());

class MyMaterialApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Auto-Scheduler',
      theme: ThemeData(primarySwatch: Colors.green),
      home: MyHomePage(title: 'Auto-Scheduler'),
    );
  }
}

class Event {
  String activity;
  String duration;

  Event({this.activity, this.duration});

  static List<Event> getEvents() {
    return events;
    /*
    return <Event>[
      Event(activity: "Shopping", duration: "120"),
      Event(activity: "Play video game", duration: "480"),
      Event(activity: "Eat a snack", duration: "25")
    ];
    */
  }

  static addEvents(activity, duration) {
    var event = new Event();
    event.activity = activity;
    event.duration = duration;
    events.add(event);
  }
}

List<Event> events = [];

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Event> events;
  List<Event> selectedEvents;
  List<Event> withinTime;
  bool sort;

  @override
  void initState() {
    sort = false;
    selectedEvents = [];
    events = Event.getEvents();
    super.initState();
  }

  onSelectedRow(bool selected, Event event) async {
    setState(() {
      if (selected) {
        selectedEvents.add(event);
      } else {
        selectedEvents.remove(event);
      }
    });
  }

  deleteSelected() async {
    setState(() {
      if (selectedEvents.isNotEmpty) {
        List<Event> temp = [];
        temp.addAll(selectedEvents);
        for (Event event in temp) {
          events.remove(event);
          selectedEvents.remove(event);
        }
      }
    });
  }

  SingleChildScrollView dataBody() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(
            width: 50.0,
            height: 40.0,
            child: new OutlineButton(
              child: Text('NEW ACTIVITY'),
              onPressed: () {
                var event = new Event();
                event.activity = "";
                event.duration = "";
                events.add(event);
                setState(() {});
              },

              borderSide: BorderSide(
                color: Colors.green,
                style: BorderStyle.solid,
                width: 0.8,
              )
            ),
          ),
          //SizedBox(
            //child: new OutlineButton(
              //child: Text('Add Freetime'),
              //onPressed:(){
              //}
            //)
          //),

          DataTable(
            columns: [
              DataColumn(
                  label: Text("ACTIVITY"),
                  numeric: false,
                  ),
              DataColumn(
                label: Text("DURATION (minutes)"),
                numeric: true,
              ),
            ],
            rows: events
                .map(
                  (event) => DataRow(
                          selected: selectedEvents.contains(event),
                          onSelectChanged: (b) {
                            onSelectedRow(b, event);
                          },
                          cells: [
                            DataCell(
                              //Text(event.activity),
                              TextField(
                                onChanged: (text) {
                                  event.activity = text;
                                },
                              ),
                            ),
                            DataCell(
                              //Text(event.duration),
                              TextField(
                                onChanged: (text) {
                                  event.activity = text;
                                },
                              ),
                            ),
                          ]),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        verticalDirection: VerticalDirection.down,
        children: <Widget>[
          Expanded(
            child: dataBody(),
          ),
          Row(
            //https://stackoverflow.com/questions/51545768/flutter-vertically-center-column
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(75.0),
                child: OutlineButton(
                  child: Text('SELECTED ${selectedEvents.length}'),
                  onPressed: () {},
                ),
              ),
              Padding(
                padding: EdgeInsets.all(75.00),
                child: OutlineButton(
                  child: Text('DELETE SELECTED'),
                  onPressed: selectedEvents.isEmpty
                      ? null
                      : () {
                          deleteSelected();
                        },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}