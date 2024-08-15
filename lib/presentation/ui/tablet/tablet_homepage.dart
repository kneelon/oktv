import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:oktv/main.dart';
import 'package:oktv/presentation/ui/tablet/tablet_faqs_page.dart';
import 'package:oktv/presentation/utility/check_internet_connectivity.dart';
import 'package:oktv/presentation/utility/constants.dart' as constants;
import 'package:oktv/presentation/utility/display_admob.dart';
import 'package:oktv/presentation/utility/global.dart' as global;
import 'package:flutter/material.dart';
import 'package:oktv/presentation/utility/size_config.dart';
import 'package:oktv/presentation/utility/custom_text_style.dart';
import 'package:oktv/presentation/utility/toast_widget.dart';
import 'package:oktv/presentation/widgets/global/custom_floating_action_button.dart';
import 'package:oktv/presentation/widgets/tablet/tablet_alert_dialog/tablet_alert_dialog.dart';
import 'package:oktv/presentation/widgets/tablet/tablet_alert_dialog/tablet_confirm_delete_dialog.dart';
import 'package:oktv/presentation/widgets/tablet/tablet_alert_dialog/tablet_right_aligned_dialog.dart';
import 'package:oktv/presentation/widgets/tablet/tablet_alert_dialog/tablet_show_ok_dialog.dart';
import 'package:oktv/presentation/widgets/tablet/tablet_custom_button.dart';
import 'package:oktv/services/custom_voice_to_text.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:convert';
import 'package:flutter_vibrate/flutter_vibrate.dart';


class TabletHomepage extends StatefulWidget {
  final String availableUrl;
  const TabletHomepage({super.key, required this.availableUrl});

  @override
  State<TabletHomepage> createState() => _TabletHomepageState();
}

class _TabletHomepageState extends State<TabletHomepage> {

  late final WebViewController _webViewController;
  late final WebViewController _playerWebViewController;
  final ToggleProvider _toggleProvider = ToggleProvider();
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _favSearchController = TextEditingController();
  late SharedPreferences _sharedPreferences;
  late CustomVoiceToText _voiceToText;
  final RefreshController _refreshController = RefreshController(initialRefresh: false);

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
  List<String> _favUrlList = [];
  List<String> _favTitleList = [];
  List<String> _titleList = [];
  List<String> _urlList = [];
  List<String> _filteredTitleList = [];
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

