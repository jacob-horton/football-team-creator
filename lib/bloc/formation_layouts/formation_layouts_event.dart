part of 'formation_layouts_bloc.dart';

abstract class FormationLayoutsEvent extends Equatable {
  const FormationLayoutsEvent();

  @override
  List<Object> get props => [];
}

class SetFormationLayoutSize extends FormationLayoutsEvent {
  final size;

  SetFormationLayoutSize({required this.size});

  @override
  List<Object> get props => [size];
}
