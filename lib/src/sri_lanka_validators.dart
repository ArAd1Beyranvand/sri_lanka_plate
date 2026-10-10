import 'package:plate_core/plate_core.dart';

/// Judges a Sri Lankan plate: a province code (`CP`, `EP`, `NC`, `NP`, `NW`,
/// `SG`, `SP`, `UP` or `WP`), two or three letters and four digits. Reports,
/// never bars a keystroke.
class SriLankaValidator extends GatedPlateValidator {
  const SriLankaValidator();

  @override
  String get gateGroup => 'number';

  static const String reasonProvince =
      'The province is CP, EP, NC, NP, NW, SG, SP, UP or WP.';
  static const String reasonLetters = 'The series is two or three letters.';
  static const String reasonNumber = 'The number is four digits.';

  static const Set<String> provinces = <String>{
    'CP', 'EP', 'NC', 'NP', 'NW', 'SG', 'SP', 'UP', 'WP', //
  };

  static final RegExp _letters = RegExp(r'^[A-Z]{2,3}$');

  @override
  PlateValidation judge(PlateEntry entry) {
    if (!provinces.contains(entry.group('province'))) {
      return const PlateValidation.invalid(reasonProvince);
    }
    if (!_letters.hasMatch(entry.group('letters'))) {
      return const PlateValidation.invalid(reasonLetters);
    }
    if (!isDigitsOfLength(entry.group('number'), 4)) {
      return const PlateValidation.invalid(reasonNumber);
    }
    return const PlateValidation.valid();
  }
}
