import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:oktv/main.dart';
import 'package:oktv/presentation/ui/mobile/mobile_faqs_page.dart';
import 'package:oktv/presentation/ui/mobile/recording_studio_page.dart';
import 'package:oktv/presentation/utility/check_internet_connectivity.dart';
import 'package:oktv/presentation/utility/constants.dart' as constants;
import 'package:oktv/presentation/utility/display_admob.dart';
import 'package:oktv/presentation/utility/global.dart' as global;
import 'package:flutter/material.dart';
import 'package:oktv/presentation/utility/size_config.dart';
import 'package:oktv/presentation/widgets/mobile/mobile_alert_dialog/mobile_confirm_delete_dialog.dart';
import 'package:oktv/presentation/widgets/mobile/mobile_alert_dialog/mobile_alert_dialog.dart';
import 'package:oktv/presentation/widgets/mobile/mobile_alert_dialog/mobile_right_aligned_dialog.dart';
import 'package:oktv/presentation/widgets/mobile/mobile_alert_dialog/mobile_show_ok_dialog.dart';
import 'package:oktv/presentation/widgets/mobile/mobile_custom_button.dart';
import 'package:oktv/presentation/widgets/global/custom_floating_action_button.dart';
import 'package:oktv/presentation/utility/custom_text_style.dart';
import 'package:oktv/presentation/utility/toast_widget.dart';
import 'package:oktv/services/custom_voice_to_text.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:convert';
//import 'package:flutter_vibrate/flutter_vibrate.dart';


class MobileHomepage extends StatefulWidget {
  final String availableUrl;
  const MobileHomepage({super.key, required this.availableUrl});

  @override
  State<MobileHomepage> createState() => _MobileHomepageState();
}

class _MobileHomepageState extends State<MobileHomepage> {

  late BannerAd _bannerAd;
  final WebViewController _webViewController = WebViewController();
  WebViewController _playerWebViewController = WebViewController();
  final ToggleProvider _toggleProvider = ToggleProvider();
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _favSearchController = TextEditingController();
  late SharedPreferences _sharedPreferences;
  late CustomVoiceToText _voiceToText;

  bool _isAClicked = false;
  bool _isBClicked = false;
  bool _isCClicked = false;
  bool _isDClicked = false;
  bool _isEClicked = false;
  bool _isFClicked = false;
  bool _isGClicked = false;
  bool _isHClicked = false;
  bool _isIClicked = false;
  bool _isJClicked = false;
  bool _isKClicked = false;
  bool _isLClicked = false;
  bool _isMClicked = false;
  bool _isNClicked = false;
  bool _isOClicked = false;
  bool _isPClicked = false;
  bool _isQClicked = false;
  bool _isRClicked = false;
  bool _isSClicked = false;
  bool _isTClicked = false;
  bool _isUClicked = false;
  bool _isVClicked = false;
  bool _isWClicked = false;
  bool _isXClicked = false;
  bool _isYClicked = false;
  bool _isZClicked = false;
  bool _is0Clicked = false;
  bool _is1Clicked = false;
  bool _is2Clicked = false;
  bool _is3Clicked = false;
  bool _is4Clicked = false;
  bool _is5Clicked = false;
  bool _is6Clicked = false;
  bool _is7Clicked = false;
  bool _is8Clicked = false;
  bool _is9Clicked = false;
  bool _isSpaceClicked = false;
  bool _isBackSpaceClicked = false;
  bool _isSearchClicked = false;
  bool _isTextFieldShow = false;
  bool _isBrowser = false;
  bool _isKeyboardShow = false;
  bool _isFavoriteShow = false;
  bool _isTextFieldActive = false;
  bool _isClicked = false;
  bool _canVibrate = false;
  bool _isVibrateEnabled = true;
  bool _isPlayingDefaultUrl = false;
  bool _isKaraokeSearch = true;
  bool _isBrowseButtonShow = false;
  //int _urlListCounter = 0;
  List<String> _favUrlList = [];
  List<String> _favTitleList = [];
  List<String> _titleList = [];
  List<String> _urlList = [];
  List<String> _filteredTitleList = [];
  String _karaokeSearch = constants.specKaraoke;
  String _currentPlayingUrl = constants.empty;
  String _textResult = constants.empty;
  late double xPosition;
  late double yPosition;
  bool _isInitialPositionSet = false;


