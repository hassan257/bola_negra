import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdMobWidgets{
  final String? androidBannerAdUnitId;
  final String? androidInterstitialAdUnitId;

  AdMobWidgets._({this.androidBannerAdUnitId, this.androidInterstitialAdUnitId});

  static AdMobWidgets? _instance;

  static instance({String? androidBannerAdUnitId, String? androidInterstitialAdUnitId}){
    _instance ??= AdMobWidgets._(androidBannerAdUnitId: androidBannerAdUnitId, androidInterstitialAdUnitId: androidInterstitialAdUnitId);
    return _instance;
  }

  String get bannerAdUnit{
    if(Platform.isAndroid && androidBannerAdUnitId != null){
      return androidBannerAdUnitId!;
    }else{
      throw UnsupportedError("Unsupported platform");
    }
  }

  String get intersticialAdUnit{
    if(Platform.isAndroid && androidInterstitialAdUnitId != null){
      return androidInterstitialAdUnitId!;
    }else{
      throw UnsupportedError("Unsupported platform");
    }
  }
}

class BannerInlineWidget extends StatefulWidget {
  const BannerInlineWidget({Key? key}) : super(key: key);

  @override
  State<BannerInlineWidget> createState() => _BannerInlineWidgetState();
}

class _BannerInlineWidgetState extends State<BannerInlineWidget> {

  late BannerAd _ad;

  bool _isAdLoaded = false;


  @override
  void initState() {
    super.initState();
    AdMobWidgets adMobWidgets = AdMobWidgets.instance();

    _ad = BannerAd(
      adUnitId: adMobWidgets.bannerAdUnit,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          // Releases an ad resource when it fails to load
          ad.dispose();

          // ignore: avoid_print
          print('Ad load failed (code=${error.code} message=${error.message})');
        },
      ),
    );

    _ad.load();
  }

  @override
  void dispose() {
    _ad.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // if (_isAdLoaded && index == _kAdIndex) {
    if (_isAdLoaded) {
      return Container(
        // color: Colors.red,
        width: _ad.size.width.toDouble(),
        height: 72.0,
        alignment: Alignment.center,
        // color: Colors.red,
        child: AdWidget(ad: _ad),
      );
    } else {
      // final item = widget.entries[_getDestinationItemIndex(index)];

      return const SizedBox(
        height: 72,
        width: double.infinity,
        // color: Colors.red,
      );
    }
  }
}

class BannerWidget extends StatelessWidget {
  const BannerWidget({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        height: 50,
        child: BannerInlineWidget(),
      ),
    );
  }
}

class InterstitialUnit{
  InterstitialAd? _interstitialAd;

  InterstitialUnit();

  InterstitialAd? get interstitialAd => _interstitialAd;

  void loadAd() {
    AdMobWidgets adMobWidgets = AdMobWidgets.instance();
    InterstitialAd.load(
        adUnitId: adMobWidgets.intersticialAdUnit,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          // Called when an ad is successfully received.
          onAdLoaded: (InterstitialAd ad) {
            ad.fullScreenContentCallback = FullScreenContentCallback(
                // Called when the ad showed the full screen content.
                onAdShowedFullScreenContent: (ad) {},
                // Called when an impression occurs on the ad.
                onAdImpression: (ad) {},
                // Called when the ad failed to show full screen content.
                onAdFailedToShowFullScreenContent: (ad, err) {
                  ad.dispose();
                },
                // Called when the ad dismissed full screen content.
                onAdDismissedFullScreenContent: (ad) {
                  ad.dispose();
                },
                // Called when a click is recorded for an ad.
                onAdClicked: (ad) {});

            // Keep a reference to the ad so you can show it later.
            _interstitialAd = ad;
          },
          // Called when an ad request failed.
          onAdFailedToLoad: (LoadAdError error) {
            // ignore: avoid_print
            print('InterstitialAd failed to load: $error');
          },
        ));
  }
}