import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:football/data/moor_database.dart';
import 'package:football/utils/formation_generator.dart';

part 'formation_layouts_event.dart';
part 'formation_layouts_state.dart';

class FormationLayoutsBloc extends Bloc<FormationLayoutsEvent, FormationLayoutsState> {
  FormationLayoutsBloc({required CurrentPlayerDao dao}) : super(FormationLayoutsInitial()) {
    dao.getPlayersOnTeam(1).then((players) => add(SetFormationLayoutSize(size: players.length)));
  }

  @override
  Stream<FormationLayoutsState> mapEventToState(
    FormationLayoutsEvent event,
  ) async* {
    if (event is SetFormationLayoutSize) {
      yield FormationLayout(formations: FormationGenerator.getFormations(event.size));
    }
  }
}
