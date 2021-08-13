import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'ad_state.dart';
import 'anchored_adaptive_banner_adSize.dart';

class BannerAD extends StatefulWidget {
  const BannerAD({Key? key}) : super(key: key);

  @override
  _BannerADState createState() => _BannerADState();
}

class _BannerADState extends State<BannerAD> {
  BannerAd? banner;

  AnchoredAdaptiveBannerAdSize? size;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final adState = Provider.of<AdState>(context);
    adState.initialization.then((value) async {
      size = await anchoredAdaptiveBannerAdSize(context);
      setState(() {
        if (adState.bannerAdUnitId != null) {
          banner = BannerAd(
            listener: adState.adListener,
            adUnitId: adState.bannerAdUnitId!,
            request: AdRequest(),
            size: size!,
          )..load();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return banner ==
            null //banner is only null for a very less time //don't think that banner will be null if ads fails loads
        ? SizedBox()
        : Container(
          color: Colors.grey,
          width: size!.width.toDouble(),
          height: size!.height.toDouble(),
          child: AdWidget(
            ad: banner!,
          ),
        );
  }
}
