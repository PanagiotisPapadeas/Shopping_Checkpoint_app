import 'package:flutter/material.dart';
import 'package:shopping_checkpoint_app/additem.dart';
import 'package:shopping_checkpoint_app/camera.dart';
import 'package:camera/camera.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

late List<CameraDescription> cameras;
bool isInitialized = false;

class StScreen extends StatefulWidget {
  final SList slist;
  const StScreen({Key? key, required this.slist}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _StScreenState(this.slist);
}

class _StScreenState extends State<StScreen> {
  late CameraController controller;
  final SList slist;
  late FlutterLocalNotificationsPlugin flutterNotificationPlugin;

  _StScreenState(this.slist);

  @override
  void initState() {
    super.initState();
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('cart');
    var initializationSettings = new InitializationSettings(
        android: initializationSettingsAndroid, iOS: null);

    flutterNotificationPlugin = FlutterLocalNotificationsPlugin();

    flutterNotificationPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
    controller = CameraController(cameras[0], ResolutionPreset.max);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future onSelectNotification(String? payload) async {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text("Hello Everyone"),
              content: Text("$payload"),
            ));
  }

  Future showNotitication() async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'Notification Channel ID',
      'Channel Name',
      'Description',
      importance: Importance.max,
      priority: Priority.high,
    );

    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    flutterNotificationPlugin.show(0, 'New Alert',
        'How to show Local Notification', platformChannelSpecifics,
        payload: 'Default Sound');
  }

  Future shoppingMode() async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'Notification Channel ID',
      'Channel Name',
      'Description',
      importance: Importance.max,
      priority: Priority.high,
    );

    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    var flag = 1;
    String x;
    if (slist.items.isEmpty) {
      flag = 0;
    } else {
      for (var i = 0; i < slist.items.length; i++) {
        if (slist.items[i].completed == false) flag = 2;
      }
    }
    if (flag == 1) {
      x = 'List complete!';
    } else if (flag == 0) {
      x = 'List is empty';
    } else {
      x = 'You have still items to buy in your list';
    }

    flutterNotificationPlugin.show(0, 'Reminder: Your shopping list',
        x, platformChannelSpecifics,
        payload: 'Default Sound');

    var scheduledTime = DateTime.now().add(Duration(seconds: 10));
    flutterNotificationPlugin.schedule(
        1,
        'Reminder: Your shopping list',
        "Don't forget any of your items! Check your list!",
        scheduledTime,
        platformChannelSpecifics,
        payload: 'Default Sound');
  }

  void _deleteItem(int idx) async {
    slist.items.removeAt(idx);
    setState(() {});
  }

  void _checkBought() async {
    var flag = 1;
    String x;
    if (slist.items.isEmpty) {
      flag = 0;
    } else {
      for (var i = 0; i < slist.items.length; i++) {
        if (slist.items[i].completed == false) flag = 2;
      }
    }
    if (flag == 1) {
      x = 'List complete!';
    } else if (flag == 0) {
      x = 'List is empty';
    } else {
      x = 'You have still items to buy in your list';
    }
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              content: Text("'" + x + "'"),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () => Navigator.pop(context),
                )
              ],
            ));
  }

  void _addNewE() async {
    final Entry _newEntry = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => AddLis()));

    if (_newEntry != null) {
      slist.items.add(Entry(title: _newEntry.title));
      setState(() {});
    }
  }

  Widget _buildshopList() {
    return ListView.separated(
      padding: const EdgeInsets.all(16.0),
      separatorBuilder: (context, index) => const Divider(),
      itemCount: slist.items.length,
      itemBuilder: (context, index) {
        IconData iconData;
        String toolTip;

        if (slist.items[index].completed) {
          iconData = Icons.check_box_outlined;
          toolTip = "Mark as unbought";
        } else {
          iconData = Icons.check_box_outline_blank_outlined;
          toolTip = "Mark as bought";
        }

      final item = slist.items[index].title;
      return Dismissible(
            // Each Dismissible must contain a Key. Keys allow Flutter to
            // uniquely identify widgets.
            key: Key(item),
            // Provide a function that tells the app
            // what to do after an item has been swiped away.
            onDismissed: (direction) {
              // Remove the item from the data source.
              setState(() {
                slist.items.removeAt(index);
              });
            },

        child: ListTile(
          leading: IconButton(
            icon: Icon(iconData),
            onPressed: () {
              slist.items[index].completed = !slist.items[index].completed;
              setState(() {});
            },
            tooltip: 'Mark as bought',
          ),
          tileColor: Colors.grey[300],
          title: Text(slist.items[index].title),
          trailing: IconButton(
            icon: Icon(Icons.disabled_by_default),
            onPressed: () {
              _deleteItem(index);
            },
            tooltip: 'Delete item',
          ),
        ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(slist.title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // final SList lis = SList(title: slist.title);
            Navigator.pop(context);
          },
          tooltip: 'Go back',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              shoppingMode();
            },
            tooltip: 'Enable Reminder',
          ),
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (context) => <PopupMenuEntry<int>>[
              const PopupMenuItem<int>(
                  value: 1,
                  child: ListTile(
                    title: Text("Clear All"),
                  )),
              const PopupMenuItem<int>(
                  value: 2,
                  child: ListTile(
                    title: Text("Check All"),
                  )),
              const PopupMenuItem<int>(
                  value: 3,
                  child: ListTile(
                    title: Text("Uncheck All"),
                  )),
              const PopupMenuItem<int>(
                  value: 4,
                  child: ListTile(
                    title: Text("Order by Name"),
                  )),
            ],
            onSelected: (value) => {
              setState(() {
                if (value == 1) {
                  slist.items.clear();
                } else if (value == 2) {
                  for (var i = 0; i < slist.items.length; i++) {
                    slist.items[i].completed = true;
                  }
                } else if (value == 3) {
                  for (var i = 0; i < slist.items.length; i++) {
                    slist.items[i].completed = false;
                  }
                } else if (value == 4) {
                  slist.items.sort((a, b) => a.title.compareTo(b.title));
                }
              })
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                  icon: const Icon(Icons.camera_alt),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => CameraScreen(slist: slist)))
                        .then((value) => setState(() => {}));
                  },
                  tooltip: 'Fill list with camera'),
              Padding(padding: const EdgeInsets.all(30.0)),
              IconButton(
                  icon: const Icon(Icons.check_circle_rounded),
                  onPressed: () {
                    _checkBought();
                  },
                  tooltip: 'Validation'),
            ]),
        color: Colors.white,
      ),
      body: _buildshopList(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: _addNewE,
        backgroundColor: Colors.lightGreen,
        tooltip: 'Add item',
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class SList {
  String title;
  List<Entry> items;
  bool completed = false;

  SList({required this.title, required this.items});
}
