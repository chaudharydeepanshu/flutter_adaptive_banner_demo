import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/material.dart';

Future<AnchoredAdaptiveBannerAdSize?> anchoredAdaptiveBannerAdSize(
    BuildContext context) async {
  //commented out as google_mobile_ads version 0.13.6 supports AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize() to support getting an AnchoredAdaptiveBannerAdSize in the current orientation.
  // return await AdSize.getAnchoredAdaptiveBannerAdSize(
  //   MediaQuery.of(context).orientation == Orientation.portrait
  //       ? Orientation.portrait
  //       : Orientation.landscape,
  //   MediaQuery.of(context).size.width.toInt(),
  // );
  return await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
      MediaQuery.of(context).size.width.toInt());
}
