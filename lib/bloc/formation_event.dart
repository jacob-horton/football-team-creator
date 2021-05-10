part of 'formation_bloc.dart';

@immutable
abstract class FormationEvent {}

class SetCustomFormation extends FormationEvent {}
class SetFixedFormation extends FormationEvent {
  final List<int> formation;

  SetFixedFormation({required this.formation});
}
