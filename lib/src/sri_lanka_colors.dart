import 'package:flutter/widgets.dart';

/// The colours of the Sri Lankan plates: black on white at the front, and on
/// yellow at the rear. The yellow `FFCC01` is the colour-balanced field of the
/// Southern Province photograph; its ink `4F4E3C` is the photo's, so it is
/// softer than the front plate's vector black.
abstract final class SriLankaColors {
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color yellow = Color(0xFFFFCC01);
  static const Color rearInk = Color(0xFF4F4E3C);
  static const Color inactive = Color(0xFFB0B0B0);
}
