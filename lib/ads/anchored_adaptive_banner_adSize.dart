import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/material.dart';

Future<AnchoredAdaptiveBannerAdSize?> anchoredAdaptiveBannerAdSize(
    BuildContext context) async {
  return await AdSize.getAnchoredAdaptiveBannerAdSize(
    MediaQuery.of(context).orientation == Orientation.portrait
        ? Orientation.portrait
        : Orientation.landscape,
    MediaQuery.of(context).size.width.toInt(),
  );
}