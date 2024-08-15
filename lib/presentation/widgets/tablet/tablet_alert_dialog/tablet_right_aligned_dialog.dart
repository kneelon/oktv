import 'package:oktv/presentation/utility/global.dart' as global;
import 'package:flutter/material.dart';
import 'package:oktv/presentation/utility/size_config.dart';
import 'package:oktv/presentation/utility/custom_text_style.dart';

class TabletRightAlignedDialog extends StatelessWidget {

  final String title;
  final String addFavorite;
  final String addItem;
  final Function onAddItemClicked;
  final Function onFavoriteClicked;
  final Function onClosed;
  const TabletRightAlignedDialog({
    super.key,
    required this.title,
    required this.addFavorite,
    required this.addItem,
    required this.onAddItemClicked,
    required this.onFavoriteClicked,
    required this.onClosed,
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
              width: SizeConfig.safeBlockVertical * 54,
              height: SizeConfig.safeBlockVertical * 40,
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
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: SizeConfig.safeBlockVertical * 2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const SizedBox(),
                          Text(
                            'Reserve this item?',
                            style: textColored2(context, global.palette6, FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                              onClosed.call();
                            },
                            child: Icon(
                              Icons.highlight_remove,
                              color: global.errorColor,
                              size: SizeConfig.safeBlockVertical * 4,
                            ),
                          )
                        ],
                      ),
                    ),

                    Text(
                      title,
                      style: textColored1(context, global.textColorDark, FontWeight.normal),
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: SizeConfig.safeBlockVertical * 2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          _addItemButton(context),
                          _addFavoriteButton(context),
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

  Widget _addItemButton(context) =>
    GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
        onAddItemClicked.call();
      },
      child: Container(
        width: SizeConfig.safeBlockVertical * 20,
        height: SizeConfig.safeBlockVertical * 6,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            SizeConfig.safeBlockVertical * 1,
          ),
          border: Border.all(
            width: SizeConfig.safeBlockVertical * .2,
            color: global.textColorDark,
          )
        ),
        child: Center(
          child: Text(
            addItem,
            style: textColored1(context, global.textColorDark, FontWeight.normal),
          ),
        ),
      ),
    );

  Widget _addFavoriteButton(context) =>
    GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
          onFavoriteClicked.call();
        },
        child: Container(
          width: SizeConfig.safeBlockVertical * 20,
          height: SizeConfig.safeBlockVertical * 6,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              SizeConfig.safeBlockVertical * 1,
            ),
            color: global.palette6,
          ),
          child: Center(
            child: Text(
              addFavorite,
              style: textColored1(context, global.palette1, FontWeight.normal),
            ),
          ),
        ),
      );
}
