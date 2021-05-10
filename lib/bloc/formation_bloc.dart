import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'formation_event.dart';
part 'formation_state.dart';

class FormationBloc extends Bloc<FormationEvent, FormationState> {
  FormationBloc() : super(FormationCustom());

  @override
  Stream<FormationState> mapEventToState(
    FormationEvent event,
  ) async* {
    if (event is SetCustomFormation) yield FormationCustom();
    else if (event is SetFixedFormation) yield FormationFixed(formation: event.formation);
  }
}
