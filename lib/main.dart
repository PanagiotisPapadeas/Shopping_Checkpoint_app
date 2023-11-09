import 'package:flutter/material.dart';
import 'package:shopping_checkpoint_app/additem.dart';
import 'package:shopping_checkpoint_app/addlist.dart';
import 'package:camera/camera.dart';
import 'package:shopping_checkpoint_app/editlist.dart';

Future<void> main() async {
 WidgetsFlutterBinding.ensureInitialized();

 cameras = await availableCameras();
 runApp(const Shopping());
}

class Shopping extends StatelessWidget {
  const Shopping({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping Checkpoint',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.indigo,
      ),
      home: const StartScreen(),
    );
  }
}

class StartScreen extends StatefulWidget {
  const StartScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {


  final _lists = <SList>[];

  void _addNewEntry() async {
    final SList _newEntry = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const AddList()));

    _lists.add(SList(title: _newEntry.title, items: <Entry>[]));

    setState(() {});
    }

  void _editList(int index) async {
    await Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => StScreen(slist: _lists[index])));

    setState(() {});
  }

  void _deleteList(int idx) async {
    bool? _delList = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: const Text('Are you sure you want to delete this list?'),
        actions: <Widget>[
          TextButton(
            child: const Text('No'),
            onPressed: () => Navigator.pop(context, false),
          ),
          TextButton(
            child: const Text('Yes'),
            onPressed: () => Navigator.pop(context, true),
          )
        ],
      )
    );
    if (_delList!) {
      _lists.removeAt(idx);
      setState(() {});
    }
  }

  Widget _buildShoppingList() {
    return ListView.separated(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, index) {
        return ListTile (
          tileColor: Colors.grey[400],
          title: Text(_lists[index].title),
          onLongPress: () {
            _deleteList(index);
          },
          trailing: IconButton(
            icon: const Icon(Icons.border_color),
            onPressed: () {
              _editList(index);
              //Navigator.push(
              //context,
              //MaterialPageRoute(builder: (context) => const Shop()),
              //);
            },
            tooltip: "Edit List"
          ),
        );
      },
      separatorBuilder: (context, index) => const Divider(),
      itemCount: _lists.length
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold (
      appBar: AppBar (
        leading: PopupMenuButton(
          icon: const Icon(Icons.list),
          tooltip: 'Menu',
          itemBuilder: (context) => <PopupMenuEntry<int>>[
            const PopupMenuItem<int>(
              value: 1,
              child: ListTile(
                title: Text("Clear All"),
              )
            ),
          ],
          onSelected: (value) => {
            setState(() {
              if (value == 1) {
                _lists.clear();
              }
            })
          }
        ),
        title: const Text('Shopping Checkpoint'),
      ),
      body: _buildShoppingList(),
      floatingActionButton: FloatingActionButton (
        child: const Icon(Icons.add),
        onPressed: () {
          _addNewEntry();
        },
        backgroundColor: Colors.lightGreen,
        tooltip: 'Create List',
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}
