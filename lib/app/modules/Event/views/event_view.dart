import 'package:flutter/material.dart';

class EventView extends StatefulWidget {
  const EventView({Key? key}) : super(key: key);

  @override
  State<EventView> createState() => _EventViewState();
}

class _EventViewState extends State<EventView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                margin: EdgeInsets.all(50),
                child: Table(
                  defaultColumnWidth: FixedColumnWidth(200.0),
                  border: TableBorder.all(
                    color: Colors.black,
                    style: BorderStyle.solid,
                    width: 1,
                  ),
                  children: const [
                    TableRow(
                      children: [
                        Column(
                          children: [
                            Text('EventId', style: TextStyle(fontSize: 20.0)),
                          ],
                        ),
                        Column(
                          children: [
                            Text('EventName', style: TextStyle(fontSize: 20.0)),
                          ],
                        ),
                        Column(
                          children: [
                            Text('EventDate', style: TextStyle(fontSize: 20.0)),
                          ],
                        ),
                        Column(
                          children: [
                            Text('EventLocation',
                                style: TextStyle(fontSize: 20.0)),
                          ],
                        ),
                        Column(
                          children: [
                            Text('EventTime', style: TextStyle(fontSize: 20.0)),
                          ],
                        ),
                        Column(
                          children: [
                            Text('EventDescription',
                                style: TextStyle(fontSize: 20.0)),
                          ],
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        Column(children: [Text('Javatpoint')]),
                        Column(children: [Text('Flutter')]),
                        Column(children: [Text('5*')]),
                        Column(children: [Text('Javatpoint')]),
                        Column(children: [Text('Flutter')]),
                        Column(children: [Text('5*')]),
                      ],
                    ),
                    TableRow(
                      children: [
                        Column(children: [Text('Javatpoint')]),
                        Column(children: [Text('MySQL')]),
                        Column(children: [Text('5*')]),
                        Column(children: [Text('Javatpoint')]),
                        Column(children: [Text('Flutter')]),
                        Column(children: [Text('5*')]),
                      ],
                    ),
                    TableRow(
                      children: [
                        Column(children: [Text('Javatpoint')]),
                        Column(children: [Text('ReactJS')]),
                        Column(children: [Text('5*')]),
                        Column(children: [Text('Javatpoint')]),
                        Column(children: [Text('Flutter')]),
                        Column(children: [Text('5*')]),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
