part of 'formation_layouts_bloc.dart';

abstract class FormationLayoutsState extends Equatable {
  const FormationLayoutsState();
  
  @override
  List<Object> get props => [];
}

class FormationLayoutsInitial extends FormationLayoutsState {}

class FormationLayout extends FormationLayoutsState {
  final List<List<int>> formations;

  const FormationLayout({required this.formations});
  
  @override
  List<Object> get props => [formations];
}

