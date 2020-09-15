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
    /*return <Event>[
      Event(activity: "Shopping", duration: "120),
      Event(activity: "Play video game", duration: "480"),
      Event(activity: "Eat a snack", duration: "25"),
    ];*/
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
  bool sort;

  @override
  void initState() {
    sort = false;
    selectedEvents = [];
    events = Event.getEvents();
    super.initState();
  }

  onSortColumn(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      if (ascending) {
        events.sort((a, b) => a.activity.compareTo(b.activity));
      } else {
        events.sort((a, b) => b.activity.compareTo(a.activity));
      }
    }
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
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          OutlineButton(
            child: Text('NEW'),
            onPressed: () {
              var event = new Event();
              event.activity = "";
              event.duration = "";
              events.add(event);
              setState(() {});
            },
          ),
          DataTable(
            sortAscending: sort,
            sortColumnIndex: 0,
            columns: [
              DataColumn(
                  label: Text("ACTIVITY"),
                  numeric: false,
                  tooltip: "This is Activity name",
                  onSort: (columnIndex, ascending) {
                    setState(() {
                      sort = !sort;
                    });
                    onSortColumn(columnIndex, ascending);
                  }),
              DataColumn(
                label: Text("DURATION"),
                numeric: true,
                tooltip: "Amount of time for the Activity",
              ),
            ],
            rows: events
                .map(
                  (event) => DataRow(
                          selected: selectedEvents.contains(event),
                          onSelectChanged: (b) {
                            print("Onselect");
                            onSelectedRow(b, event);
                          },
                          cells: [
                            DataCell(
                              //Text(event.activity),
                              TextField(
                                onChanged: (text) {
                                  print("First text field: $text");
                                  event.activity = text;
                                },
                              ),
                            ),
                            DataCell(
                              Text(event.duration),
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