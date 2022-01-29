import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/material.dart';

Future<AnchoredAdaptiveBannerAdSize?> anchoredAdaptiveBannerAdSize(
    BuildContext context) async {
  // Used to set size of adaptive banner ad according to device width and orientation.
  return await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
      MediaQuery.of(context).size.width.toInt());
}
