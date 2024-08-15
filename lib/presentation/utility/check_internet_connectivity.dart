import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:oktv/main.dart';
import 'package:oktv/presentation/ui/mobile/mobile_homepage.dart';
import 'package:oktv/presentation/widgets/mobile/mobile_alert_dialog/mobile_alert_dialog.dart';
import 'package:oktv/presentation/widgets/tablet/tablet_alert_dialog/tablet_alert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:oktv/presentation/utility/constants.dart' as constants;

Future<bool> isInternetConnected(context) async {
  final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  bool result = false;
  bool isTablet = false;
  final List<ConnectivityResult> connectivityResult = await (Connectivity().checkConnectivity());

  if (sharedPreferences.getBool(constants.isTablet) != null) {
    isTablet = sharedPreferences.getBool(constants.isTablet)!;
  }
  if (connectivityResult.contains(ConnectivityResult.none)) {
    if (isTablet) {
      tabletDialogErrorDone(
          context,
          'No internet tablet',
          'Oops, No internet connection, \nplease connect to the internet.',
          () {},
          //() => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SplashScreenPage())),
      );
    } else {
      mobileDialogErrorDone(
          context,
          'No internet',
          'Oops, No internet connection, \nplease connect to the internet.',
          () {},
          //() => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SplashScreenPage())),
      );
    }

    result = false;
  } else {
    result = true;
  }
  return result;
}