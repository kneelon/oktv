import 'package:oktv/presentation/utility/global.dart' as global;
import 'package:oktv/presentation/utility/constants.dart' as constants;
import 'package:flutter/material.dart';
import 'package:oktv/presentation/utility/size_config.dart';
import 'package:oktv/presentation/utility/custom_text_style.dart';

class MobileRightAlignedRecordingDialog extends StatelessWidget {

  final String title;
  final String description;
  final Function onCancelClicked;
  final Function onConfirmClicked;
  const MobileRightAlignedRecordingDialog({
    super.key,
    required this.title,
    required this.description,
    required this.onCancelClicked,
    required this.onConfirmClicked,
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
              height: SizeConfig.safeBlockVertical * 44,
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.safeBlockVertical * 2,
                vertical: SizeConfig.safeBlockVertical * 3,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: SizeConfig.safeBlockVertical * 2),
                    child: Text(
                      title,
                      style: textColored3(context, global.palette5, FontWeight.normal),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                  Text(
                    description,
                    style: textColored2(context, global.textColorDark, FontWeight.normal),
                    maxLines: 3,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: SizeConfig.safeBlockVertical * 2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        _cancelButton(context),
                        _recordingButton(context),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _cancelButton(context) =>
    GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
        onCancelClicked.call();
      },
      child: Container(
        width: SizeConfig.safeBlockVertical * 28,
        height: SizeConfig.safeBlockVertical * 7,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            SizeConfig.safeBlockVertical * 2,
          ),
          border: Border.all(
            width: SizeConfig.safeBlockVertical * .4,
            color: global.textColorDark,
          )
        ),
        child: Center(
          child: Text(
            constants.capNo,
            style: textColored2(context, global.textColorDark, FontWeight.bold),
          ),
        ),
      ),
    );

  Widget _recordingButton(context) =>
    GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
          onConfirmClicked.call();
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
              constants.capYes,
              style: textColored2(context, global.palette1, FontWeight.bold),
            ),
          ),
        ),
      );
}
