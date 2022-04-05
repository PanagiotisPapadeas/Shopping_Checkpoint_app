import 'package:flutter/material.dart';
import 'package:shopping_checkpoint_app/additem.dart';
import 'package:shopping_checkpoint_app/editlist.dart';

class AddList extends StatefulWidget {
  const AddList({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AddListState();
}

class _AddListState extends State<AddList> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Checkpoint'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(9.0),
              child: TextFormField(
                minLines: 5,
                maxLines: 5,
                decoration: const InputDecoration(
                    hintText: 'Add List Title',
                    border: OutlineInputBorder(borderSide: BorderSide())),
                controller: _titleController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'List title cannot be empty';
                  }
                  return null;
                },
              )
            ),
            Padding(
              padding: const EdgeInsets.all(9.0),
              child: Row(
                children: <Widget>[
                  const Flexible(fit: FlexFit.tight, child: SizedBox()),
                  Padding(
                    padding: const EdgeInsets.all(9.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel',
                          style: TextStyle(color: Colors.indigo)),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white)),
                    )
                  ),
                  Padding (
                    padding: const EdgeInsets.all(9.0),
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final entry = SList(
                              title: _titleController.text,
                              items: <Entry>[]);
                          Navigator.pop(context, entry);
                        }
                      },
                      child: const Text('Done',
                          style: TextStyle(color: Colors.indigo)),
                      style: ButtonStyle(
                        backgroundColor:
                          MaterialStateProperty.all(Colors.white)
                      ),
                    )
                  ),
                ],
              )
            )
          ],
        ),
      ),
    );
  }
}
