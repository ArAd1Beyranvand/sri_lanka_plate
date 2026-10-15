import 'package:flutter_test/flutter_test.dart';
import 'package:plate_core/plate_core.dart';
import 'package:sri_lanka_plate/sri_lanka_plate.dart';

void main() {
  test('a full province code names the province', () {
    expect(SriLankaRegions.lookup('WP'), 'Western Province');
    expect(SriLankaRegions.lookup('NC'), 'North Central Province');
    expect(SriLankaRegions.lookup('SG'), 'Sabaragamuwa Province');
  });

  test('a first letter names the province only when unambiguous', () {
    expect(SriLankaRegions.lookup('W'), 'Western Province');
    expect(SriLankaRegions.lookup('C'), 'Central Province');
    expect(SriLankaRegions.lookup('N'), isNull);
    expect(SriLankaRegions.lookup('S'), isNull);
    expect(SriLankaRegions.lookup(''), isNull);
  });

  test('unissued codes name nothing', () {
    for (final String code in <String>['AB', 'WX', 'Z']) {
      expect(SriLankaRegions.lookup(code), isNull, reason: code);
    }
  });

  test('both plates follow each letter typed and deleted', () {
    for (final PlateSpec spec in SriLankaPlates.all) {
      final PlateController c = PlateController(spec: spec);
      expect(c.regionCaption, isNull);
      c.setGroup('province', 'S');
      expect(c.regionCaption, isNull);
      c.setGroup('province', 'SP');
      expect(c.regionCaption, 'Southern Province');
      c.setGroup('province', 'S');
      expect(c.regionCaption, isNull);
    }
  });
}
