import 'package:oktv/presentation/utility/global.dart' as global;
import 'package:flutter/material.dart';
import 'package:oktv/presentation/utility/size_config.dart';
import 'package:oktv/presentation/utility/custom_text_style.dart';
import 'package:oktv/presentation/utility/constants.dart' as constants;

class MobileShowOkDialog extends StatelessWidget {

  final String title;
  final String description;
  final Function onTap;
  const MobileShowOkDialog({
    super.key,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Stack(
      children: [
        Positioned(
          right: 0,
          top: 1,
          bottom: 1,
          child: Dialog(
            child: Container(
              width: SizeConfig.safeBlockVertical * 16,
              height: SizeConfig.safeBlockVertical * 36,
              //color: Colors.greenAccent,
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.safeBlockVertical * 2
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  top: SizeConfig.safeBlockVertical * 2,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      title,
                      style: textColored3(context, global.palette6, FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),

                    Text(
                      description,
                      style: textColored2(context, global.textColorDark, FontWeight.normal),
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: SizeConfig.safeBlockVertical * 2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          _closeButton(context),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _closeButton(context) =>
    GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
          onTap.call();
        },
        child: Container(
          width: SizeConfig.safeBlockVertical * 28,
          height: SizeConfig.safeBlockVertical * 7,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              SizeConfig.safeBlockVertical * 2,
            ),
            color: global.palette6,
          ),
          child: Center(
            child: Text(
              constants.capClose,
              style: textColored2(context, global.palette1, FontWeight.bold),
            ),
          ),
        ),
      );
}
