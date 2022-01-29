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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Initialising adState here because it need context
    // and didChangeDependencies() is called few moments after the state loads its dependencies
    // so context is available at this moment.
    final adState = Provider.of<AdState>(context);

    adState.initialization.then((value) async {
      // Assigning the size of adaptive banner ad after adState initialization.
      size = await anchoredAdaptiveBannerAdSize(context);

      setState(() {
        // If adState.bannerAdUnitId is null don't create a BannerAd.
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
    // debugPrint('banner Status: $banner');
    if (banner == null) {
      // Generally banner is null for very less time only until it get assigned in didChangeDependencies.
      // Never think that banner will be null if ads fails loads.
      // To make banner null change the condition in didChangeDependencies or assign null to bannerAdUnitId in AdState().
      return const SizedBox();
    } else {
      return Container(
        color: AdState.adStatus ? Colors.grey : Colors.transparent,
        width: AdState.adStatus ? size!.width.toDouble() : 0,
        height: AdState.adStatus ? size!.height.toDouble() : 0,
        child: AdState.adStatus
            // If AdState.adStatus is true then ads loads
            // but if its false it will display a empty sizedBox.
            ? AdWidget(
                ad: banner!,
              )
            : const SizedBox(),
      );
    }
  }
}
