import 'dart:async';
import 'package:adaptive_banner_ads_demo/connectivity/init_connectivity.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'ad_state.dart';
import 'anchored_adaptive_banner_ad_size.dart';

class BannerADCustomised extends StatefulWidget {
  const BannerADCustomised({Key? key}) : super(key: key);

  @override
  _BannerADCustomisedState createState() => _BannerADCustomisedState();
}

class _BannerADCustomisedState extends State<BannerADCustomised> {
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  BannerAd? banner;

  AnchoredAdaptiveBannerAdSize? size;

  @override
  void initState() {
    super.initState();
    initConnectivityResult();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);

    // Defines a timer to update ad ui according to latest adStatus value from AdState class.
    // This timer is set to setState every 5 seconds.
    // We are using it to hide ad loading status.
    // Hides ad only if ad fails to load with internet available on user device.
    // Generally checks is suddenly ads are available or not and if available loads it
    // so you can remove this if you don't want to do that.
    Timer.periodic(const Duration(seconds: 5), (Timer t) {
      debugPrint("LOL setState");
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    // Disposing stream subscription.
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> initConnectivityResult() async {
    late ConnectivityResult? result;
    result = await initConnectivity(connectivity: _connectivity);

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted || result == null) {
      return Future.value(null);
    }

    // If the widget is not disposed and result is not null then calling _updateConnectionStatus().
    return _updateConnectionStatus(result);
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    // Calling setState to update _connectionStatus new value in widget.
    setState(() {
      _connectionStatus = result;
      if (banner != null) {
        banner!.load();
      }
    });
  }

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
    // debugPrint('Connection Status: ${_connectionStatus.toString()}');
    debugPrint('banner Status: $banner');
    if (banner == null) {
      // Generally banner is null for very less time only until it get assigned in didChangeDependencies.
      // Never think that banner will be null if ads fails loads.
      // To make banner null change the condition in didChangeDependencies or assign null to bannerAdUnitId in AdState().
      return const SizedBox();
    } else {
      if (_connectionStatus == ConnectivityResult.none) {
        // _connectionStatus is ConnectivityResult.none only if mobile data & wifi both are turned off.
        return Container(
          height: AdSize.banner.height.toDouble() + 10,
          width: size!.width.toDouble(),
          color: Colors.grey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: size!.height.toDouble(),
                    width: size!.width.toDouble(),
                    child: const FittedBox(
                      child: Padding(
                        padding: EdgeInsets.only(left: 8.0, right: 8.0),
                        child: Text(
                          'To support the app please connect to internet.',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      } else {
        // If _connectionStatus is not ConnectivityResult.none then try to load ad.
        return Container(
          color: AdState.adStatus ? Colors.grey : Colors.transparent,
          width: AdState.adStatus ? size!.width.toDouble() : 0,
          height: AdState.adStatus ? size!.height.toDouble() : 0,
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // If AdState.adStatus is true then displays this message under transparent AdWidget()
                      // but if its false it will display a empty sizedBox.
                      if (AdState.adStatus)
                        SizedBox(
                          width: AdState.adStatus ? size!.width.toDouble() : 0,
                          height:
                              AdState.adStatus ? size!.height.toDouble() : 0,
                          child: const FittedBox(
                            child: Padding(
                              padding: EdgeInsets.only(left: 8.0, right: 8.0),
                              child: Text(
                                'Ad loading...\nThanks for your support',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        )
                      else
                        const SizedBox(),
                    ],
                  ),
                ],
              ),

              // If AdState.adStatus is true then ads loads over the message
              // but if its false it will display a empty sizedBox.
              if (AdState.adStatus)
                AdWidget(
                  ad: banner!,
                )
              else
                const SizedBox(),
            ],
          ),
        );
      }
    }
  }
}
