import 'package:oktv/presentation/utility/global.dart' as global;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:oktv/presentation/utility/custom_text_style.dart';
import 'package:oktv/presentation/utility/size_config.dart';


class Carousel extends StatelessWidget {
  Carousel({super.key});

  final List<String> _collection = [
    'If some videos are not playing, search for another one. Because the video owner disabled the embed and recording.',
    'Example: All videos from "Sing King channel" cannot be played and recorded due to embedded disabled by the channel owner.',
    'Upload recorded song immediately on cloud storage or any social media platform to save storage space.',
    'You can record your song with or without using the front camera.',
    'You can record your song here and upload on any social media platform anytime.',
    'You cannot reserve list item here at Recording studio.',
    'During recording you will never see advertisement, however all songs will be recorded automatically.',
    'Click animated GIF image to hide or show image',
  ];

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return CarouselSlider(
      options: CarouselOptions(
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 7),
        enlargeCenterPage: true,
      ),
      items: _collection.map((String message) {
        return Builder(
          builder: (BuildContext context) {
            return Padding(
              padding: EdgeInsets.symmetric(
                vertical: SizeConfig.safeBlockVertical * 1,
              ),
              child: Container(
                //width: MediaQuery.of(context).size.width,
                width: SizeConfig.safeBlockHorizontal * 40,
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.safeBlockVertical * 1,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Center(
                  child: Text(
                    message,
                    style: textColored2(context, global.palette6, FontWeight.normal),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}
