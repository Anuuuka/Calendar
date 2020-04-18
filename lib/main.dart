import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:lab4_rpp/page/second_page.dart';
import 'package:lab4_rpp/local_notifications_helper.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final String appTitle = 'Local Notification';
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'appTitle',
    theme: ThemeData(
      primarySwatch: Colors.indigo,
    ),
    home: MainPage(),
  );
}
class MainPage extends StatefulWidget{
  @override
  _MainPageState createState() => _MainPageState();
}
class _MainPageState extends State<MainPage> {

  CalendarController _controller;
  final date2 = DateTime.now();
  final notifications = FlutterLocalNotificationsPlugin();
  @override
  void initState(){
    super.initState();
    _controller = CalendarController();
    final settingsAndroid = AndroidInitializationSettings('app_icon');
    final settingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: (id,title,body, payload) =>
            onSelectNotification(payload)
    );
    notifications.initialize(
        InitializationSettings(settingsAndroid, settingsIOS),
        onSelectNotification: onSelectNotification
    );
  }
  Future onSelectNotification(String payload) async => await Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => SecondPage(payload: payload)),
  );

  @override
  Widget build(BuildContext context)=> Scaffold(

    appBar: AppBar(title: Text('Calendar')),
    body: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TableCalendar(
            onDaySelected :(date, events) {
              final  dif = date.difference(date2).inDays;
              final uld = date.difference(date2).inHours%24;
              showDialog(
                  context: context,
                  builder: (BuildContext context){
                    return AlertDialog(
                      title:Text("Selected date"),
                      actions: <Widget>[
                        FlatButton(
                          child: Text('Cancel'),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                      content: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Text(date.toString()),
                          Text('Difference 2 dates:  (days) = '+ dif.toString()),
                          Text('+ (hours) = '+ uld.toString()),
                          RaisedButton(
                            child: Text('Show Notification'),
                            onPressed: () => showOngoingNotification(notifications,
                                title: 'Notification', body: 'We selected '+ date.toString() + 'day'),
                          )
                        ],
                      ),
                    );
                  }
              );
            },
            calendarController: _controller,
          )
        ],
      ),
    ),
  );
}
