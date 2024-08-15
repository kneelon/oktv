import 'package:oktv/presentation/utility/global.dart' as global;
import 'package:flutter/material.dart';
import 'package:oktv/presentation/utility/size_config.dart';
import 'package:oktv/presentation/utility/custom_text_style.dart';

Widget tabletCustomButton(context, String title, VoidCallback onPress) {
  SizeConfig().init(context);

  return InkWell(
    onTap: () {
      onPress.call();
    },
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(SizeConfig.safeBlockVertical * 1),
        color: global.palette6,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.safeBlockHorizontal * 2,
          vertical: SizeConfig.safeBlockVertical * 1,
        ),
        child: Text(title, style: textColored1(context, global.palette1, FontWeight.normal),),
      ),
    ),
  );
}

Widget deleteButton(context, VoidCallback onPress) {
  SizeConfig().init(context);

  return InkWell(
    onTap: () {
      onPress.call();
    },
    child: Padding(
      padding: EdgeInsets.all(SizeConfig.safeBlockVertical * 0),
      child: Icon(
        Icons.delete_forever_outlined,
        color: global.errorColor,
        size: SizeConfig.safeBlockVertical * 4.5,
      ),
    ),
  );
}