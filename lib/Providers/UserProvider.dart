import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  String _userName = '';
  String _photoUrl = '';
  int _highScore = 0;
  int _totalScore = 0;

  String get userName => _userName;
  String get photoUrl => _photoUrl;
  int get highScore => _highScore;
  int get totalScore => _totalScore;

  void setUserName(String name) {
    _userName = name;
    notifyListeners();
  }

  void setPhotoUrl(String url) {
    _photoUrl = url;
    notifyListeners();
  }

  void setHighScore(int score) {
    _highScore = score;
    notifyListeners();
  }

  void setTotalScore(int score) {
    _totalScore = score;
    notifyListeners();
  }

  void setUser(String name, {String url = '', int highScore = 0, int totalScore = 0}) {
    _userName = name;
    _photoUrl = url;
    _highScore = highScore;
    _totalScore = totalScore;
    notifyListeners();
  }

  void resetUser() {
    _userName = '';
    _photoUrl = '';
    _highScore = 0;
    _totalScore = 0;
    notifyListeners();
  }
}