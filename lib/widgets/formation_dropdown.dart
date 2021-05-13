import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:football/bloc/formation/formation_bloc.dart';
import 'package:football/widgets/rounded_container.dart';

class FormationDropdown extends StatelessWidget {
  final List<List<int>> formations;
  final Function(List<int>) onFormationSelected;

  const FormationDropdown({Key? key, required this.formations, required this.onFormationSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RoundedContainer(
      colour: const Color(0xff71c67d),
      child: BlocBuilder<FormationBloc, FormationState>(
        builder: (context, state) {
          return DropdownButtonHideUnderline(
            child: DropdownButton(
              value: _getIndex(state),
              dropdownColor: const Color(0xff333333),
              items: _buildDropdownList(state),
              onChanged: (index) {
                FormationBloc provider = BlocProvider.of<FormationBloc>(context);
                if (index == formations.length)
                  provider.add(new SetCustomFormation()); // Last item in list selected - custom
                else
                  provider.add(new SetFixedFormation(formation: formations[index as int]));
              },
              iconEnabledColor: Colors.white,
              icon: Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: Icon(Icons.arrow_drop_down),
              ),
            ),
          );
        },
      ),
    );
  }

  List<DropdownMenuItem<int>> _buildDropdownList(FormationState state) {
    List<DropdownMenuItem<int>> dropdownItems = [];
    for (int i = 0; i < formations.length; i++) {
      String formationString = _getFormationString(formations[i]);
      dropdownItems.add(_buildFormationDropdownItem(state, formationString, i));
    }

    dropdownItems.add(_buildFormationDropdownItem(state, 'CUSTOM', formations.length));
    return dropdownItems;
  }

  DropdownMenuItem<int> _buildFormationDropdownItem(FormationState state, String formationString, int index) {
    return DropdownMenuItem(
      onTap: () {
        if (state is FormationFixed) {
          List<int> formation = state.formation;
          // TODO: Set player positions based on formation
          // IDEA: Have a callback function so main_page can handle setting player positions
          onFormationSelected(formation);
        }
      },
      child: Text(formationString),
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

  int _getIndex(FormationState state) {
    if (state is FormationFixed)
      return formations.indexOf(state.formation);
    else if (state is FormationCustom) return formations.length; // Custom (last item in list)
    return -1;
  }
}