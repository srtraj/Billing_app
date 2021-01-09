import 'package:flutter/widgets.dart';

class SizeConfig {
  static double _screenWidth;
  static double _screenHeight;

  static double height_factor;
  static double width_factor;
  static double Body_height_factor;
  static double screen_height_factor;
  static double _screenBodyHeight;
  static double _screenBodyExpectAppbarHeight;
  static double safeAreaheight;

  void screen_Height(BoxConstraints constraints, Orientation orientation) {
    if (orientation == Orientation.portrait) {
      _screenWidth = constraints.maxWidth;
      _screenHeight = constraints.maxHeight;
    } else {
      _screenWidth = constraints.maxHeight;
      _screenHeight = constraints.maxWidth;
    }
    width_factor = _screenWidth / 100;
    screen_height_factor = _screenHeight / 100;
  }

  void body_Height(BoxConstraints constraints) {
    _screenBodyHeight = constraints.maxHeight;
    Body_height_factor = _screenBodyHeight / 100;
  }

  void body_ExpectAppbar_Height(BoxConstraints constraints) {
    _screenBodyExpectAppbarHeight = constraints.maxHeight;
    height_factor = _screenBodyExpectAppbarHeight / 100;
  }

  static double billBdHeight;
  bodyHeight(BoxConstraints constraints) {
    billBdHeight = constraints.maxHeight / 100;
  }
}
