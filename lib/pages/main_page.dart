import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:football/bloc/formation_bloc.dart';
import 'package:football/models/player.dart';
import 'package:football/pages/player_selector.dart';
import 'package:football/utils/window_resize.dart';
import 'package:football/widgets/player_draggable.dart';
import 'package:window_size/window_size.dart';

class MainPage extends StatelessWidget {
  final List<List<int>> formations = [
    [4, 4, 2],
    [3, 5, 2]
  ];

  MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),
      body: Container(
        color: const Color(0xff4eb85c),
        child: Stack(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(50.0),
                child: Stack(
                  children: [
                    Image.asset('assets/background.png'),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: const Color(0xff71c67d),
                    ),
                    height: 28.0,
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: BlocBuilder<FormationBloc, FormationState>(
                      builder: (context, state) {
                        int? index;
                        if (state is FormationFixed)
                          index = formations.indexOf(state.formation);
                        else if (state is FormationCustom) index = formations.length; // Custom (last item in list)

                        return DropdownButtonHideUnderline(
                          child: DropdownButton(
                            value: index,
                            dropdownColor: const Color(0xff333333),
                            items: _buildDropdownList(),
                            onChanged: (index) {
                              if (index == formations.length)
                                BlocProvider.of<FormationBloc>(context).add(new SetCustomFormation()); // Last item in list selected - custom
                              else {
                                BlocProvider.of<FormationBloc>(context).add(new SetFixedFormation(formation: formations[index as int]));
                              }
                            },
                            iconEnabledColor: Colors.white,
                            icon: Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Icon(Icons.arrow_drop_down),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(left: 10.0)),
                  TextButton(
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                      backgroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xff71c67d),
                      ),
                    ),
                    onPressed: () => _navigateToPlayerSelector(context),
                    child: Container(
                      height: 25.0,
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Center(child: Text('CHANGE PLAYERS', style: TextStyle(letterSpacing: 1.5, fontWeight: FontWeight.w400))),
                    ),
                  ),
                ],
              ),
            ),
            PlayerDraggable(player: Player(name: 'Jacob Horton', number: 1, score: 10, col: Colors.blue)),
            PlayerDraggable(player: Player(name: 'Daniel Kingshott', number: 5, score: 1, col: Colors.red)),
          ],
        ),
      ),
    );
  }

  _navigateToPlayerSelector(BuildContext context) {
    setWindowTitle('Player Selector');
    WindowResize.setSize(const Size(500, 725), fixedSize: true);
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => PlayerSelector()));
  }

  List<DropdownMenuItem<int>> _buildDropdownList() {
    List<DropdownMenuItem<int>> dropdownItems = [];
    for (int i = 0; i < formations.length; i++) {
      String formationString = _getFormationString(formations[i]);
      dropdownItems.add(_formationDropdownItem(formationString, i));
    }

    dropdownItems.add(_formationDropdownItem('CUSTOM', formations.length));
    return dropdownItems;
  }

  DropdownMenuItem<int> _formationDropdownItem(String formationString, int index) {
    return DropdownMenuItem(
      child: Text(formationString, style: TextStyle(color: Colors.white)),
      value: index,
    );
  }

  String _getFormationString(List<int> formation) {
    String formationString = '';
    for (int i = 0; i < formation.length; i++) {
      formationString += formation[i].toString();
      if (i != formation.length - 1) formationString += ' - ';
    }

    return formationString;
  }
}
