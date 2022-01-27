import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'ad_state.dart';
import 'anchored_adaptive_banner_ad_size.dart';

class BannerAD extends StatefulWidget {
  const BannerAD({Key? key}) : super(key: key);

  @override
  _BannerADState createState() => _BannerADState();
}

class _BannerADState extends State<BannerAD> {
  BannerAd? banner;

  AnchoredAdaptiveBannerAdSize? size;

  String? now;
  Timer? everySecond;

  @override
  void initState() {
    super.initState();

    // sets first value
    now = DateTime.now().second.toString();

    // Defines a timer to update ad ui according to latest adStatus value from AdState class
    // This timer is set to setState every 5 seconds
    // We are using it to hide ad loading status
    // Hides ad only if ad fails to load with internet available on user device
    everySecond = Timer.periodic(const Duration(seconds: 5), (Timer t) {
      if (mounted) {
        setState(() {
          now = DateTime.now().second.toString();
        });
      }
    });
  }

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
            request: const AdRequest(),
            size: size!,
          )..load();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (banner == null) {
      // banner is only null for a very less time
      // Never think that banner will be null if ads fails loads
      return const SizedBox();
    } else {
      return Container(
        color: AdState.adStatus ? Colors.grey : Colors.transparent,
        width: AdState.adStatus ? size!.width.toDouble() : 0,
        height: AdState.adStatus ? size!.height.toDouble() : 0,
        child: AdState.adStatus
            ? AdWidget(
                ad: banner!,
              )
            : Container(),
      );
    }
  }
}
