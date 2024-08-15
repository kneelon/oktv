import 'package:oktv/presentation/utility/constants.dart' as constants;
import 'package:flutter/material.dart';
import 'package:oktv/presentation/utility/size_config.dart';

class CustomFloatingActionButton extends StatefulWidget {
  final Function onPress;
  const CustomFloatingActionButton({super.key, required this.onPress});

  @override
  State<CustomFloatingActionButton> createState() => _CustomFloatingActionButtonState();
}

class _CustomFloatingActionButtonState extends State<CustomFloatingActionButton> {

  double _imageSize = 0;

  void _adjustImageSize(context, bool isTablet) {
    if (isTablet) {
      _imageSize = SizeConfig.safeBlockVertical * 11;
    } else {
      _imageSize = SizeConfig.safeBlockVertical * 16;
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double screenWidth = SizeConfig.safeBlockHorizontal * 100;
    if (screenWidth > 900 && screenWidth < 4000) {
      _adjustImageSize(context, true);
    } else {
      _adjustImageSize(context, false);
    }

    return SizedBox(
      width: _imageSize,
      height: _imageSize,
      child: FloatingActionButton(
        onPressed: () {
          widget.onPress.call();
        },
        backgroundColor: Colors.white,
        elevation: 9,
        shape: const CircleBorder(),
        child: ClipOval(
          child: SizedBox(
            width: _imageSize,
            height: _imageSize,
            child: Image.asset(
              semanticLabel: 'Full Screen', constants.imgLogo,
            ),
          ),
        ),
      ),
    );
  }
}




