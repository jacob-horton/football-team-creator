part of 'formation_bloc.dart';

@immutable
abstract class FormationState {

}

class FormationFixed extends FormationState {
  final List<int> formation;

  FormationFixed({required this.formation});
}

class FormationCustom extends FormationState {}
