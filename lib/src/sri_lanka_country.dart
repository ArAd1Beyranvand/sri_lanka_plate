import 'package:plate_core/plate_core.dart';

import 'sri_lanka_colors.dart';

/// No flag or side band; the emblem is a decal on each spec.
abstract final class SriLankaCountry {
  // ignore: constant_identifier_names
  static const PlateCountry sri_lanka = PlateCountry(
    code: 'lk',
    captionLines: <String>[],
    panelColor: SriLankaColors.white,
    panelTextColor: SriLankaColors.black,
  );
}
