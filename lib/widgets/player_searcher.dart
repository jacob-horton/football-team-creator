import 'package:flutter/material.dart';

import 'input_box.dart';

class PlayerSearcher extends StatelessWidget {
  final bool multiselect;
  final void Function() onOk;
  final void Function() onCancel;

  const PlayerSearcher({Key? key, required this.onOk, required this.onCancel, required this.multiselect}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25, top: 25, bottom: 25, right: 20),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: InputBox(hint: 'Search', icon: Icons.search)),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: GestureDetector(child: Icon(Icons.add),  onTap: () => print('Add player')),
              ),
            ],
          ),
          Expanded(child: ListView(children: [])),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(child: Text('CANCEL'), onPressed: onOk),
              TextButton(child: Text('OK'), onPressed: onCancel),
            ],
          )
        ],
      ),
    );
  }
}
