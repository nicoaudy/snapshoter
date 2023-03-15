import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final editorProvider = ChangeNotifierProvider<EditorProvider>(
  (_) => EditorProvider(),
);

class EditorProvider extends ChangeNotifier {
  double _zoom = 1.5;
  double _radius = 0;
  int _background = 0;

  double get zoom => _zoom;
  double get radius => _radius;
  int get background => _background;

  changeZoom(double payload) {
    _zoom = payload;
    notifyListeners();
  }

  changeRadius(double payload) {
    _radius = payload;
    notifyListeners();
  }

  changeBackground(int payload) {
    _background = payload;
    notifyListeners();
  }
}
