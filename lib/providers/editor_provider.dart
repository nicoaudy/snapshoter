import 'package:example/models/editor.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final editorProvider = StateNotifierProvider<EditorProvider, Editor>(
  (ref) => EditorProvider(),
);

class EditorProvider extends StateNotifier<Editor> {
  EditorProvider() : super(Editor());

  void changeZoom(double payload) {
    final newState = state.copy(zoom: payload);
    state = newState;
  }

  void changeRadius(double payload) {
    final newState = state.copy(radius: payload);
    state = newState;
  }

  void changeBackground(int payload) {
    final newState = state.copy(background: payload);
    state = newState;
  }

  void changeShadow(double payload) {
    final newState = state.copy(shadow: payload);
    state = newState;
  }
}
