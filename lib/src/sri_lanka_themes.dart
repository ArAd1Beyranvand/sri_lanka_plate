import 'package:plate_core/plate_core.dart';

import 'sri_lanka_colors.dart';

/// Front: black on white inside a black frame, 2.5 of 110 thick (0.0227) as
/// read off the vector reference. The rear is black on yellow; its frame and
/// radius are estimated from a photograph.
abstract final class SriLankaThemes {
  static final PlateTheme front = PlateTheme.monochrome(
    field: SriLankaColors.white,
    ink: SriLankaColors.black,
    inactive: SriLankaColors.inactive,
    borderWidthRatio: 0.0227,
    plateRadiusRatio: 0.055,
  );

  static final PlateTheme rear = PlateTheme.monochrome(
    field: SriLankaColors.yellow,
    ink: SriLankaColors.rearInk,
    inactive: SriLankaColors.inactive,
    borderWidthRatio: 0.012,
    plateRadiusRatio: 0.04,
  );
}
