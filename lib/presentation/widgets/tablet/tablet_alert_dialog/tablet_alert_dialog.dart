
import 'package:oktv/presentation/utility/global.dart' as global;
import 'package:oktv/presentation/utility/constants.dart' as constants;
import 'package:flutter/material.dart';
import 'package:oktv/presentation/utility/size_config.dart';
import 'package:oktv/presentation/widgets/global/custom_alert_dialog.dart';
import 'package:oktv/presentation/utility/custom_text_style.dart';


tabletDialogContactDeveloper(
    BuildContext context,
    String title,
    String description,
    ) {

  Widget myTitle = Padding(
    padding: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 5),
    child: Text(
      title,
      style: textBold1(context),
    ),
  );

  Widget myDescription = Center(
    child: Text(
      description,
      textAlign: TextAlign.center,
      style: textStyle1(context),
    ),
  );

  Widget onCloseClick = InkWell(
    onTap: () {
      Navigator.of(context).pop(false);
      //onCloseClicked.call();
    },
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          SizeConfig.safeBlockVertical * 2,
        ),
        color: global.palette6,
      ),
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: SizeConfig.safeBlockVertical * 1
          ),
          child: Text(
            'Close',
            style: textColored2(context, global.palette1, FontWeight.w300),
          ),
        ),
      ),
    ),
  );

  CustomDialog alert = CustomDialog(
    backgroundColor: global.alertDialogBgColor,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20)
    ),
    title: Center(
        child: myTitle),
    actions: [
      Padding(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.safeBlockVertical * 12,
        ),
        child: Column(
          children: [
            myDescription,
            SizedBox(height: SizeConfig.safeBlockVertical * 6,),
            onCloseClick,
            SizedBox(height: SizeConfig.safeBlockVertical * 6),
          ],
        ),
      ),
    ],
  );
  showCustomDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

////////////////////////////////////////////////////////////////////////////////

tabletDialogDisplaySearchInfo(
    BuildContext context,
    ) {

  Widget myTitle = Padding(
    padding: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 5),
    child: Text(
      'How to Add item',
      style: textBold2(context),
    ),
  );

  Widget myDescription = Center(
    child: Image.asset(
      'assets/show_info.webp',
      scale: 1.2,
    ),
  );

  Widget onCloseClick = InkWell(
    onTap: () {
      Navigator.of(context).pop(false);
    },
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          SizeConfig.safeBlockVertical * 2,
        ),
        color: global.palette6,
      ),
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: SizeConfig.safeBlockVertical * 1,
          ),
          child: Text(
            constants.capClose,
            style: textColored2(context, global.palette1, FontWeight.w300),
          ),
        ),
      ),
    ),
  );

  CustomDialog alert = CustomDialog(
    backgroundColor: global.backGroundColor,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20)
    ),
    title: Center(
        child: myTitle),
    actions: [
      Padding(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.safeBlockVertical * 12,
        ),
        child: Column(
          children: [
            myDescription,
            SizedBox(height: SizeConfig.safeBlockVertical * 6,),
            onCloseClick,
            SizedBox(height: SizeConfig.safeBlockVertical * 6),
          ],
        ),
      ),
    ],
  );
  showCustomDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

////////////////////////////////////////////////////////////////////////////////

tabletDialogVideoEnded(
    BuildContext context,
    String title,
    String description,
    Function onConfirmed,
    ) {

  Widget icon = Container(
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        border: Border.all(
          color: global.successColor,
          width: SizeConfig.safeBlockHorizontal * 1.2,
        )
    ),
    child: Padding(
      padding: EdgeInsets.all(SizeConfig.safeBlockHorizontal * 2),
      child: Icon(
        Icons.check_rounded,
        color: global.successColor,
        size: SizeConfig.safeBlockHorizontal * 10,
      ),
    ),
  );

  Widget myTitle = Padding(
    padding: EdgeInsets.only(top: SizeConfig.safeBlockHorizontal * 5),
    child: Text(
        title,
        style: textColored5(context, global.palette3, FontWeight.bold)
    ),
  );

  Widget myDescription = Center(
    child: Padding(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.safeBlockHorizontal * 4,
      ),
      child: Text(
        description,
        textAlign: TextAlign.center,
        style: textStyle3(context),
      ),
    ),
  );

  Widget confirmButton = GestureDetector(
    onTap: () {
      Navigator.of(context).pop();
      onConfirmed.call();
    },
    child: Container(
      width: SizeConfig.safeBlockHorizontal * 100,
      height: SizeConfig.safeBlockHorizontal * 10,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          SizeConfig.safeBlockHorizontal * 2,
        ),
        color: global.palette6,
      ),
      child: Center(
        child: Text(
          constants.wordPlayNow,
          style: textColored4(context, global.palette1, FontWeight.w300),
        ),
      ),
    ),
  );

  CustomDialog alert = CustomDialog(
    backgroundColor: global.alertDialogBgColor,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20)
    ),
    title: Center(
        child: Column(
          children: [
            icon,
            myTitle,
          ],
        )),
    actions: [
      Padding(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.safeBlockHorizontal * 6,
        ),
        child: Column(
          children: [
            myDescription,
            SizedBox(height: SizeConfig.safeBlockHorizontal * 4),
            confirmButton,
            SizedBox(height: SizeConfig.safeBlockHorizontal * 6,),
          ],
        ),
      ),
    ],
  );
  showCustomDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

////////////////////////////////////////////////////////////////////////////////

tabletDialogErrorDone(
    BuildContext context,
    String title,
    String description,
    Function onConfirmed,
    ) {

  Widget icon = Padding(
    padding: EdgeInsets.all(SizeConfig.safeBlockVertical * 2),
    child: Icon(
      Icons.error_outline,
      color: global.errorColor,
      size: SizeConfig.safeBlockVertical * 16,
    ),
  );

  Widget myTitle = Padding(
    padding: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 5),
    child: Text(
        title,
        style: textColored5(context, global.palette3, FontWeight.bold)
    ),
  );

  Widget myDescription = Center(
    child: Text(
      description,
      textAlign: TextAlign.center,
      style: textStyle3(context),
    ),
  );

  Widget confirmButton = GestureDetector(
    onTap: () {
      Navigator.of(context).pop();
      onConfirmed.call();
    },
    child: Container(
      width: SizeConfig.safeBlockVertical * 50,
      height: SizeConfig.safeBlockVertical * 10,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          SizeConfig.safeBlockVertical * 2,
        ),
        color: global.errorColor,
      ),
      child: Center(
        child: Text(
          constants.capClose,
          style: textColored4(context, global.palette1, FontWeight.w300),
        ),
      ),
    ),
  );

  CustomDialog alert = CustomDialog(
    contentPadding: EdgeInsets.symmetric(
      horizontal: SizeConfig.safeBlockVertical * 12,
    ),
    backgroundColor: global.alertDialogBgColor,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20)
    ),
    title: Center(
        child: Column(
          children: [
            icon,
            myTitle,
          ],
        )),
    actions: [
      Column(
        children: [
          myDescription,
          SizedBox(height: SizeConfig.safeBlockVertical * 4),
          confirmButton,
          SizedBox(height: SizeConfig.safeBlockVertical * 6,),
        ],
      ),
    ],
  );
  showCustomDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}