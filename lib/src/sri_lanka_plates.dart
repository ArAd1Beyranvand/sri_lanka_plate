import 'dart:math';

import 'package:flutter/widgets.dart' show AssetImage, EdgeInsets;
import 'package:plate_alphabet/plate_alphabet.dart';
import 'package:plate_core/plate_core.dart';

import 'sri_lanka_country.dart';
import 'sri_lanka_regions.dart';

/// One field of up to [count] evenly pitched cells centred on [cx] at
/// [pitch], in a box [top]..[top]+[height] tall; [minLength] makes it variable.
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

/// What one design shares: the canvas, the emblem box, the runs and the
/// optional hyphen after the series.
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

/// Where the ink sits, in plate units.
///
/// Front (`3_letter-2013_number_plate_Front`, vector artwork flattened to the
/// documented 520×110): province `CP` ink x 20.8–74.8 (centres 31.8, 61.3),
/// y 52–95; series `ABO` x 100–262.5 (centres 126.9, 185.4, 238.5, pitch
/// ~56); digits x 283.5–499 (centres 305.8, 362.3, 416.4, 474.5, pitch ~56);
/// series and digits y 10.5–95 (85 of ink). The emblem sits at x 14–38,
/// y 10–46. The black frame is 2.5 thick. A 85-tall ink would need a 154 box
/// on a 110 plate, so the boxes fill the canvas and the ink is ~60 (70%).
///
/// Rear (`Sri_Lanka-Southern_Province`, a photograph fitted CHECK and
/// stretched; the plate's real size is not in the article, so the canvas
/// 340×180 is the photo's 1.88 aspect). Numbers are fractions of the photo,
/// good to a few units: emblem x 0.117–0.215, y 0.12–0.35; `SP` centres 38.3,
/// 83.6, y 70–124; series `QL` centres 147, 208 (pitch 61), y 20–92; hyphen
/// x 0.31–0.35 of the width right of `L`, y ~0.38; digits centres 132, 181.6,
/// 231, 279.7 (pitch 49.2), y 108–178. The two rows overlap in their boxes
/// but not in their ink.
///
/// Not drawn: the hologram sticker, the QR code and serial under the front
/// number, and the other categories (the article gives no measurement for
/// them). No diplomatic plate is implemented, so nothing Israel-specific
/// exists here to refuse.
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

/// The Sri Lankan plates. Groups `province`, `letters` and `number`.
///
/// [front] is the one-line white plate, `CP ABO 1234`, with the province
/// below the emblem; [rear] is the yellow two-row plate, `SP QL - 9904`.
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
  // Commons: File:Emblem_of_Sri_Lanka.svg; assets/icons/emblem_of_sri_lanka.svg
  // is the vector. It is a crest, so a decal; it prints in colour here where
  // the plates stamp it in the ink.
  'assets/icons/emblem_of_sri_lanka.png',
  package: 'sri_lanka_plate',
);
