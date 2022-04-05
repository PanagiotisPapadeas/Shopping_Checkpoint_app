import 'package:flutter/material.dart';

class AddLis extends StatefulWidget {
  const AddLis({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AddLisState();
}

class _AddLisState extends State<AddLis> {
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
                minLines: 2,
                maxLines: 2,
                decoration: const InputDecoration(
                    hintText: 'Add Item',
                    border: OutlineInputBorder(borderSide: BorderSide())),
                controller: _titleController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Item cannot be empty';
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
                  Padding(
                    padding: const EdgeInsets.all(9.0),
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final entry = Entry(
                            title: _titleController.text,
                          );
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

class Entry {
  String title;
  bool completed;
  Entry({required this.title, this.completed = false});
}
