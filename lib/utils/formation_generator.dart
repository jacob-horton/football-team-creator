class FormationGenerator {
  static const standardFormations = [
    [4, 4, 2],
    [3, 5, 2],
    [4, 5, 1],
  ];

  static List<List<int>> getFormations(int size) {
    List<List<int>> formations = standardFormations.map((formation) => FormationGenerator._getScaledFormation(formation, size)).toList();
    return _removeDuplicates(formations);
  }

  static List<int> _getScaledFormation(List<int> standard, int size) {
    double scaleFactor = size / standard.reduce((a, b) => a + b);

    List<double> idealFormationLayout = standard.map((row) => row * scaleFactor).toList();
    List<int> formationLayout = idealFormationLayout.map((row) => row.round()).toList();
    int formationSize = formationLayout.reduce((a, b) => a + b);

    if (formationSize != size) {
      // Calculate the row closest to rounding the other way (the decimal part will be closest to 0.5)
      int indexToChange = 0;
      double closestDistToHalf = ((formationLayout[0] - formationLayout[0].truncate()) - 0.5).abs();

      for (int i = 0; i < formationLayout.length; i++) {
        final distToHalf = ((formationLayout[i] - formationLayout[i].truncate()) - 0.5).abs();
        if (distToHalf < closestDistToHalf) {
          closestDistToHalf = distToHalf;
          indexToChange = i;
        }
      }

      if (formationSize < size) {
        // Need to add a player
        formationLayout[indexToChange]++;
      } else {
        // Need to remove a player
        formationLayout[indexToChange]--;
      }
    }

    return formationLayout..removeWhere((row) => row == 0); // Remove empty rows
  }

  static List<List<int>> _removeDuplicates(List<List<int>> formations) {
    List<List<int>> checked = [];

    for (final formation in formations) {
      if (!checked.any((checkedFormation) => _isFormationEquivalent(formation, checkedFormation))) checked.add(formation);
    }

    return checked;
  }

  static bool _isFormationEquivalent(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) if (a[i] != b[i]) return false;
    return true;
  }
}
