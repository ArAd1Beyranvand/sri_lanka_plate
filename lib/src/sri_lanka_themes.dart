import 'package:plate_core/plate_core.dart';

import 'sri_lanka_colors.dart';

/// The front frame ratio is read off vector artwork; the rear's frame and
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
