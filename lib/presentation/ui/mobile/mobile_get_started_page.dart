import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oktv/presentation/ui/mobile/mobile_homepage.dart';
import 'package:oktv/presentation/utility/global.dart' as global;
import 'package:oktv/presentation/utility/constants.dart' as constants;
import 'package:oktv/presentation/utility/size_config.dart';


class MobileGetStartedPage extends StatefulWidget {
  final String url;
  const MobileGetStartedPage({super.key, required this.url});

  @override
  State<MobileGetStartedPage> createState() => _MobileGetStartedPageState();
}

class _MobileGetStartedPageState extends State<MobileGetStartedPage> {
  
  void _delayedFunction(context) {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => MobileHomepage(availableUrl: widget.url)));
    });
  }

  @override
  void initState() {
    super.initState();
    _delayedFunction(context);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: global.palette2,
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: SizeConfig.safeBlockVertical * 2
                ),
                child: Text(
                  'OKTV',
                  style: TextStyle(
                    fontSize: SizeConfig.safeBlockVertical * 4,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const CircleAvatar(
                radius: 36,
                backgroundImage: AssetImage(
                  constants.imgLogo,
                ),
              ),
            ],
          ),
        )
      ),
    );
  }
}