  void _initializeSharedPreference() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    if (_sharedPreferences.getStringList(constants.titleList) != null) {
      _titleList = _sharedPreferences.getStringList(constants.titleList)!;
    }
    if (_sharedPreferences.getStringList(constants.urlList) != null) {
      _urlList = _sharedPreferences.getStringList(constants.urlList)!;
      _getCleanedUrlList(_urlList, 'urlList');
    }
    if (_sharedPreferences.getStringList(constants.favTitleList) != null) {
      _favTitleList = _sharedPreferences.getStringList(constants.favTitleList)!;
      _filteredTitleList = _favTitleList;
      //_favSearchController.addListener(_filterTitles); //TODO SQFLite
    }
    if (_sharedPreferences.getStringList(constants.favUrlList) != null) {
      _favUrlList = _sharedPreferences.getStringList(constants.favUrlList)!;
      _getCleanedUrlList(_favUrlList, 'favUrlList');
    }
  }


  void _getCleanedUrlList(List<String> urls, String name) {
    List<String> cleanedUrlList = urls.map((url) {
      return url.split('&pp=')[0];
    }).toList();
    setState(() {
      if (name == 'urlList') {
        _urlList = cleanedUrlList;
        _currentPlayingUrl = _urlList[0];
      } else {
        _favUrlList = cleanedUrlList;
      }
    });
  }

  void _injectWebViewPlayer() { //This is perfect
    _playerWebViewController.runJavaScript('''
      (function() {
        function sendMessage(url, title) {
          if (window.Toaster && typeof window.Toaster.postMessage === 'function') {
            window.Toaster.postMessage(JSON.stringify({url: url, title: title}));
          }
        }

        // Monitor URL changes and send messages when the URL changes
        var lastUrl = location.href;
        new MutationObserver((mutations) => {
          var url = location.href;
          if (url !== lastUrl) {
            lastUrl = url;
            if (url.includes('/watch')) {
              var title = document.title;
              sendMessage(url, title);
            }
          }
        }).observe(document, {subtree: true, childList: true});

        // Unmute and autoplay the video
        var player;
        function unmuteAndPlay() {
          player = document.querySelector('video');
          if (player) {
            player.muted = false;
            player.play();
          }
        }

        // Wait until the YouTube player is ready
        var checkPlayerInterval = setInterval(function() {
          var playerReady = document.querySelector('video');
          if (playerReady) {
            clearInterval(checkPlayerInterval);
            unmuteAndPlay();
          }
        }, 500);

      })();
    ''');
  }

  void _initializeWebViewPlayer(String url) {
    _playerWebViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'Toaster',
        onMessageReceived: (JavaScriptMessage message) {
          Map<String, dynamic> data = jsonDecode(message.message);
          String url = data[constants.url];

          String replace = data[constants.title];
          String title = replace.replaceAll('- YouTube', constants.empty);

          if (!_isClicked) {
            setState(() {
              _isClicked = true;
            });
            if (!_isItemAlreadyInTheList(title)) {
              _displayAddDialogForPlayer(url, title);
            }
          }
        },
      )
      ..setNavigationDelegate(NavigationDelegate(
          onPageFinished: (String url) {
            _injectWebViewPlayer();
          }
      ))
      ..loadRequest(Uri.parse(url));
  }

  void _skipVideo() {
    int counter = _urlList.length;
    setState(() {
      if (_isPlayingDefaultUrl) {
        _isPlayingDefaultUrl = false;
        _currentPlayingUrl = _urlList[0];
        _playerWebViewController.loadRequest(Uri.parse(_urlList[0]));
      } else {
        if (counter > 1) {
          _titleList.removeAt(0);
          _urlList.removeAt(0);
          _currentPlayingUrl = _urlList[0];
          _sharedPreferences.setStringList(constants.titleList, _titleList);
          _sharedPreferences.setStringList(constants.urlList, _urlList);
          _playerWebViewController.loadRequest(Uri.parse(_urlList[0]));
        }
      }
    });
  }

  // void _unMuteVideo() {
  //   //TODO Don't delete this
  //   showToastWidget('Clicked inside', global.successColor);
  //   _playerWebViewController.runJavaScript('simulateClick()');
  // }


  void _injectJavaScript() {
    _webViewController.runJavaScript('''
      (function() {
        function sendMessage(url, title) {
          if (window.Toaster && typeof window.Toaster.postMessage === 'function') {
            window.Toaster.postMessage(JSON.stringify({url: url, title: title}));
          }
        }
  
        // Mute all video and audio elements
        function muteMediaElements() {
          var videos = document.getElementsByTagName('video');
          var audios = document.getElementsByTagName('audio');
          for (var i = 0; i < videos.length; i++) {
            videos[i].muted = true;
          }
          for (var i = 0; i < audios.length; i++) {
            audios[i].muted = true;
          }
        }
  
        // Remove non-embedded YouTube videos
        function hideNonEmbeddedVideos() {
          var videoElements = document.querySelectorAll('ytd-video-renderer, ytd-playlist-renderer');
          for (var i = 0; i < videoElements.length; i++) {
            var videoLink = videoElements[i].querySelector('a#thumbnail');
            if (videoLink && !videoLink.href.includes('embed')) {
              videoElements[i].style.display = 'none';
            }
          }
        }
  
        // Initial actions
        muteMediaElements();
        hideNonEmbeddedVideos();
  
        // Continuously monitor for new media elements
        setInterval(() => {
          muteMediaElements();
          hideNonEmbeddedVideos();
        }, 1000);
  
        // Monitor URL changes and send messages when the URL changes
        var lastUrl = location.href;
        new MutationObserver((mutations) => {
          var url = location.href;
          if (url !== lastUrl) {
            lastUrl = url;
            if (url.includes('/watch')) {
              var title = document.title;
              sendMessage(url, title);
            }
          }
        }).observe(document, {subtree: true, childList: true});
      })();
    ''');
  }

  void _initializeWebView() {
    _webViewController// = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'Toaster',
        onMessageReceived: (JavaScriptMessage message) {
          Map<String, dynamic> data = jsonDecode(message.message);
          String url = data[constants.url];

          String replace = data[constants.title];
          String title = replace.replaceAll('- YouTube', constants.empty);
          debugPrint('>>> CLICK ITEM URL $url');

          if (!_isClicked) {
            setState(() {
              _isClicked = true;
            });
            if (!_isItemAlreadyInTheList(title)) {
              _displayAddDialog(url, title);
            }
          }
        },
      )
      ..setNavigationDelegate(NavigationDelegate(
          onPageFinished: (String url) {
            _injectJavaScript();
          }
      ))
      ..loadRequest(Uri.parse('https://www.youtube.com/results?search_query=${constants.specKaraoke}$_textResult'));
  }

  void _displayAddDialog(String url, String title) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return MobileRightAlignedDialog(
          title: title,
          addFavorite: constants.capAddAndSave,
          addItem: constants.capAdd,
          onAddItemClicked: () {
            setState(() {
              _isTextFieldShow = false;
              _titleList.add(title);
              _urlList.add(url);
              _sharedPreferences.setStringList(constants.titleList, _titleList);
              _sharedPreferences.setStringList(constants.urlList, _urlList);
              _isClicked = false;
              _isBrowser = false;
            });
          },
          onFavoriteClicked: () {
            setState(() {
              _isTextFieldShow = false;
              _titleList.add(title);
              _urlList.add(url);
              _sharedPreferences.setStringList(constants.titleList, _titleList);
              _sharedPreferences.setStringList(constants.urlList, _urlList);
              _isBrowser = false;
              _isClicked = false;
              if (!_isItemAlreadyInTheFavList(url)) {
                _favTitleList.add(title);
                _favUrlList.add(url);
                _sharedPreferences.setStringList(constants.favTitleList, _favTitleList);
                _sharedPreferences.setStringList(constants.favUrlList, _favUrlList);
              }
            });
          },
          onClosed: () {
            setState(() {
              _isClicked = false;
            });
          },
        );
      },
    );
  }

  void _displayAddDialogForPlayer(String url, String title) {
    ///This dialog will load and play the next item in the list instantly.
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return MobileRightAlignedDialog(
          title: title,
          addFavorite: constants.capAddAndSave,
          addItem: constants.capAdd,
          onAddItemClicked: () {
            setState(() {
              _isTextFieldShow = false;
              _titleList.add(title);
              _urlList.add(url);
              _sharedPreferences.setStringList(constants.titleList, _titleList);
              _sharedPreferences.setStringList(constants.urlList, _urlList);
              _isClicked = false;
              _isBrowser = false;
              _skipVideo();
            });
          },
          onFavoriteClicked: () {
            setState(() {
              _isTextFieldShow = false;
              _titleList.add(title);
              _urlList.add(url);
              _sharedPreferences.setStringList(constants.titleList, _titleList);
              _sharedPreferences.setStringList(constants.urlList, _urlList);
              _isBrowser = false;
              _isClicked = false;
              if (!_isItemAlreadyInTheFavList(url)) {
                _favTitleList.add(title);
                _favUrlList.add(url);
                _sharedPreferences.setStringList(constants.favTitleList, _favTitleList);
                _sharedPreferences.setStringList(constants.favUrlList, _favUrlList);
                _skipVideo();
              }
            });
          },
          onClosed: () {
            setState(() {
              _isClicked = false;
            });
          },
        );
      },
    );
  }

  bool _isBannerAdAvailableToDisplay() {
    ///This will validate if
    ///1. Non fullscreen. 2. Inactive TextField.
    ///3. Keyboard is hidden. 4. Is not playing default URL
    int counter = _urlList.length;
    if (!_toggleProvider.isFullWidth && !_isTextFieldActive && !_isKeyboardShow && !_isPlayingDefaultUrl) {
      return true;
    }
    return false;
  }

  void _checkVibration() async {
    bool? canVibrate = await Vibration.hasVibrator();
    debugPrint('>>> Can vibrate $canVibrate');
    setState(() {
      _canVibrate = canVibrate!;
    });
  }

  void _vibrate() {
    if (_canVibrate) {
      debugPrint('>>> Vibrating...');
      Vibration.vibrate(duration: 50);
    } else {
      debugPrint('>>> Cannot vibrate');
    }
  }

  void _validatePlayingDefaultUrl() {
    if (_currentPlayingUrl.contains(constants.cTime)) {
      setState(() {
        _isPlayingDefaultUrl = true;
      });
    }
    debugPrint('>>> IS CURRENT PLAYING $_isPlayingDefaultUrl');
  }

  void _checkInternetConnection() async {
    //await isInternetConnected(context);
    if (await isInternetConnected(context)) {
      _initializeWebView();
    }
  }

  void _countUrlListItems() async {
    int counter = _urlList.length;
    if (counter == 0) {
      setState(() {
        _currentPlayingUrl = widget.availableUrl;
        _initializeWebViewPlayer(widget.availableUrl);
      });
    } else {
      setState(() {
        _currentPlayingUrl = _urlList[0];
        _initializeWebViewPlayer(_urlList[0]);
      });
    }
    //if (_currentPlayingUrl.isNotEmpty) {
      //_initializeWebViewPlayer(_currentPlayingUrl);
    //}
  }

  @override
  void initState() {
    super.initState();
    _checkInternetConnection();
    _initializeSharedPreference();
    _countUrlListItems();
    //_initializeWebView();
    _validatePlayingDefaultUrl();
    _isBannerAdAvailableToDisplay();
    _clearTextField();
    _voiceToText = CustomVoiceToText(
      stopFor: 6,
    );
    _voiceToText.addListener(_onSpeechResult);
    _initializeSpeech();
    _checkVibration();
  }

  void _initializeSpeech() {
    _voiceToText.initSpeech();
    setState(() {});
  }

  void _onSpeechResult() {
    setState(() {
      _isTextFieldActive = false;
      _textResult = _voiceToText.speechResult;
      if (_textResult.isNotEmpty) {
        showToastWidget('Searching for ${_textResult.toUpperCase()}', global.successColor);
        _updateWebView();
      }
    });
  }

  void _updateWebView() {
    _isFavoriteShow = false;
    _isBrowseButtonShow = true;
    _isBrowser = true;
    final url = 'https://www.youtube.com/results?search_query=$_karaokeSearch${Uri.encodeComponent(_textResult)}';
    _webViewController.loadRequest(Uri.parse(url)).whenComplete(() {
      _textResult = constants.empty;
      _searchController.clear();
    });
  }

  void _startListening() {
    _voiceToText.startListening();
  }

  void _stopListening() {
    _voiceToText.stop();
  }

  // void _filterTitles() { //TODO SQFLite
  //   String query = _favSearchController.text.toLowerCase();
  //   setState(() {
  //     _filteredTitleList = _favTitleList
  //         .where((title) => title.toLowerCase().contains(query))
  //         .toList();
  //   });
  // }


  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
    //_favSearchController.removeListener(_filterTitles); //TODO SQFLite
    _favSearchController.dispose();
    _bannerAd.dispose();

  }


  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    if (!_isInitialPositionSet) {
      final screenWidth = MediaQuery.of(context).size.width;
      final screenHeight = MediaQuery.of(context).size.height;
      xPosition = screenWidth - 75;
      yPosition = screenHeight - 75;
      _isInitialPositionSet = true;
    }

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Consumer<ToggleProvider>(
          builder: (context, toggleProvider, child) {
            return LayoutBuilder(
              builder: (context, constraints) {
                return Stack(
                  children: <Widget>[
                    _buildPanelAPlayer(toggleProvider.isFullWidth),
                    toggleProvider.isFullWidth ? const SizedBox() : _buildPanelABottom(context),
                    _buildSkipButton(),
                    toggleProvider.isFullWidth  ? const SizedBox() : _buildPanelB(),
                    Positioned(
                      left: xPosition,
                      top: yPosition,
                      child: Draggable(
                        feedback: CustomFloatingActionButton(
                          onPress: () => toggleProvider.toggle(),
                        ),
                        childWhenDragging: Container(), // To show an empty container when dragging
                        child: CustomFloatingActionButton(
                          onPress: () => toggleProvider.toggle(),
                        ),
                        onDraggableCanceled: (Velocity velocity, Offset offset) {
                          setState(() {
                            xPosition = offset.dx;
                            yPosition = offset.dy;
                          });
                        },
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildSkipButton() =>
      Positioned(
        top: SizeConfig.safeBlockVertical * 45,
        left: 5,
        child: _urlList.isNotEmpty ?
        GestureDetector(
          onTap: () {
            _skipVideo();
          },
          child: Image.asset(
            constants.imgSkipButton,
            scale: 6,
          ),
        ) : const SizedBox(),
      );

  Widget _buildPanelAPlayer(bool isFullWidth) =>
      Positioned(
        bottom: isFullWidth ? null : SizeConfig.safeBlockVertical * 26,
        right: isFullWidth ? null :  SizeConfig.safeBlockHorizontal * 14,
        child: Container(
          width: SizeConfig.safeBlockHorizontal * (isFullWidth ? 100 : 88),
          height: SizeConfig.safeBlockVertical * (isFullWidth ? 100 : 88),
          color: global.palette2,
          child: WebViewWidget(
            controller: _playerWebViewController,
            //TODO Don't delete
            // gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
            //   Factory<OneSequenceGestureRecognizer>(
            //       () {
            //         showToastWidget('CLICKED AGAIN', global.successColor);
            //         return CustomGestureRecognizer(_unMuteVideo);
            //       },
            //   )
            // },
          ),
        ),
      );

  Widget _buildPanelABottom(context) =>
      Positioned(
        bottom: 0,
        left: 0,
        child: _isKeyboardShow ? _buildCustomKeyboard(context) :
        Container(
          width: SizeConfig.safeBlockHorizontal * 74,
          height: SizeConfig.safeBlockVertical * 22,
          color: global.palette2,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              PopupMenuButton(
                icon: Icon(
                  Icons.dehaze,
                  size: SizeConfig.safeBlockVertical * 6,
                  color: global.blackBrown,
                  semanticLabel: 'More',
                ),
                itemBuilder: (context) {
                  return [
                    _buildPopupMenuItem(context, 'Recording studio'),
                    _buildPopupMenuItem(context, constants.faqs),
                    _buildPopupMenuItem(context, 'How to add song'),
                    _buildPopupMenuItem(context, constants.wordContactUs),
                    //_buildPopupMenuItem(context, 'Restart App'),
                  ];
                },
              ),
              //_buildSkipButtonIfDefaultUrl(),
              _isBannerAdAvailableToDisplay() == true ? const DisplayAdmob() : _buildSkipButtonIfDefaultUrl(),
              Padding(
                padding: EdgeInsets.only(right: SizeConfig.safeBlockHorizontal * 1),
                child: SizedBox(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: _voiceToText.isListening ? _stopListening : _startListening,
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  border: Border.all(
                                    width: SizeConfig.safeBlockVertical * .4,
                                    color: _voiceToText.isListening ? global.successColor : global.blackBrown,
                                  )
                              ),
                              child: Icon(
                                _voiceToText.isListening ? Icons.mic : Icons.mic_none,
                                color: _voiceToText.isListening ? global.successColor : global.blackBrown,
                                size: SizeConfig.safeBlockVertical * 6,
                                semanticLabel: 'Search by Voice',
                              ),
                            ),
                            Text('Voice Search', style: textStyle0(context)),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          //dialogErrorDone(context, 'No internet', 'Oops, No internet connection,\nplease connect to the internet', (){});
                          setState(() {
                            _isKeyboardShow = !_isKeyboardShow;
                            _isTextFieldActive = true;
                            _isBrowser = false;
                          });
                        },
                        child: Padding(
                          padding: EdgeInsets.only(
                            bottom: SizeConfig.safeBlockVertical * 1,
                          ),
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    border: Border.all(
                                      width: SizeConfig.safeBlockVertical * .4,
                                      color: global.blackBrown,
                                    )
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(SizeConfig.safeBlockVertical * 1),
                                  child: Icon(
                                    Icons.keyboard_alt_outlined,
                                    size: SizeConfig.safeBlockVertical * 4,
                                    semanticLabel: 'Keyboard',
                                  ),
                                ),
                              ),
                              Text('Keyboard', style: textStyle0(context)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  PopupMenuItem _buildPopupMenuItem(context, String title) =>
      PopupMenuItem(
        onTap: (){
          _settingsOnClickListener(context, title);
        },
        child: Text(title, style: textStyle2(context),),
      );

  Widget _buildSkipButtonIfDefaultUrl() {
    int counter = _urlList.length;
    return _isPlayingDefaultUrl && counter > 0 ?
    Center(
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            _isPlayingDefaultUrl = false;
            _currentPlayingUrl = _urlList[0];
            _playerWebViewController.loadRequest(Uri.parse(_currentPlayingUrl));
          });
        }, child: const Text('Next / Skip'),
      ),
    ) : const SizedBox(); //<-- causing bug DisplayAdmob(isAbleToShowAd: _isBannerAdAvailableToDisplay());
  }

  Widget _buildPanelB() =>
      Positioned(
        bottom: 0,
        right: 0,
        child: _isFavoriteShow ?
        _buildFavoriteListView()
            : Container(
          width: SizeConfig.safeBlockHorizontal * 26,
          height: SizeConfig.safeBlockVertical * 108,
          color: global.palette2,
          child: Column(
            children: <Widget>[
              SizedBox(height: SizeConfig.safeBlockVertical * 7),
              _buildTopLayer(),
              _buildQueueDisplay(),
              _isBrowser ? _initializedBrowser() : _buildListViewBuilder(),
            ],
          ),
        ),
      );

  Widget _buildTopLayer() =>
      (!_isBrowser && _isKeyboardShow) || (!_isBrowser && _isTextFieldShow) ?
      Padding(
        padding: EdgeInsets.fromLTRB(
            SizeConfig.safeBlockVertical * 1,
            SizeConfig.safeBlockVertical * 2,
            SizeConfig.safeBlockVertical * 1,
            0
        ),
        child: Container(
          width: SizeConfig.safeBlockHorizontal * 29,
          height: SizeConfig.safeBlockVertical * 13,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                width: SizeConfig.safeBlockVertical * .2,
                color: global.blackBrown,
              )
          ),
          child: Padding(
            padding: EdgeInsets.only(
              top: SizeConfig.safeBlockVertical * 2,
              right: SizeConfig.safeBlockVertical * 1,
              left: SizeConfig.safeBlockVertical * 1,
            ),
            child: TextFormField(
              controller: _searchController,
              style: textBold3(context),
              cursorColor: global.blackBrown,
              decoration: InputDecoration(
                  hintText: 'Type here',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(
                    bottom: SizeConfig.safeBlockVertical * 5.4,
                    left: SizeConfig.safeBlockVertical * 1,
                  )
              ),
              onTap: null,
              enabled: false,
              maxLines: 2,
            ),
          ),
        ),
      ) : const SizedBox();

  Widget _buildQueueDisplay() =>
      _urlList.isNotEmpty ?
      Padding(
        padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.safeBlockHorizontal * .4
        ),
        child: SizedBox(
          width: SizeConfig.safeBlockHorizontal * 29,
          height: SizeConfig.safeBlockVertical * 10,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _isBrowser ?
              mobileCustomButton(context, _isFavoriteShow ? 'Browse' : 'Favorites', () {
                _initializeSharedPreference();
                setState(() {
                  _isFavoriteShow = !_isFavoriteShow;
                });
              }) :
              InkWell(
                onTap: () {
                  //Navigator.push(context, MaterialPageRoute(builder: (context) => SplashScreenPage(availableUrl: _currentPlayingUrl)));
                },
                child: Text(_titleList.isNotEmpty ? '${_titleList.length - 1} Queue' : 'No Items'),
              ),
              _isBrowseButtonShow
                ? mobileCustomButton(
                    context,
                    _isBrowser ? 'View List' : 'Browse',
                        () {
                      setState(() {
                        _isBrowser = !_isBrowser;
                        _isTextFieldShow = false;
                        _isKeyboardShow = false;
                      });
                    },
                  ) : const SizedBox(),
            ],
          ),
        ),
      )
          : const SizedBox();

  Widget _buildListViewBuilder() =>
      SizedBox(
        height: _isKeyboardShow || _isTextFieldShow ? SizeConfig.safeBlockVertical * 75 : SizeConfig.safeBlockVertical * 90,
        child: _urlList.isNotEmpty ? ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: _urlList.length,
          itemBuilder: (context, index) {
            return _validateAndDisplayItems(index);
          },
        ) : _buildPlaceHolder(),
      );

  Widget _buildPlaceHolder() {
    return SizedBox(
      height: SizeConfig.safeBlockVertical * 100,
      child: Padding(
        padding: EdgeInsets.all(SizeConfig.safeBlockVertical * 1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Add Karaoke song and start singing. Click the Add button below',
              style: textStyle2(context),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: SizeConfig.safeBlockVertical * 2),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _updateWebView();
                });
              },
              child: const Text(constants.capAdd),
            ),
          ],
        ),
      ),
    );
  }

  Widget _validateAndDisplayItems(int index) {
    int playIndex = index;
    String remove = _urlList[index];
    String url = remove.replaceAll(constants.replaceUrl, constants.empty);

    return Padding(
      padding: EdgeInsets.all(SizeConfig.safeBlockVertical * 1),
      child: Container(
        width: SizeConfig.safeBlockHorizontal * 20,
        height: SizeConfig.safeBlockVertical * 12,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(SizeConfig.safeBlockVertical * 2),
            border: Border.all()
        ),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.all(SizeConfig.safeBlockVertical * .8),
              child: InkWell(
                  onTap: () {
                  },
                  child: playIndex > 0 ? Container(
                    width: SizeConfig.safeBlockVertical * 6,
                    height: SizeConfig.safeBlockVertical * 6,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                          color: global.blackBrown,
                          width: 2,
                        )
                    ),
                    child: Center(
                      child: Text(
                        '$playIndex',
                        style: textDark1(context),
                      ),
                    ),
                  ) : Container(
                      width: SizeConfig.safeBlockVertical * 6,
                      height: SizeConfig.safeBlockVertical * 6,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                            color: global.blackBrown,
                            width: 2,
                          )
                      ),
                      child: Center(
                        child: Icon(
                          semanticLabel: 'Music',
                          Icons.music_note_outlined,
                          size: SizeConfig.safeBlockVertical * 5,
                        ),
                      )
                  )
              ),
            ),
            playIndex > 0 ?
            GestureDetector(
              onTap: () {
                showToastWidget("Queue number's are not clickable", global.errorColor);
              },
              child: SizedBox(
                width: SizeConfig.safeBlockHorizontal * 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      _titleList[playIndex],
                      style: textColored1(context, global.palette6, FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    Text(
                      'Video ID: $url',
                      style: textStyle1(context),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
            )
                : SizedBox(
              width: SizeConfig.safeBlockHorizontal * 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: SizeConfig.safeBlockHorizontal * 12,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _titleList[playIndex],
                          style: textColored1(context, global.palette6, FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        Text(
                          _isPlayingDefaultUrl ? 'Waiting...' : 'Now Playing...',
                          style: textStyle2(context),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                  _urlList.length > 1 ?
                  InkWell(
                    onTap: () => _skipVideo(),
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: SizeConfig.safeBlockVertical * 1
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: global.palette4
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.safeBlockVertical * 1,
                          ),
                          child: Row(
                            children: <Widget>[
                              Text('Next', style: textStyle1(context),),
                              Icon(
                                Icons.skip_next,
                                size: SizeConfig.safeBlockVertical * 5,
                                semanticLabel: 'Skip video',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ) : const SizedBox(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _initializedBrowser() =>
      SizedBox(
        height: _isKeyboardShow ? SizeConfig.safeBlockVertical * 77 : SizeConfig.safeBlockVertical * 85,
        width: SizeConfig.safeBlockHorizontal * 25,
        child: WebViewWidget(controller: _webViewController),
      );

  //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>FAVORITE LIST>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

  Widget _buildFavoriteListView() =>
      Container(
          width: SizeConfig.safeBlockHorizontal * 26,
          height: SizeConfig.safeBlockVertical * 107,
          color: global.palette2,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: SizeConfig.safeBlockVertical * 8,
                ),
                child: SizedBox(
                  width: SizeConfig.safeBlockHorizontal * 28,
                  height: SizeConfig.safeBlockVertical * 10,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Container(
                        height: SizeConfig.safeBlockVertical * 10,
                        width: SizeConfig.safeBlockHorizontal * 20,
                        decoration: BoxDecoration(
                            color: global.palette1,
                            borderRadius: BorderRadius.circular(SizeConfig.safeBlockVertical * 2),
                            border: Border.all(
                              width: SizeConfig.safeBlockVertical * .4,
                              color: global.textColorDark,
                            )
                        ),
                        child: TextFormField(
                          controller: _favSearchController,
                          onTap: () {
                            FocusScope.of(context).requestFocus(FocusNode());
                            setState(() {
                              _isKeyboardShow = !_isKeyboardShow;
                              _isBrowser = false;
                            });
                          },
                          maxLength: null,
                          maxLines: 1,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(
                                  left: SizeConfig.safeBlockVertical * 1,
                                  bottom: SizeConfig.safeBlockVertical * 3.4
                              ),
                              hintText: 'Search Favorites',
                              hintStyle: textStyle4(context),
                              border: InputBorder.none,
                              suffix: InkWell(
                                onTap: () {
                                  _favSearchController.clear();
                                  _searchController.clear();
                                  _textResult = constants.empty;
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    right: SizeConfig.safeBlockVertical * 1,
                                  ),
                                  child: Icon(
                                    Icons.highlight_remove,
                                    color: global.errorColor,
                                    size: SizeConfig.safeBlockVertical * 5,
                                    semanticLabel: 'Clear',
                                  ),
                                ),
                              )
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            right: SizeConfig.safeBlockVertical * 1
                        ),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _isBrowser = true;
                              _isFavoriteShow = false;
                            });
                          },
                          child: Icon(
                            Icons.subdirectory_arrow_right_sharp,
                            color: global.blackBrown,
                            size: SizeConfig.safeBlockVertical * 7,
                            semanticLabel: 'Go Back',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              _favUrlList.isNotEmpty ?
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.safeBlockVertical * 3),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${_favUrlList.length} Favorite(s)',
                      style: textColored1(context, global.palette3, FontWeight.normal),
                    ),
                    const SizedBox(),
                  ],
                ),
              ) : const SizedBox(),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  //itemCount: _filteredTitleList.length, //TODO SQFLite
                  itemCount: _favUrlList.length,
                  itemBuilder: (context, index) {
                    ///Don't use replaceAll() it will not match from _urlList
                    //_filteredTitleList.sort(); //TODO SQFLite
                    String url = _favUrlList[index];
                    return _displayFavItems(_filteredTitleList[index], url, index);
                  },
                ),
              ),
            ],
          )
      );

  Widget _displayFavItems(String title, String url, int index) {

    return Padding(
      padding: EdgeInsets.all(SizeConfig.safeBlockVertical * 1),
      child: Container(
        width: SizeConfig.safeBlockHorizontal * 20,
        height: SizeConfig.safeBlockVertical * 11,
        decoration: BoxDecoration(
            color: global.palette3,
            borderRadius: BorderRadius.circular(SizeConfig.safeBlockVertical * 2),
            border: Border.all(
              width: SizeConfig.safeBlockVertical * .1,
            )
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: SizeConfig.safeBlockHorizontal * 1),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              InkWell(
                onTap: () {
                  if (!_isItemAlreadyInTheList(title)) {
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) {
                        return MobileRightAlignedDialog(
                          title: title,
                          addFavorite: constants.capConfirm,
                          addItem: constants.capCancel,
                          onAddItemClicked: () {
                            setState(() {
                              _isClicked = false;
                            });
                          },
                          onFavoriteClicked: () {
                            setState(() {
                              _isClicked = false;
                              _titleList.add(title);
                              _urlList.add(url);
                              _sharedPreferences.setStringList(constants.titleList, _titleList);
                              _sharedPreferences.setStringList(constants.urlList, _urlList).whenComplete(() {
                                showToastWidget('Item added to List', global.successColor);
                              });
                            });
                          },
                          onClosed: () {
                            setState(() {
                              _isClicked = false;
                            });
                          },
                        );
                      },
                    );
                  }

                },
                child: SizedBox(
                  width: SizeConfig.safeBlockHorizontal * 18,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: textColored1(context, global.palette1, FontWeight.normal),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
              ),
              deleteButton(context, () {
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (BuildContext context) {
                    String itemName = _favTitleList[index];
                    return MobileConfirmDeleteDialog(
                      itemName: itemName,
                      onConfirmClicked: () {
                        setState(() {
                          _isClicked = false;
                          _favTitleList.removeAt(index);
                          _favUrlList.removeAt(index);
                          _sharedPreferences.setStringList(constants.favTitleList, _favTitleList);
                          _sharedPreferences.setStringList(constants.favUrlList, _favUrlList);
                        });
                      },
                    );
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _settingsOnClickListener(context, String title) async {
    switch (title) {
      case 'Recording studio':
        _playerWebViewController.reload().then((reload) {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => RecordingStudioPage(url: widget.availableUrl)));
        });
        break;
      case constants.faqs:
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const MobileFaqsPage()));
        break;
      case 'How to add song':
        return mobileDialogDisplaySearchInfo(context);
      case constants.wordContactUs:
        mobileDialogContactDeveloper(context, constants.wordContactDev, constants.devContactUs);
        break;
      //case 'Restart App':
        //Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SplashScreenPage()));
        //Phoenix.rebirth(context);
        //break;
    }
  }

  bool _isItemAlreadyInTheList(String title) {
    for (int i = 0; i < _titleList.length; i++) {
      String checkTitle = _titleList[i];
      if (checkTitle == title) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return MobileShowOkDialog(
              title: 'Item exists',
              description: 'This item is already added in the queue list',
              onTap: () {
                setState(() {
                  _isClicked = false;
                });
              },
            );
          },
        );
        return true;
      }
    }
    return false;
  }

  bool _isItemAlreadyInTheFavList(String url) {
    bool result = false;
    for (int i = 0; i < _favUrlList.length; i++) {
      String checkUrl = _favUrlList[i];
      if (checkUrl == url) {
        result = true;
      }
    }
    return result;
  }


  //-------------------------------------CUSTOM KEYBOARD BELOW------------------------------------------------------------

  Widget _buildCustomKeyboard(context) =>
      Container(
        width: SizeConfig.safeBlockHorizontal * 74,
        color: Colors.grey,
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: SizeConfig.safeBlockHorizontal * .3,
            horizontal: SizeConfig.safeBlockHorizontal * 2,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildLetters(context),
              //SizedBox(width: SizeConfig.safeBlockHorizontal * 2),
              _buildKaraokeCheckBox(),
              _buildNumbers(context),
            ],
          ),
        ),
      );

  Widget _buildLetters(context) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _buildFirstLayer(context),
          _buildSecondLayer(context),
          _buildThirdLayer(context),
          _buildFourthLayer(context),
        ],
      );

  Widget _buildFirstLayer(context) =>
      Padding(
        padding: EdgeInsets.only(top: SizeConfig.safeBlockVertical * .8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildButtons(context, 'Q', _isQClicked),
            _buildButtons(context, 'W', _isWClicked),
            _buildButtons(context, 'E', _isEClicked),
            _buildButtons(context, 'R', _isRClicked),
            _buildButtons(context, 'T', _isTClicked),
            _buildButtons(context, 'Y', _isYClicked),
            _buildButtons(context, 'U', _isUClicked),
            _buildButtons(context, 'I', _isIClicked),
            _buildButtons(context, 'O', _isOClicked),
            _buildButtons(context, 'P', _isPClicked),
          ],
        ),
      );

  Widget _buildSecondLayer(context) =>
      Padding(
        padding: EdgeInsets.only(top: SizeConfig.safeBlockVertical * .8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildButtons(context, 'A', _isAClicked),
            _buildButtons(context, 'S', _isSClicked),
            _buildButtons(context, 'D', _isDClicked),
            _buildButtons(context, 'F', _isFClicked),
            _buildButtons(context, 'G', _isGClicked),
            _buildButtons(context, 'H', _isHClicked),
            _buildButtons(context, 'J', _isJClicked),
            _buildButtons(context, 'K', _isKClicked),
            _buildButtons(context, 'L', _isLClicked),
          ],
        ),
      );

  Widget _buildThirdLayer(context) =>
      Padding(
        padding: EdgeInsets.only(top: SizeConfig.safeBlockVertical * .8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildButtons(context, 'Z', _isZClicked),
            _buildButtons(context, 'X', _isXClicked),
            _buildButtons(context, 'C', _isCClicked),
            _buildButtons(context, 'V', _isVClicked),
            _buildButtons(context, 'B', _isBClicked),
            _buildButtons(context, 'N', _isNClicked),
            _buildButtons(context, 'M', _isMClicked),
            _buildBackspace(context),
          ],
        ),
      );

  Widget _buildFourthLayer(context) =>
      Padding(
        padding: EdgeInsets.only(top: SizeConfig.safeBlockVertical * .8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildEnter(context),
            _buildSpaceBar(context),
            _buildVibrationSettings(),
          ],
        ),
      );

  Widget _buildVibrationSettings() =>
      GestureDetector(
        onTap: () {
          _isVibrateEnabled = !_isVibrateEnabled;
          if (_isVibrateEnabled) {
            showToastWidget('Vibrate On', global.successColor);
          } else {
            showToastWidget('Vibrate Off', global.errorColor);
          }
        },
        child: Padding(
          padding: EdgeInsets.only(
            left: SizeConfig.safeBlockHorizontal * .5,
            bottom: SizeConfig.safeBlockHorizontal * .5,
          ),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                border: Border.all()
            ),
            child: Padding(
              padding: EdgeInsets.all(SizeConfig.safeBlockHorizontal * .5),
              child: Icon(
                Icons.vibration_outlined,
                size: SizeConfig.safeBlockHorizontal * 2,
                semanticLabel: 'Vibration',
              ),
            ),
          ),
        ),
      );

  Widget _buildBackspace(context) =>
      Padding(
        padding: EdgeInsets.only(right: SizeConfig.safeBlockVertical * 1),
        child: GestureDetector(
          onLongPress: () {
            setState(() {
              _textResult = constants.empty;
              _searchController.clear();
            });
          },

          onTapUp: (status) {
            setState(() {
              _clearAllKeyboardState();
            });
          },

          onTapDown: (status) {
            _keyboardStateListener('Backspace');
            if (_isVibrateEnabled) {
              _vibrate();
            }
          },
          onTap: () {
            if (_textResult.isNotEmpty) {
              _keyboardOnClickEvent('Backspace');
            }
          },
          child: Container(
              width: SizeConfig.safeBlockVertical * 16,
              height: SizeConfig.safeBlockVertical * 6,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(SizeConfig.safeBlockVertical * .5),
                color: _isBackSpaceClicked ? global.palette1 : Colors.grey[800],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Backspace',
                    style: TextStyle(
                        fontSize: SizeConfig.safeBlockVertical * 2.0,
                        color: _isBackSpaceClicked ? global.blackBrown : global.palette1),
                  ),
                  SizedBox(height: SizeConfig.safeBlockVertical * .4),
                  Image.asset(
                    'assets/arrow.webp',
                    width: SizeConfig.safeBlockVertical * 7,
                    color: _isBackSpaceClicked ? global.blackBrown : global.palette1,
                  ),
                ],
              )
          ),
        ),
      );

  Widget _buildEnter(context) =>
      Padding(
        padding: EdgeInsets.only(
          right: SizeConfig.safeBlockVertical * 1,
          bottom: SizeConfig.safeBlockVertical * 1,
        ),
        child: InkWell(
          onTap: () {
            if (_textResult.isNotEmpty) {
              setState(() {
                _isTextFieldActive = false;
                _updateWebView();
              });
            } else {
              showToastWidget('You must enter a text', global.errorColor);
            }
          },
          onTapUp: (status) {
            setState(() {
              _clearAllKeyboardState();
            });
          },
          onTapDown: (status) {
            _keyboardStateListener('SEARCH');
            if (_isVibrateEnabled) {
              _vibrate();
            }
          },

          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(SizeConfig.safeBlockVertical * .5),
              color: _isSearchClicked ? global.palette1 : global.successColor,
            ),
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    vertical: SizeConfig.safeBlockVertical * 1,
                    horizontal: SizeConfig.safeBlockHorizontal * 2.4
                ),
                child: Text(
                  'SEARCH',
                  style: textColored1(
                    context,
                    _isSearchClicked ? global.palette3 : global.palette1,
                    FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      );

  Widget _buildSpaceBar(context) =>
      Padding(
        padding: EdgeInsets.only(
          right: SizeConfig.safeBlockVertical * 1,
          bottom: SizeConfig.safeBlockVertical * 1,
        ),
        child: InkWell(
          onTapUp: (status) {
            setState(() {
              _clearAllKeyboardState();
            });
          },
          onTapDown: (status) {
            _keyboardStateListener('SPACE');
            if (_isVibrateEnabled) {
              _vibrate();
            }
          },
          onTap: () {
            if (_textResult.isNotEmpty) {
              _keyboardOnClickEvent('SPACE');
            }
          },
          child: Container(
            width: SizeConfig.safeBlockVertical * 68,
            height: SizeConfig.safeBlockVertical * 6,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(SizeConfig.safeBlockVertical * .5),
              color: _isSpaceClicked ? global.palette1 : Colors.grey[800],
            ),
            child: Center(
              child: Text(
                'SPACE',
                style: textColored2(
                  context,
                  _isSpaceClicked ? global.blackBrown : global.palette1,
                  FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      );

  Widget _buildKaraokeCheckBox() =>
    Column(
      children: [
        Text(
          'Karaoke\nSearch',
          style: textStyle0(context),
          textAlign: TextAlign.center,
        ),
        Transform.scale(
          scale: 1,
          child: Padding(
            padding: const EdgeInsets.all(0),
            child: Checkbox(
              semanticLabel: 'Karaoke search',
              activeColor: global.keyboardPad,
              value: _isKaraokeSearch,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: const VisualDensity(horizontal: -4.0, vertical: -3.0),
              onChanged: (status) {
                setState(() {
                  _isKaraokeSearch = status!;
                  if (_isKaraokeSearch) {
                    _karaokeSearch = constants.specKaraoke;
                    showToastWidget('Karaoke search enabled', global.successColor);
                  } else {
                    _karaokeSearch = constants.empty;
                    showToastWidget('Karaoke search disabled', global.successColor);
                  }
                });
              },
            ),
          ),
        ),
      ],
    );

  Widget _buildNumbers(context) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _build1stLayer(context),
          _build2ndLayer(context),
          _build3rdLayer(context),
          _build4thLayer(context),
        ],
      );

  Widget _build1stLayer(context) =>
      Padding(
        padding: EdgeInsets.only(top: SizeConfig.safeBlockVertical * .8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildButtons(context, '7', _is7Clicked),
            _buildButtons(context, '8', _is8Clicked),
            _buildButtons(context, '9', _is9Clicked),
          ],
        ),
      );

  Widget _build2ndLayer(context) =>
      Padding(
        padding: EdgeInsets.only(top: SizeConfig.safeBlockVertical * .8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildButtons(context, '4', _is4Clicked),
            _buildButtons(context, '5', _is5Clicked),
            _buildButtons(context, '6', _is6Clicked),
          ],
        ),
      );

  Widget _build3rdLayer(context) =>
      Padding(
        padding: EdgeInsets.only(top: SizeConfig.safeBlockVertical * .8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildButtons(context, '1', _is1Clicked),
            _buildButtons(context, '2', _is2Clicked),
            _buildButtons(context, '3', _is3Clicked),
          ],
        ),
      );

  Widget _build4thLayer(context) =>
      Padding(
        padding: EdgeInsets.only(
          top: SizeConfig.safeBlockVertical * .8,
          bottom: SizeConfig.safeBlockVertical * 1,
        ),
        child: Row(
          children: [
            InkWell(
              onTapUp: (status) {
                setState(() {
                  _clearAllKeyboardState();
                });
              },
              onTapDown: (status) {
                _keyboardStateListener('0');
                if (_isVibrateEnabled) {
                  _vibrate();
                }
              },
              onTap: () {
                _keyboardOnClickEvent('0');
              },
              child: Container(
                width: SizeConfig.safeBlockVertical * 14.5,
                height: SizeConfig.safeBlockVertical * 6,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(SizeConfig.safeBlockVertical * .5),
                  color: _is0Clicked ? global.palette1 : Colors.grey[800],
                ),
                child: Center(
                  child: Text(
                      '0',
                      style: textColored2(
                        context,
                        _is0Clicked ? global.blackBrown : global.palette1,
                        FontWeight.bold,
                      )),
                ),
              ),
            ),
            SizedBox(width: SizeConfig.safeBlockVertical * 1),
            InkWell(
              onTap: () {
                setState(() {
                  _isKeyboardShow = false;
                  _isTextFieldActive = true;
                  _favSearchController.clear();
                  _searchController.clear();
                  _textResult = constants.empty;
                  _clearTextField();
                });
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(SizeConfig.safeBlockVertical * 1),
                    border: Border.all(
                        color: global.blackBrown,
                        width: SizeConfig.safeBlockVertical * .5
                    )
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.safeBlockVertical * 1.3
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.keyboard_hide_outlined,
                        color: global.palette1,
                        size: SizeConfig.safeBlockVertical * 5,
                        semanticLabel: 'Keyboard',
                      ),
                      Icon(
                        Icons.keyboard_hide_outlined,
                        color: global.palette1,
                        size: SizeConfig.safeBlockVertical * 5,
                        semanticLabel: 'Keyboard',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  Widget _buildButtons(context, String text, bool isClicked) =>
      InkWell(
        onTapUp: (status) {
          setState(() {
            _clearAllKeyboardState();
          });
        },
        onTapDown: (status) {
          _keyboardStateListener(text);
          if (_isVibrateEnabled) {
            _vibrate();
          }
        },
        onTap: () {
          _keyboardOnClickEvent(text);
        },
        child: Padding(
          padding: EdgeInsets.only(right: SizeConfig.safeBlockVertical * 1),
          child: Container(
            width: SizeConfig.safeBlockVertical * 9,
            height: SizeConfig.safeBlockVertical * 6,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(SizeConfig.safeBlockVertical * 1),
              color: isClicked ? global.palette1 : global.keyboardPad,
            ),
            child: Center(
              child: Text(
                text,
                style: textColored2(
                  context,
                  isClicked ? global.textColorDark : global.palette1,
                  FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      );

  void _keyboardOnClickEvent(String text) {
    setState(() {
      _isBrowser = false;
      if (_textResult.isNotEmpty) {
        if (text == 'SPACE') {
          _textResult += ' ';
        }
        if (text == 'Backspace') {
          _textResult = _textResult.substring(0, _textResult.length -1);
        }
        if (text != 'Backspace' && text != 'SPACE') {
          _textResult += text.toLowerCase();
        }
      } else {
        _textResult += text;
      }
      _searchController.text = _textResult;
      if (_isFavoriteShow) {
        _favSearchController.text = _textResult;
      }
    });
  }

  void _clearAllKeyboardState() {
    _isAClicked = false;
    _isBClicked = false;
    _isCClicked = false;
    _isDClicked = false;
    _isEClicked = false;
    _isFClicked = false;
    _isGClicked = false;
    _isHClicked = false;
    _isIClicked = false;
    _isJClicked = false;
    _isKClicked = false;
    _isLClicked = false;
    _isMClicked = false;
    _isNClicked = false;
    _isOClicked = false;
    _isPClicked = false;
    _isQClicked = false;
    _isRClicked = false;
    _isSClicked = false;
    _isTClicked = false;
    _isUClicked = false;
    _isVClicked = false;
    _isWClicked = false;
    _isXClicked = false;
    _isYClicked = false;
    _isZClicked = false;
    _is0Clicked = false;
    _is1Clicked = false;
    _is2Clicked = false;
    _is3Clicked = false;
    _is4Clicked = false;
    _is5Clicked = false;
    _is6Clicked = false;
    _is7Clicked = false;
    _is8Clicked = false;
    _is9Clicked = false;
    _is0Clicked = false;
    _isSpaceClicked = false;
    _isBackSpaceClicked = false;
    _isSearchClicked = false;
  }

  void _clearTextField() {
    if (!_isKeyboardShow) {
      setState(() {
        _favSearchController.clear();
        _searchController.clear();
        _textResult = constants.empty;
      });
    }
  }

  void _keyboardStateListener(String text) {
    setState(() {
      _isTextFieldActive = true;
      switch (text) {
        case 'A':
          _isAClicked = true;
          break;
        case 'B':
          _isBClicked = true;
          break;
        case 'C':
          _isCClicked = true;
          break;
        case 'D':
          _isDClicked = true;
          break;
        case 'E':
          _isEClicked = true;
          break;
        case 'F':
          _isFClicked = true;
          break;
        case 'G':
          _isGClicked = true;
          break;
        case 'H':
          _isHClicked = true;
          break;
        case 'I':
          _isIClicked = true;
          break;
        case 'J':
          _isJClicked = true;
          break;
        case 'K':
          _isKClicked = true;
          break;
        case 'L':
          _isLClicked = true;
          break;
        case 'M':
          _isMClicked = true;
          break;
        case 'N':
          _isNClicked = true;
          break;
        case 'O':
          _isOClicked = true;
          break;
        case 'P':
          _isPClicked = true;
          break;
        case 'Q':
          _isQClicked = true;
          break;
        case 'R':
          _isRClicked = true;
          break;
        case 'S':
          _isSClicked = true;
          break;
        case 'T':
          _isTClicked = true;
          break;
        case 'U':
          _isUClicked = true;
          break;
        case 'V':
          _isVClicked = true;
          break;
        case 'W':
          _isWClicked = true;
          break;
        case 'X':
          _isXClicked = true;
          break;
        case 'Y':
          _isYClicked = true;
          break;
        case 'Z':
          _isZClicked = true;
          break;
        case '0':
          _is0Clicked = true;
          break;
        case '1':
          _is1Clicked = true;
          break;
        case '2':
          _is2Clicked = true;
          break;
        case '3':
          _is3Clicked = true;
          break;
        case '4':
          _is4Clicked = true;
          break;
        case '5':
          _is5Clicked = true;
          break;
        case '6':
          _is6Clicked = true;
          break;
        case '7':
          _is7Clicked = true;
          break;
        case '8':
          _is8Clicked = true;
          break;
        case '9':
          _is9Clicked = true;
          break;
        case 'SPACE':
          _isSpaceClicked = true;
          break;
        case 'Backspace':
          _isBackSpaceClicked = true;
          break;
        case 'SEARCH':
          _isSearchClicked = true;
          break;

      }

    });
  }

}

class CustomGestureRecognizer extends OneSequenceGestureRecognizer {
  final VoidCallback onTap;

  CustomGestureRecognizer(this.onTap);

  @override
  void addAllowedPointer(PointerEvent event) {
    onTap();
    resolve(GestureDisposition.accepted);
  }

  @override
  void didStopTrackingLastPointer(int pointer) {}

  @override
  void handleEvent(PointerEvent event) {}

  @override
  String get debugDescription => 'CustomGestureRecognizer';
}
