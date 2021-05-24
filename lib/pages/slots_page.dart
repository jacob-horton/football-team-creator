import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:football/bloc/formation/formation_bloc.dart';
import 'package:football/data/moor_database.dart';
import 'package:provider/provider.dart';

class SlotsPage extends StatelessWidget {
  final TextEditingController slotNameController = TextEditingController();

  SlotsPage({Key? key}) : super(key: key);

  // TODO: Enter trigger save
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Slot Name', style: TextStyle(fontSize: 30.0)),
            content: TextField(
              autofocus: true,
              controller: slotNameController,
              style: Theme.of(context).textTheme.bodyText2?.copyWith(fontSize: 20.0),
              decoration: InputDecoration(
                hintStyle: Theme.of(context).textTheme.caption?.copyWith(fontSize: 18.0),
                hintText: 'Name',
              ),
            ),
            actions: [
              TextButton(child: Text('CANCEL'), onPressed: () => Navigator.of(context).pop()),
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Provider.of<SaveSlotDao>(context, listen: false).saveSlot(slotNameController.text);
                  slotNameController.clear();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('SLOTS', style: TextStyle(fontSize: 30)),
            StreamBuilder<List<SaveSlot>>(
              stream: Provider.of<SaveSlotDao>(context).watchAllSlots(),
              builder: (context, snapshot) {
                final slots = snapshot.data ?? [];

                return Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.only(top: 15),
                    itemBuilder: (context, index) => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(slots[index].name, style: TextStyle(fontSize: 18.0)),
                            ),
                            onTap: () async {
                              final players = await Provider.of<SaveSlotDao>(context, listen: false).loadSlot(slots[index].name);
                              BlocProvider.of<FormationBloc>(context, listen: false).add(SetTeams(players: players));
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          child: Icon(Icons.delete_outline),
                          onTap: () => Provider.of<SaveSlotDao>(context, listen: false).deleteSlot(slots[index].name),
                        ),
                      ],
                    ),
                    separatorBuilder: (context, index) => Divider(height: 0),
                    itemCount: slots.length,
                  ),
                );
              },
            ),
            TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('BACK')),
          ],
        ),
      ),
    );
  }
}
