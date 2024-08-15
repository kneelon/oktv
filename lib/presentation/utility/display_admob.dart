
import 'dart:async';
import 'package:oktv/main.dart';
import 'package:oktv/presentation/utility/constants.dart' as constants;
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:oktv/presentation/utility/size_config.dart';

class DisplayAdmob extends StatefulWidget {

  const DisplayAdmob({
    super.key,
  });

  @override
  State<DisplayAdmob> createState() => _DisplayAdmobState();
}

class _DisplayAdmobState extends State<DisplayAdmob> {

  BannerAd? _bannerAd;
  late String _adId = constants.adMobTestAppId;


  void _displayBannerAd() {
    Future.delayed(const Duration(seconds: 7));
    _bannerAd = BannerAd(
      adUnitId: _adId, //Test
      //adUnitId: constants.adMobAppId, //Production
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          debugPrint('>>> BannerAd loaded.');
          setState(() {
            // Refresh state to show the ad
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          debugPrint('>>> BannerAd failed to load: $error');
          ad.dispose();
        },
      ),
    )..load();
  }


  @override
  void initState() {
    super.initState();
    _displayBannerAd();
  }

  @override
  void dispose() {
    super.dispose();
    _bannerAd!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double screenWidth = SizeConfig.safeBlockHorizontal * 100;
    if (screenWidth > 900 && screenWidth < 4000) {
      _adId = constants.adMobTestAdaptive;
    }

    return Center(
      child: _bannerAd == null
        ? const SizedBox()
        : Container(
            alignment: Alignment.center,
            width: _bannerAd!.size.width.toDouble(),
            height: _bannerAd!.size.height.toDouble(),
            child: AdWidget(ad: _bannerAd!),
      ),
    );
  }
}