  void _initializeWebViewPlayer(String url) {
    _playerWebViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'YouTubeAdChannel',
        onMessageReceived: (JavaScriptMessage message) {
          if (message.message == 'ad_playing') {
            debugPrint('>>> YOUTUBE AD is currently playing');
          }
        },
      )
      ..loadRequest(Uri.parse(url))
      ..runJavaScript('''
        var tag = document.createElement('script');
        tag.src = 'https://www.youtube.com/iframe_api';
        var firstScriptTag = document.getElementsByTagName('script')[0];
        firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);

        var player;
        function onYouTubeIframeAPIReady() {
          player = new YT.Player('player', {
            events: {
              'onReady': onPlayerReady,
              'onStateChange': onPlayerStateChange
            }
          });
        }

        function onPlayerReady(event) {
          event.target.setVolume(100); // Set volume to 100%
        }

        function onPlayerStateChange(event) {
          if (event.data === 2) { 
            YouTubeAdChannel.postMessage('ad_playing');
          }
        }

        function simulateClick() {
          var playerElement = document.getElementById('player');
          if (playerElement) {
            playerElement.click(); // Simulate a click on the YouTube player
          }
        }
    ''');
  }

  void _skipVideo() {
    setState(() {
      _titleList.removeAt(0);
      _urlList.removeAt(0);
      _currentPlayingUrl = _urlList[0];
      _sharedPreferences.setStringList(constants.titleList, _titleList);
      _sharedPreferences.setStringList(constants.urlList, _urlList);
      _playerWebViewController.loadRequest(Uri.parse(_urlList[0]));
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
    _checkInternetConnection();
  }

  void _initializeWebView() {
    _webViewController = WebViewController()
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
      ..loadRequest(Uri.parse('https://www.youtube.com/results?search_query=$_textResult'));
    _checkInternetConnection();
  }

  void _displayAddDialog(String url, String title) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return TabletRightAlignedDialog(
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

  bool _isBannerAdAvailableToDisplay() {
    ///This will validate if 1. Non fullscreen. 2. Inactive TextField. 3. Keyboard is hidden
    if (!_toggleProvider.isFullWidth && !_isTextFieldActive && !_isKeyboardShow) {
      return true;
    }
    return false;
  }

  void _checkVibration() async {
    bool canVibrate = await Vibrate.canVibrate;
    setState(() {
      _canVibrate = canVibrate;
    });
  }

  void _vibrate() {
    if (_canVibrate) {
      Vibrate.feedback(FeedbackType.light);
    }
  }

  void _validatePlayingDefaultUrl(String playingUrl) {
    setState(() {
      if (playingUrl.contains(constants.cTime)) {
        _isPlayingDefaultUrl = true;
      } else {
        _isPlayingDefaultUrl = false;
      }
    });
  }

  void _onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    setState(() {
      if (_urlList.isNotEmpty) {
        _playerWebViewController.loadRequest(Uri.parse(_urlList[0]));
      } else {
        _playerWebViewController.loadRequest(Uri.parse(widget.availableUrl));
      }
    });
    _refreshController.refreshCompleted();
  }

  void _checkInternetConnection() async {
    await isInternetConnected(context);
  }

  @override
  void initState() {
    super.initState();
    _checkInternetConnection();
    _initializeSharedPreference();
    _initializeWebViewPlayer(widget.availableUrl);
    _initializeWebView();
    _validatePlayingDefaultUrl(_currentPlayingUrl);
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
        _isFavoriteShow = false;
        _isBrowser = true;
        showToastWidget('Searching for ${_textResult.toUpperCase()}', global.successColor);
        _updateWebView();
      }
    });
  }

  void _updateWebView() {
    final url = 'https://www.youtube.com/results?search_query=${Uri.encodeComponent(_textResult)}';
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
  }



  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    if (!_isInitialPositionSet) {
      final screenWidth = MediaQuery.of(context).size.width;
      final screenHeight = MediaQuery.of(context).size.height;
      xPosition = screenWidth - 117;
      yPosition = screenHeight - 117;
      // xPosition = screenWidth - 20;
      // yPosition = screenHeight - 20;
      _isInitialPositionSet = true;
    }


    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        body: Consumer<ToggleProvider>(
          builder: (context, toggleProvider, child) {
            return LayoutBuilder(
              builder: (context, constraints) {
                return Stack(
                  children: <Widget>[
                    _buildPanelAPlayer(toggleProvider.isFullWidth),
                    toggleProvider.isFullWidth ? const SizedBox() : _buildPanelABottom(toggleProvider.isFullWidth),
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
        bottom: SizeConfig.safeBlockVertical * 14,
        left: 16,
        child: _urlList.length > 1 ?
        GestureDetector(
          onTap: () {
            _skipVideo();
          },
          child: Image.asset(
            constants.imgSkipButton,
            scale: 4,
          ),
        ) : const SizedBox(),
      );

  Widget _buildPanelAPlayer(bool isFullWidth) =>
      Positioned(
        bottom: isFullWidth ? null : SizeConfig.safeBlockVertical * 30,
        right: isFullWidth ? null :  SizeConfig.safeBlockHorizontal * 30,
        child: Container(
          width: SizeConfig.safeBlockHorizontal * (isFullWidth ? 100 : 70),
          height: SizeConfig.safeBlockVertical * (isFullWidth ? 100 : 70),
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

  Widget _buildPanelABottom(bool isFullWidth) =>
      Positioned(
        bottom: 0,
        left: 0,
        child: _isKeyboardShow ? _buildCustomKeyboard(context) :
        Container(
          width: SizeConfig.safeBlockHorizontal * 70,
          height: SizeConfig.safeBlockVertical * 34,
          ///Must be same color with Panel B
          color: global.palette2,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(width: SizeConfig.safeBlockHorizontal * 4),
              //_buildSkipButtonIfDefaultUrl(isFullWidth),
              Padding(
                padding: EdgeInsets.only(right: SizeConfig.safeBlockHorizontal * 2),
                child: SizedBox(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: <Widget>[
                          InkWell(
                            onTap: _voiceToText.isListening ? _stopListening : _startListening,
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: SizeConfig.safeBlockVertical * 1,
                                  bottom: SizeConfig.safeBlockVertical * 1.6
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    border: Border.all(
                                      width: SizeConfig.safeBlockVertical * .6,
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
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  border: Border.all(
                                    width: SizeConfig.safeBlockVertical * .6,
                                    color: global.blackBrown,
                                  )
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(SizeConfig.safeBlockVertical * 1),
                                child: Icon(
                                  Icons.keyboard_alt_outlined,
                                  size: SizeConfig.safeBlockVertical * 4,
                                  semanticLabel: 'Keyboard',
                                  color: global.blackBrown,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      PopupMenuButton(
                        icon: Icon(
                          Icons.settings_outlined,
                          size: SizeConfig.safeBlockVertical * 5,
                          color: global.blackBrown,
                          semanticLabel: 'Settings',
                        ),
                        itemBuilder: (context) {
                          return [
                            _buildPopupMenuItem(constants.faqs),
                            _buildPopupMenuItem(constants.wordContactUs),
                          ];
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  PopupMenuItem _buildPopupMenuItem(String title) =>
      PopupMenuItem(
        padding: EdgeInsets.symmetric(
            vertical: SizeConfig.safeBlockVertical * 1
        ),
        onTap: (){
          _settingsOnClickListener(title);
        },
        child: Text(title, style: textStyle2(context),),
      );


  Widget _buildPanelB() =>
      Positioned(
        bottom: 0,
        right: 0,
        child: _isFavoriteShow ?
        _buildFavoriteListView()
            : Container(
          width: SizeConfig.safeBlockHorizontal * 30,
          height: SizeConfig.safeBlockVertical * 100,
          color: global.palette2,
          child: Column(
            children: <Widget>[
              _buildTopLayer(),
              _buildQueueDisplay(),
              _isBrowser ? _initializedBrowser() : _buildListViewBuilder(),
              //_initializedBrowser()
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
          width: SizeConfig.safeBlockHorizontal * 30,
          height: SizeConfig.safeBlockVertical * 8,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                width: SizeConfig.safeBlockVertical * .2,
                color: Colors.black54,
              )
          ),
          child: TextFormField(
            controller: _searchController,
            style: textBold2(context),
            cursorColor: Colors.black45,
            decoration: InputDecoration(
                hintText: 'Type here',
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(
                  top: SizeConfig.safeBlockVertical * 1.2,
                  left: SizeConfig.safeBlockVertical * 1,
                )
            ),
            onTap: null,
            enabled: false,
            maxLines: 2,
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
              tabletCustomButton(context, _isFavoriteShow ? 'Browse' : 'Favorites', () {
                _initializeSharedPreference();
                setState(() {
                  _isFavoriteShow = !_isFavoriteShow;
                });
              }) :
              InkWell(
                onTap: () {
                  //Navigator.push(context, MaterialPageRoute(builder: (context) => SplashScreenPage(availableUrl: _currentPlayingUrl)));
                },
                child: Text(
                  _titleList.isNotEmpty ? '${_titleList.length - 1} Queue' : 'No Items',
                  style: textStyle2(context),
                ),
              ),
              tabletCustomButton(
                context,
                _isBrowser ? 'View List' : 'Browse',
                    () {
                  setState(() {
                    _isBrowser = !_isBrowser;
                    _isTextFieldShow = false;
                    _isKeyboardShow = false;
                  });
                },
              ),
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
        padding: EdgeInsets.all(SizeConfig.safeBlockVertical * 3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Empty items here, click Add button below!',
              style: textStyle1(context),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: SizeConfig.safeBlockVertical * 2),
            tabletCustomButton(
              context,
              constants.capAdd,
                  () => tabletDialogDisplaySearchInfo(context),
            ),
            // ElevatedButton(
            //   onPressed: () => tabletDialogDisplaySearchInfo(context),
            //   child: const Text(constants.capAdd),
            // ),
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
        height: SizeConfig.safeBlockVertical * 9,
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
                    width: SizeConfig.safeBlockVertical * 5,
                    height: SizeConfig.safeBlockVertical * 5,
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
                      width: SizeConfig.safeBlockVertical * 5,
                      height: SizeConfig.safeBlockVertical * 5,
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
                          size: SizeConfig.safeBlockVertical * 4,
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
                      style: textColored0(context, global.palette6, FontWeight.bold),
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: SizeConfig.safeBlockHorizontal * 15,
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
                          'Now Playing...',
                          style: textStyle1(context),
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
                            color: global.palette4,
                            width: 2,
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
                                size: SizeConfig.safeBlockVertical * 4,
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
        width: SizeConfig.safeBlockHorizontal * 32,
        child: WebViewWidget(controller: _webViewController),
      );

  //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>FAVORITE LIST>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

  Widget _buildFavoriteListView() =>
      Container(
          width: SizeConfig.safeBlockHorizontal * 30,
          height: SizeConfig.safeBlockVertical * 100,
          color: global.palette2,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: SizeConfig.safeBlockVertical * 2,
                ),
                child: SizedBox(
                  width: SizeConfig.safeBlockHorizontal * 28,
                  height: SizeConfig.safeBlockVertical * 10,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Container(
                        height: SizeConfig.safeBlockVertical * 8,
                        width: SizeConfig.safeBlockHorizontal * 22,
                        decoration: BoxDecoration(
                            color: global.palette1,
                            borderRadius: BorderRadius.circular(SizeConfig.safeBlockVertical * 2),
                            border: Border.all(
                              width: SizeConfig.safeBlockVertical * .2,
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
                                  bottom: SizeConfig.safeBlockVertical * 1
                              ),
                              hintText: 'Search Favorites',
                              hintStyle: textStyle2(context),
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
                      InkWell(
                        onTap: () {
                          setState(() {
                            _isBrowser = true;
                            _isFavoriteShow = false;
                          });
                        },
                        child: Icon(
                          Icons.subdirectory_arrow_right_sharp,
                          color: global.blackBrown,
                          size: SizeConfig.safeBlockVertical * 5,
                          semanticLabel: 'Go Back',
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
                        return TabletRightAlignedDialog(
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
                  width: SizeConfig.safeBlockHorizontal * 22,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: textColored0(context, global.palette1, FontWeight.normal),
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
                    return TabletConfirmDeleteDialog(
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

  void _settingsOnClickListener(String title) {
    switch (title) {
      case constants.faqs:
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const TabletFaqsPage()));
        break;
      case constants.wordContactUs:
        tabletDialogContactDeveloper(context, constants.wordContactDev, constants.devContactUs);
        break;
    }
  }

  bool _isItemAlreadyInTheList(String title) {
    debugPrint('>>> CHECK $title');
    for (int i = 0; i < _titleList.length; i++) {
      String checkTitle = _titleList[i];
      if (checkTitle == title) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return TabletShowOkDialog(
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
        width: SizeConfig.safeBlockHorizontal * 70,
        height: SizeConfig.safeBlockVertical * 34,
        color: Colors.grey,
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: SizeConfig.safeBlockHorizontal * .5,
            horizontal: SizeConfig.safeBlockHorizontal * 2,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _buildNumberLayer(context),
              _buildFirstLayer(context),
              _buildSecondLayer(context),
              _buildThirdLayer(context),
              _buildFourthLayer(context),
            ],
          ),
        ),
      );

  Widget _buildNumberLayer(context) =>
      Padding(
        padding: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 1),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildButtons(context, '0', _is0Clicked),
            _buildButtons(context, '1', _is1Clicked),
            _buildButtons(context, '2', _is2Clicked),
            _buildButtons(context, '3', _is3Clicked),
            _buildButtons(context, '4', _is4Clicked),
            _buildButtons(context, '5', _is5Clicked),
            _buildButtons(context, '6', _is6Clicked),
            _buildButtons(context, '7', _is7Clicked),
            _buildButtons(context, '8', _is8Clicked),
            _buildButtons(context, '9', _is9Clicked),
            _buildBackspace(context),
            SizedBox(width: SizeConfig.safeBlockHorizontal * 2.4),
          ],
        ),
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
            SizedBox(width: SizeConfig.safeBlockHorizontal * 2),
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
            SizedBox(width: SizeConfig.safeBlockHorizontal * 3),
          ],
        ),
      );

  Widget _buildThirdLayer(context) =>
      Padding(
        padding: EdgeInsets.only(top: SizeConfig.safeBlockVertical * .8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildButtons(context, 'Z', _isZClicked),
            _buildButtons(context, 'X', _isXClicked),
            _buildButtons(context, 'C', _isCClicked),
            _buildButtons(context, 'V', _isVClicked),
            _buildButtons(context, 'B', _isBClicked),
            _buildButtons(context, 'N', _isNClicked),
            _buildButtons(context, 'M', _isMClicked),
            _buildEnter(context),
            SizedBox(width: SizeConfig.safeBlockHorizontal * 3),
          ],
        ),
      );

  Widget _buildFourthLayer(context) =>
      Padding(
        padding: EdgeInsets.only(top: SizeConfig.safeBlockVertical * .8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildVibrationSettings(),
            _buildSpaceBar(context),
            _buildHideKeyboard(context),
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
                border: Border.all(
                  width: SizeConfig.safeBlockVertical * .4,
                )
            ),
            child: Padding(
              padding: EdgeInsets.all(SizeConfig.safeBlockHorizontal * .5),
              child: Icon(
                Icons.vibration_outlined,
                size: SizeConfig.safeBlockHorizontal * 3,
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
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(SizeConfig.safeBlockVertical * 1),
                color: _isBackSpaceClicked ? global.palette1 : global.errorColor,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.safeBlockHorizontal * 2.4,
                    vertical: SizeConfig.safeBlockVertical * .5
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Delete',
                      style: TextStyle(
                          fontSize: SizeConfig.safeBlockVertical * 2.0,
                          color: _isBackSpaceClicked ? global.blackBrown : global.palette1),
                    ),
                    Image.asset(
                      'assets/arrow.webp',
                      width: SizeConfig.safeBlockVertical * 6,
                      height: SizeConfig.safeBlockVertical * 1,
                      color: _isBackSpaceClicked ? global.blackBrown : global.palette1,
                    ),
                  ],
                ),
              )
          ),
        ),
      );

  Widget _buildEnter(context) =>
      Padding(
        padding: EdgeInsets.only(
          right: SizeConfig.safeBlockVertical * 1,
        ),
        child: InkWell(
          onTap: () {
            if (_textResult.isNotEmpty) {
              setState(() {
                _isFavoriteShow = false;
                _isBrowser = true;
                _updateWebView();
                _isTextFieldActive = false;
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
              borderRadius: BorderRadius.circular(SizeConfig.safeBlockVertical * 1),
              color: _isSearchClicked ? global.palette1 : global.successColor,
            ),
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    vertical: SizeConfig.safeBlockVertical * .6,
                    horizontal: SizeConfig.safeBlockHorizontal * 2
                ),
                child: Text(
                  'SEARCH',
                  style: textColored1(
                    context,
                    _isSearchClicked ? global.palette3 : global.palette1,
                    FontWeight.normal,
                  ),
                ),
              ),
            ),
          ),
        ),
      );

  Widget _buildSpaceBar(context) =>
      InkWell(
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
          width: SizeConfig.safeBlockVertical * 66,
          height: SizeConfig.safeBlockVertical * 5,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(SizeConfig.safeBlockVertical * .5),
            color: _isSpaceClicked ? global.palette1 : Colors.grey[800],
          ),
          child: Center(
            child: Text(
              'SPACE',
              style: textColored1(
                context,
                _isSpaceClicked ? global.blackBrown : global.palette1,
                FontWeight.bold,
              ),
            ),
          ),
        ),
      );


  Widget _buildHideKeyboard(context) =>
      InkWell(
        onTap: () {
          setState(() {
            _isKeyboardShow = !_isKeyboardShow;
            //_isBrowser = true;
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
                  color: Colors.black54,
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
                  size: SizeConfig.safeBlockVertical * 4,
                  semanticLabel: 'Keyboard',
                ),
                Icon(
                  Icons.keyboard_hide_outlined,
                  color: global.palette1,
                  size: SizeConfig.safeBlockVertical * 4,
                  semanticLabel: 'Keyboard',
                ),
              ],
            ),
          ),
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
            width: SizeConfig.safeBlockVertical * 6.6,
            height: SizeConfig.safeBlockVertical * 5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(SizeConfig.safeBlockVertical * 1),
              color: isClicked ? global.palette1 : Colors.grey[800],
            ),
            child: Center(
              child: Text(
                text,
                style: textColored1(
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
    _isTextFieldActive = true;
    setState(() {
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
