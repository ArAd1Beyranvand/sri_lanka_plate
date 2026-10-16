import 'dart:math';

import 'package:flutter/widgets.dart' show AssetImage, EdgeInsets;
import 'package:plate_alphabet/plate_alphabet.dart';
import 'package:plate_core/plate_core.dart';

import 'sri_lanka_country.dart';
import 'sri_lanka_regions.dart';

/// Up to [count] cells at [pitch] centred on [cx], in a box [height] tall
/// from [top]; [minLength] makes the field variable.
class _Run {
  const _Run(
    this.key,
    this.alphabet,
    this.count,
    this.cx,
    this.pitch,
    this.top,
    this.height, {
    this.minLength,
  });

  final String key;
  final PlateAlphabet alphabet;
  final int count;
  final double cx, pitch, top, height;
  final int? minLength;
}

class _Design {
  const _Design({
    required this.id,
    required this.width,
    required this.height,
    required this.emblem,
    required this.runs,
    this.hyphen,
  });

  final String id;
  final double width, height;
  final PlateBox emblem;
  final List<_Run> runs;
  final PlateBox? hyphen;
}

/// Ink positions in plate units, measured from the vector front artwork
/// (520x110) and a photograph of the rear. Rear values are good to a few
/// units; its 340x180 canvas only matches the photo's aspect. The front's
/// 85-unit ink would need a 154 box on a 110 plate, so boxes fill the canvas
/// and the ink is ~70% of it. The rear's rows overlap in their boxes, not in
/// their ink. The hologram, QR code and other categories are not drawn.
abstract final class _Layout {
  static const _Design front = _Design(
    id: 'lk.front',
    width: 520,
    height: 110,
    emblem: PlateBox(14, 10, 24, 36),
    runs: <_Run>[
      _Run('province', SriLankaAlphabets.letters, 2, 46.55, 29.5, 43.5, 60),
      _Run(
        'letters',
        SriLankaAlphabets.letters,
        3,
        182.7,
        55.8,
        0,
        110,
        minLength: 2,
      ),
      _Run('number', SriLankaAlphabets.digits, 4, 390.2, 56.2, 0, 110),
    ],
  );

  static const _Design rear = _Design(
    id: 'lk.rear',
    width: 340,
    height: 180,
    emblem: PlateBox(40, 21, 33, 46),
    runs: <_Run>[
      _Run('province', SriLankaAlphabets.letters, 2, 60.95, 45.3, 48, 100),
      _Run('letters', SriLankaAlphabets.letters, 2, 177.5, 61, 4, 100),
      _Run('number', SriLankaAlphabets.digits, 4, 206, 49.2, 100, 80),
    ],
    hyphen: PlateBox(240, 58, 44, 20),
  );

  static const double hyphenGlyph = 30;
}

/// [front] is the one-line white plate (`CP ABO 1234`); [rear] the yellow
/// two-row plate (`SP QL - 9904`). Groups: `province`, `letters`, `number`.
abstract final class SriLankaPlates {
  static final PlateSpec front = _spec(_Layout.front);
  static final PlateSpec rear = _spec(_Layout.rear);

  static List<PlateSpec> get all => <PlateSpec>[front, rear];

  static PlateSpec _spec(_Design d) {
    final List<PlateSlot> slots = <PlateSlot>[];
    final List<PlateTextGroup> groups = <PlateTextGroup>[];
    for (final _Run r in d.runs) {
      groups.add(PlateTextGroup(<int>[slots.length], key: r.key));
      slots.add(
        PlateSlot(
          alphabet: r.alphabet,
          box: PlateBox(
            r.cx - r.pitch * r.count / 2,
            r.top,
            r.pitch * r.count,
            r.height,
          ),
          length: r.count,
          minLength: r.minLength,
          spacing: r.minLength == null
              ? max(0, r.pitch - 0.6 * 0.72 * r.height)
              : 0,
        ),
      );
    }
    return PlateSpec(
      id: d.id,
      country: SriLankaCountry.sri_lanka,
      canvasWidth: d.width,
      canvasHeight: d.height,
      panel: PlatePanel(
        box: PlateBox(0, 0, 0, d.height),
        padding: EdgeInsets.zero,
      ),
      decals: <PlateDecal>[PlateDecal(image: _emblem, box: d.emblem)],
      slots: slots,
      labels: <PlateLabel>[
        if (d.hyphen != null)
          PlateLabel(
            text: '–',
            box: d.hyphen!,
            glyphHeight: _Layout.hyphenGlyph,
          ),
      ],
      textGroups: groups,
      resolveRegion: SriLankaRegions.captionOf,
    );
  }
}

const AssetImage _emblem = AssetImage(
  // A coloured decal; the plates stamp the crest in ink.
  'assets/icons/emblem_of_sri_lanka.png',
  package: 'sri_lanka_plate',
);
