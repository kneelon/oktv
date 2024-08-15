import 'package:flutter/services.dart';
import 'package:oktv/presentation/utility/global.dart' as global;
import 'package:flutter/material.dart';
import 'package:oktv/data/model/faqs_model.dart';
import 'package:oktv/presentation/utility/faqs_list.dart';
import 'package:oktv/presentation/utility/size_config.dart';
import 'package:oktv/presentation/utility/custom_text_style.dart';

class MobileFaqsPage extends StatefulWidget {
  const MobileFaqsPage({super.key});

  @override
  State<MobileFaqsPage> createState() => _MobileFaqsPageState();
}

class _MobileFaqsPageState extends State<MobileFaqsPage> {

  late FaqsModel _faqsModel;
  final List<FaqsModel> _itemList = [];

  void _getFaqsInformation() {

    for (int i = 0; i < faqsTitle.length; i++) {
      String title = faqsTitle[i];
      String description = faqsDescription[i];
      String imageAsset = faqsImage[i];

      _faqsModel = FaqsModel(
          title: title,
          description: description,
          image: imageAsset,
      );
      _itemList.add(_faqsModel);
    }
  }

  @override
  void initState() {
    super.initState();
    _getFaqsInformation();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      backgroundColor: global.palette2,
      appBar: AppBar(
        backgroundColor: global.palette2,
        title: Text(
          'Frequently Ask Question',
          style: TextStyle(
            fontSize: SizeConfig.safeBlockVertical * 5,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: _itemList.length,
        itemBuilder: (context, index) {
          final faqs = _itemList[index];
          return _buildLayer(faqs);
        },
      ),
    );
  }

  Widget _buildLayer(FaqsModel faqs) =>
    Padding(
      padding: EdgeInsets.all(SizeConfig.safeBlockVertical * 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            faqs.title,
            style: TextStyle(
              fontSize: SizeConfig.safeBlockVertical * 5.4,
              fontWeight: FontWeight.bold,
              color: global.palette6,
            ),
          ),
          Text(
            faqs.description,
            style: TextStyle(
              fontSize: SizeConfig.safeBlockVertical * 3.6,
            ),
          ),
          faqs.image == 'assets/faqs/empty_image.webp' ?
            const SizedBox()
            : Padding(
              padding: EdgeInsets.only(
                top: SizeConfig.safeBlockVertical * 6,
                bottom: SizeConfig.safeBlockVertical * 3,
              ),
              child: Card(
                  elevation: 8,
                  child: Image.asset(
                    faqs.image,
                    scale: 1.8,
                  )),
            ),
          Padding(
            padding: EdgeInsets.only(
              top: SizeConfig.safeBlockVertical * 4,
              bottom: SizeConfig.safeBlockVertical * 12,
            ),
            child: const Divider(),
          ),
        ],
      ),
    );
}
