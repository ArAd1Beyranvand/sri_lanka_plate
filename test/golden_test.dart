import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sri_lanka_plate/sri_lanka_plate.dart';
import 'package:plate_core/plate_core.dart';

/// One golden per category, drawn with real bold faces so the ink can be
/// measured against the references (`platekit golden-check`).
///
/// Regenerate with `flutter test --update-goldens` after a deliberate change.
void main() {
  setUpAll(() async {
    final FontLoader loader = FontLoader('Roboto');
    for (final String path in const <String>[
      '/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf',
    ]) {
      final File face = File(path);
      if (!face.existsSync()) continue;
      loader.addFont(face.readAsBytes().then((b) => ByteData.view(b.buffer)));
    }
    await loader.load();
  });

  /// category id -> (spec, theme, space-separated sample value)
  final Map<String, (PlateSpec, PlateTheme, String)> cases =
      <String, (PlateSpec, PlateTheme, String)>{
        'front': (SriLankaPlates.front, SriLankaThemes.front, 'CP ABO 1234'),
        'rear': (SriLankaPlates.rear, SriLankaThemes.rear, 'SP QL 9904'),
        'front_two_letters': (
          SriLankaPlates.front,
          SriLankaThemes.front,
          'WP AB 5678',
        ),
      };

  test('fields: letters 2-3, completes at the minimum', () {
    final PlateSpec spec = SriLankaPlates.front;
    expect(spec.slots.length, 3);
    expect(spec.slots[1].minLength, 2);
    expect(spec.slots[1].length, 3);
    final PlateController c = PlateController.fromValues(spec, [
      'WP',
      'A',
      '1234',
    ]);
    expect(c.isCompleted, isFalse);
    c.setAt(1, 'AB');
    expect(c.isCompleted, isTrue);
    c.dispose();
  });

  for (final MapEntry<String, (PlateSpec, PlateTheme, String)> c
      in cases.entries) {
    testWidgets(c.key, (tester) async {
      final (PlateSpec spec, PlateTheme theme, String values) = c.value;
      final PlateController controller = PlateController.fromValues(
        spec,
        values.split(' '),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 680,
                height: 300,
                child: PlateThemeScope(
                  theme: theme,
                  child: PlateView(
                    controller: controller,
                    theme: theme,
                    country: SriLankaCountry.sri_lanka,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 300)),
      );
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(PlateView),
        matchesGoldenFile('goldens/lk_${c.key}.png'),
      );
      await tester.pumpWidget(const SizedBox.shrink());
      controller.dispose();
    });
  }
}
