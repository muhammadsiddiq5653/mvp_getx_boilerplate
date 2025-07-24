import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../core/services/admob_service.dart';

class BannerAdWidget extends StatelessWidget {
  final AdSize adSize;
  final EdgeInsets margin;

  const BannerAdWidget({
    Key? key,
    this.adSize = AdSize.banner,
    this.margin = const EdgeInsets.all(8.0),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AdMobService adService = Get.find();

    return Obx(() {
      // Don't show ads if user is premium or ads are disabled
      if (adService.isPremiumUser || !adService.isAdsEnabled) {
        return const SizedBox.shrink();
      }

      // Don't show if banner ad is not loaded
      if (!adService.isBannerAdLoaded || adService.bannerAd == null) {
        return const SizedBox.shrink();
      }

      return Container(
        margin: margin,
        width: adSize.width.toDouble(),
        height: adSize.height.toDouble(),
        child: AdWidget(ad: adService.bannerAd!),
      );
    });
  }
}

class SmartBannerAdWidget extends StatelessWidget {
  final EdgeInsets margin;

  const SmartBannerAdWidget({
    Key? key,
    this.margin = const EdgeInsets.all(8.0),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BannerAdWidget(
      adSize: AdSize.getSmartBanner(Orientation.portrait),
      margin: margin,
    );
  }
}

class LargeBannerAdWidget extends StatelessWidget {
  final EdgeInsets margin;

  const LargeBannerAdWidget({
    Key? key,
    this.margin = const EdgeInsets.all(8.0),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BannerAdWidget(
      adSize: AdSize.largeBanner,
      margin: margin,
    );
  }
}

class MediumRectangleAdWidget extends StatelessWidget {
  final EdgeInsets margin;

  const MediumRectangleAdWidget({
    Key? key,
    this.margin = const EdgeInsets.all(8.0),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BannerAdWidget(
      adSize: AdSize.mediumRectangle,
      margin: margin,
    );
  }
}