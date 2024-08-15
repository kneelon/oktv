import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:oktv/presentation/ui/mobile/mobile_get_started_page.dart';
import 'package:oktv/presentation/ui/tablet/tablet_get_started_page.dart';
import 'package:oktv/presentation/utility/constants.dart' as constants;
import 'package:oktv/presentation/utility/get_random_item.dart';
import 'package:oktv/presentation/utility/size_config.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  runApp(
    ChangeNotifierProvider(
      create: (_) => ToggleProvider(),
      child: const MyApp(),
    ),
  );

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
}

class ToggleProvider with ChangeNotifier {
  bool _isFullWidth = false;

  bool get isFullWidth => _isFullWidth;

  void toggle() {
    _isFullWidth = !_isFullWidth;
    notifyListeners();
  }
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OKTV',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreenPage(),
      //home: const MyTestPage(),
    );
  }
}


class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({super.key});

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {

  late SharedPreferences _sharedPreferences;
  String availableUrl = constants.empty;
  List<String> urlList = [];

  Future<void> _getAvailableUrl() async {

    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getStringList(constants.urlList) != null) {
      urlList = sharedPreferences.getStringList(constants.urlList)!;
      availableUrl = urlList[0];
    } else {
      availableUrl = getDefaultUrl();
    }
  }

  void _initializeSharedPreference(bool isTablet) async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _sharedPreferences.setBool(constants.isTablet, isTablet);
  }

  @override
  void initState() {
    super.initState();
    _getAvailableUrl();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double screenWidth = SizeConfig.safeBlockHorizontal * 100;
    double screenHeight = SizeConfig.safeBlockVertical * 100;
    late Widget getStartedPage;

    if (screenWidth > 900 && screenWidth < 4000) {
      _initializeSharedPreference(true);
      getStartedPage = TabletGetStartedPage(url: availableUrl);
    } else {
      _initializeSharedPreference(false);
      getStartedPage = MobileGetStartedPage(url: availableUrl);
    }
    return getStartedPage;
  }
}

