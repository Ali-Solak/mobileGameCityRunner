import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

part 'player_data.g.dart';

// This class stores the player progress presistently.
@HiveType(typeId: 0)
class PlayerData extends ChangeNotifier with HiveObjectMixin {
  @HiveField(1)
  int score = 0;

  int _lives = 3;

  set lives(int value) {
    if (value <= 3 && value >= 0) {
      _lives = value;
      notifyListeners();
    }
  }

  int _currentScore = 0;

  int get currentScore => _currentScore;

  set currentScore(int value) {
    _currentScore = value;

    if (score < _currentScore) {
      score = _currentScore;
    }

    notifyListeners();
    //save();
  }
}
