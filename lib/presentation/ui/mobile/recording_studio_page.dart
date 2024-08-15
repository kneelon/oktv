import 'package:flutter/services.dart';
import 'package:oktv/presentation/ui/mobile/mobile_homepage.dart';
import 'package:oktv/presentation/utility/carousel.dart';
import 'package:oktv/presentation/utility/constants.dart' as constants;
import 'package:oktv/presentation/utility/custom_text_style.dart';
import 'package:oktv/presentation/utility/get_random_item.dart';
import 'package:oktv/presentation/utility/global.dart' as global;
import 'package:flutter/material.dart';
import 'package:oktv/presentation/utility/permission_provider.dart';
import 'package:oktv/presentation/utility/recorder_provider.dart';
import 'package:oktv/presentation/utility/size_config.dart';
import 'package:oktv/presentation/utility/toast_widget.dart';
import 'package:oktv/presentation/widgets/global/custom_camera_page.dart';
import 'package:oktv/presentation/widgets/mobile/mobile_alert_dialog/recording_dialog/mobile_right_aligned_recording_dialog.dart';
import 'package:oktv/services/custom_voice_to_text.dart';
import 'package:vibration/vibration.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:convert';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class RecordingStudioPage extends StatefulWidget {
  final String url;
  const RecordingStudioPage({super.key, required this.url});

  @override
  State<RecordingStudioPage> createState() => _RecordingStudioPageState();
}

class _RecordingStudioPageState extends State<RecordingStudioPage> {

  late YoutubePlayerController _playerController;
  late final WebViewController _webViewController;
  final PermissionProvider _permissionProvider = PermissionProvider();
  final RecorderProvider _recorderProvider = RecorderProvider();
  final TextEditingController _searchController = TextEditingController();
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
  bool _isEnterSearchClicked = false;


  bool _isBrowser = false;
  bool _isKeyboardShow = false;
  bool _isClicked = false;
  bool _canVibrate = false;
  bool _isAnimatedGifShow = false;
  bool _isVibrateEnabled = true;
  bool _isCameraOn = false;
  String _gifAssetOne = constants.empty;
  String _gifAssetTwo = constants.empty;
  String _recordingUrl = constants.empty;
  String _recordingTitle = constants.empty;
  String _textResult = constants.empty;
  late double xPosition;
  late double yPosition;
  bool _isInitialPositionSet = false;



  void _injectJavaScript() { //ORIG
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

      // Remove YouTube embedded iframes
      function removeYouTubeIframes() {
        var iframes = document.getElementsByTagName('iframe');
        for (var i = iframes.length - 1; i >= 0; i--) {
          if (iframes[i].src.includes('youtube.com/embed/')) {
            iframes[i].parentNode.removeChild(iframes[i]);
          }
        }
      }

      // Initial actions
      muteMediaElements();
      removeYouTubeIframes();

      // Continuously monitor for new media elements or iframes
      setInterval(() => {
        muteMediaElements();
        removeYouTubeIframes();
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


  void _initializeWebView() { //ORIG
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'Toaster',
        onMessageReceived: (JavaScriptMessage message) {
          Map<String, dynamic> data = jsonDecode(message.message);
          debugPrint('>>> DATA $data');
          String url = data[constants.url];
          String replace = data[constants.title];
          String title = replace.replaceAll('- YouTube', constants.empty);
          String description = title;

          if (!_isClicked) {
            setState(() {
              _isClicked = true;
            });

            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return MobileRightAlignedRecordingDialog(
                  title: 'Record this karaoke song with front camera?',
                  description: description,
                  onCancelClicked: () {
                    setState(() {
                      _isBrowser = false;
                      _isClicked = false;
                      _isKeyboardShow = false;
                      _recordingTitle = title;
                      _recordingUrl = url;

                      _isCameraOn = false;
                      _playerController.load(YoutubePlayer.convertUrlToId(_recordingUrl)!);
                      Future.delayed(const Duration(seconds: 2));
                      _recorderProvider.startRecording(context);
                    });
                  },
                  onConfirmClicked: () {
                    if (url.isNotEmpty) {
                      setState(() {
                        _isBrowser = false;
                        _isClicked = false;
                        _isKeyboardShow = false;
                        _recordingTitle = title;
                        _recordingUrl = url;

                        _isCameraOn = true;
                        _playerController.load(YoutubePlayer.convertUrlToId(_recordingUrl)!);
                        Future.delayed(const Duration(seconds: 2));
                        _recorderProvider.startRecording(context);
                      });
                    }
                  },
                );
              },
            );
          }
        },
      )
      ..setNavigationDelegate(NavigationDelegate(
          onPageFinished: (String url) {
            _injectJavaScript();
          }
      ))
      ..loadRequest(Uri.parse('https://www.youtube.com/results?search_query=karaoke+$_textResult'));
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
      Vibration.vibrate(duration: 50);
    }
  }

  @override
  void initState() {
    super.initState();
    if (_recordingUrl.isEmpty) {
      _recordingUrl = constants.recordingTutorialUrl;
    }
    _playerController = YoutubePlayerController(
        initialVideoId: YoutubePlayer.convertUrlToId(_recordingUrl)!,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          loop: false,
          mute: false,
          showLiveFullscreenButton: false,
        )
    );

    _playerController.addListener(_videoListener);
    _initializeWebView();
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
      _textResult = _voiceToText.speechResult;
      if (_textResult.isNotEmpty) {
        _isBrowser = true;
        showToastWidget('Searching for ${_textResult.toUpperCase()}', global.successColor);
        _updateWebView();
      }
    });
  }

  void _startListening() {
    _voiceToText.startListening();
  }

  void _stopListening() {
    _voiceToText.stop();
  }

  void _updateWebView() {
    if (_recorderProvider.isRecording) {
      _recorderProvider.stopRecording(context);
      _playerController.pause();
    }
    _gifAssetOne = getRandomGifImage();
    _gifAssetTwo = getRandomGifImage();
    final url = 'https://www.youtube.com/results?search_query=karaoke+${Uri.encodeComponent(_textResult)}';
    _webViewController.loadRequest(Uri.parse(url)).whenComplete(() {
      _textResult = constants.empty;
      _searchController.clear();
    });
  }

  void _videoListener() {
    if (_playerController.value.playerState == PlayerState.ended) {
      debugPrint('>>> SONG IS DONE');
    }
    if (_playerController.value.playerState == PlayerState.playing) {
      setState(() {
        //TODO soon
      });
    } else {
      setState(() {
        //TODO soon
      });
    }
  }




  @override
  void dispose() {
    super.dispose();
    _playerController.removeListener(_videoListener);
    _playerController.dispose();
    _searchController.dispose();
    _recorderProvider.stop();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    if (!_isInitialPositionSet) {
      final screenWidth = MediaQuery.of(context).size.width;
      final screenHeight = MediaQuery.of(context).size.height;
      xPosition = screenWidth - 70;
      yPosition = screenHeight - 70;
      _isInitialPositionSet = true;
    }

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _buildPanelA(),
            _buildPanelB(),
          ],
        ),
      ),
    );
  }

  Widget _buildPanelA() =>
      SizedBox(
        width: SizeConfig.safeBlockHorizontal * 70,
        height: SizeConfig.safeBlockVertical * 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildYoutubePlayer(),
            _changeBottomPanelAToKeyboard(),
          ],
        ),
      );

  Widget _buildYoutubePlayer() =>
      SizedBox(
        width: _isKeyboardShow && !_isBrowser ? SizeConfig.safeBlockHorizontal * 63 : SizeConfig.safeBlockHorizontal * 70,
        height: _isKeyboardShow && !_isBrowser ? SizeConfig.safeBlockVertical * 63 : SizeConfig.safeBlockVertical * 70,
        child: YoutubePlayerBuilder(
          player: YoutubePlayer(
            controller: _playerController,
            showVideoProgressIndicator: true,
            bottomActions: [
              InkWell(
                  onTap: () {
                    _playerController.load(YoutubePlayer.convertUrlToId(_recordingUrl)!);
                    Future.delayed(const Duration(seconds: 2));
                    _recorderProvider.startRecording(context);
                  },
                  child: const Icon(Icons.refresh, color: global.palette1))
            ],
            onEnded: (YoutubeMetaData metaData) async {
              setState(() {
                _recorderProvider.stopRecording(context);
                _isCameraOn = false;
                _isKeyboardShow = false;
              });
            },
          ),
          builder: (context, player) {
            return player;
          },
        ),
      );

  Widget _changeBottomPanelAToKeyboard() =>
      _isKeyboardShow && !_isBrowser ? _buildCustomKeyboard(context) : _buildBottomPanelA();

  Widget _buildBottomPanelA() =>
      Container(
        height: SizeConfig.safeBlockVertical * 25,
        color: global.palette2,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _changeToRecordButtonIfRecording(),
            _changeCarouselToTitle(),
            _buildMicAndKeyboardIcon(),
          ],
        ),
      );

  Widget _changeToRecordButtonIfRecording() => Center(
    child: _recorderProvider.isRecording
        ? _buildRecordingIcon()
        : _buildHomeAndFilesIcon(),
  );

  Widget _buildRecordingIcon() => Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Text(
        constants.capStop,
        style: textStyle1(context),
      ),
      const SizedBox(height: 2),
      GestureDetector(
        onTap: () {
          setState(() {
            _recorderProvider.stopRecording(context);
            _recorderProvider.stop();
            _isCameraOn = false;
            _playerController.pause();
          });
        },
        child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Image.asset(
              scale: 12,
              constants.gifRecord,
            )),
      ),
    ],
  );

  Widget _buildHomeAndFilesIcon() => GestureDetector(
    onTap: () {
      _playerController.pause();
      Future.delayed(const Duration(seconds: 1));
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => MobileHomepage(availableUrl: widget.url)));
    },
    child: Icon(
      Icons.home_outlined,
      size: SizeConfig.safeBlockVertical * 8,
      semanticLabel: constants.capHome,
    ),
  );

  Widget _changeCarouselToTitle() => SizedBox(
    width: SizeConfig.safeBlockHorizontal * 48,
    child: _recordingTitle.isEmpty
        ? Carousel()
        : Text(
      _recordingTitle,
      style: textColored4(context, global.palette6, FontWeight.bold),
      textAlign: TextAlign.center,
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    ),
  );

  Widget _buildMicAndKeyboardIcon() => Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      InkWell(
        onTap: () async {
          if (await _permissionProvider.requestPermissions(context)) {
            if (_recorderProvider.isRecording) {
              showToastWidget(constants.wordStopRecordingForNewSong,
                  global.errorColor);
            } else {
              _voiceToText.isListening
                  ? _stopListening()
                  : _startListening();
            }
          }
        },
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    width: SizeConfig.safeBlockVertical * .4,
                    color: _voiceToText.isListening
                        ? global.successColor
                        : global.palette3,
                  )),
              child: Icon(
                _voiceToText.isListening ? Icons.mic : Icons.mic_none,
                color: _voiceToText.isListening
                    ? global.successColor
                    : global.palette3,
                size: SizeConfig.safeBlockVertical * 6,
                semanticLabel: constants.wordVoiceSearch,
              ),
            ),
            Text(constants.wordVoiceSearch, style: textStyle0(context)),
          ],
        ),
      ),
      SizedBox(height: SizeConfig.safeBlockVertical * 2),
      InkWell(
        onTap: () async {
          if (await _permissionProvider.requestPermissions(context)) {
            if (_recorderProvider.isRecording) {
              showToastWidget(constants.wordStopRecordingForNewSong,
                  global.errorColor);
            } else {
              setState(() {
                _isKeyboardShow = !_isKeyboardShow;
                _isBrowser = false;
              });
            }
          }
        },
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    width: SizeConfig.safeBlockVertical * .4,
                    color: global.blackBrown,
                  )),
              child: Padding(
                padding: EdgeInsets.all(SizeConfig.safeBlockVertical * 1),
                child: Icon(
                  Icons.keyboard_alt_outlined,
                  size: SizeConfig.safeBlockVertical * 4,
                  color: global.blackBrown,
                  semanticLabel: constants.capKeyboard,
                ),
              ),
            ),
            Text(constants.capKeyboard, style: textStyle0(context)),
          ],
        ),
      ),
    ],
  );

  Widget _buildPanelB() =>
      Container(
        width: SizeConfig.safeBlockHorizontal * 30,
        height: SizeConfig.safeBlockVertical * 100,
        color: global.palette1,
        child: _isCameraOn && _recorderProvider.isRecording
            ? _buildCameraAndAnimatedGif()
            : _changeTextToBrowser(),
      );

  Widget _buildCameraAndAnimatedGif() =>
      Stack(
        children: <Widget>[
          const CustomCameraPage(),
          Positioned(
            left: 1,
            right: 1,
            bottom: 10,
            child: Column(
              children: [
                Text(constants.wordTapCameraToRotate, style: textStyle0(context),),
                _isKeyboardShow
                    ? const SizedBox()
                    : GestureDetector(
                  onTap: () {
                    setState(() {
                      _isAnimatedGifShow = !_isAnimatedGifShow;
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          _gifAssetOne,
                          width: SizeConfig.safeBlockVertical * 16,
                          height: SizeConfig.safeBlockVertical * 16,
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          _gifAssetTwo,
                          width: SizeConfig.safeBlockVertical * 16,
                          height: SizeConfig.safeBlockVertical * 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      );

  Widget _changeTextToBrowser() =>
      Column(
        children: [
          _buildSearchTextFormField(),
          _isBrowser ? _initializedBrowser() : _buildTextRecordInformation(),
        ],
      );

  Widget _buildTextRecordInformation() =>
      _isKeyboardShow ? const SizedBox() :
      SizedBox(
        width: SizeConfig.safeBlockHorizontal * 30,
        height: SizeConfig.safeBlockVertical * 90,
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(SizeConfig.safeBlockVertical * 3),
            child: Text(
              constants.wordYouCanRecordHere,
              style: textStyle2(context),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );

  Widget _buildSearchTextFormField() =>
      _isKeyboardShow ?
      Padding(
        padding: EdgeInsets.all(SizeConfig.safeBlockVertical * 1),
        child: Container(
          width: SizeConfig.safeBlockHorizontal * 30,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                width: SizeConfig.safeBlockVertical * .2,
                color: Colors.black54,
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
              cursorColor: Colors.black45,
              decoration: InputDecoration(
                  hintText: constants.capSearch,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(
                    bottom: SizeConfig.safeBlockVertical * 4,
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

  Widget _initializedBrowser() =>
      SizedBox(
        height: _isKeyboardShow ? SizeConfig.safeBlockVertical * 70 : SizeConfig.safeBlockVertical * 90,
        width: SizeConfig.safeBlockHorizontal * 30,
        child: WebViewWidget(controller: _webViewController),
      );


  //-------------------------------------CUSTOM KEYBOARD BELOW------------------------------------------------------------

  Widget _buildCustomKeyboard(context) =>
      Container(
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(SizeConfig.safeBlockVertical * 2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildLetters(context),
            _buildNumbers(context),
          ],
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
            showToastWidget(constants.wordVibrateOn, global.successColor);
          } else {
            showToastWidget(constants.wordVibrateOff, global.palette4);
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
                semanticLabel: constants.capVibrate,
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
            _keyboardStateListener(constants.capBackspace);
            if (_isVibrateEnabled) {
              _vibrate();
            }
          },

          onTap: () {
            if (_textResult.isNotEmpty) {
              _keyboardOnClickEvent(constants.capBackspace);
            }
          },
          child: Container(
              width: SizeConfig.safeBlockVertical * 16,
              height: SizeConfig.safeBlockVertical * 7,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(SizeConfig.safeBlockVertical * .5),
                color: _isBackSpaceClicked ? global.palette1 : global.keyboardPad,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    constants.capBackspace,
                    style: TextStyle(
                      fontSize: SizeConfig.safeBlockVertical * 2.4,
                      color: _isBackSpaceClicked ? global.palette3 : global.palette1,
                    ),
                  ),
                  SizedBox(height: SizeConfig.safeBlockVertical * .4),
                  Image.asset(
                    constants.imgBackspaceArrow,
                    width: SizeConfig.safeBlockVertical * 8,
                    color: _isBackSpaceClicked ? global.palette3 : global.palette1,
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
          onTapUp: (status) {
            setState(() {
              _clearAllKeyboardState();
            });
          },
          onTap: () {
            if (_textResult.isNotEmpty) {
              _keyboardOnClickEvent(constants.capsSearch);
              setState(() {
                _isBrowser = !_isBrowser;
                Future.delayed(const Duration(seconds: 1), () {
                  _updateWebView();
                });
              });
            } else {
              showToastWidget(constants.wordEnterText, global.palette4);
            }
          },
          onTapDown: (status) {
            _keyboardStateListener(constants.capsSearch);
            if (_isVibrateEnabled) {
              _vibrate();
            }
          },
          child: Container(
            width: SizeConfig.safeBlockVertical * 16,
            height: SizeConfig.safeBlockVertical * 7,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(SizeConfig.safeBlockVertical * .5),
              color: _isEnterSearchClicked ? global.palette1 : global.successColor,
            ),
            child: Center(
              child: Text(
                constants.capsSearch,
                style: textColored2(
                  context,
                  _isEnterSearchClicked ? global.palette3 : global.palette1,
                  FontWeight.bold,
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
            _keyboardStateListener(constants.capsSpace);
            if (_isVibrateEnabled) {
              _vibrate();
            }
          },
          onTap: () {
            if (_textResult.isNotEmpty) {
              _keyboardOnClickEvent(constants.capsSpace);
            }
          },
          child: Container(
            width: SizeConfig.safeBlockVertical * 70,
            height: SizeConfig.safeBlockVertical * 7,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(SizeConfig.safeBlockVertical * .5),
              color: _isSpaceClicked ? global.palette1 : global.keyboardPad,
            ),
            child: Center(
              child: Text(
                constants.capsSpace,
                style: textColored2(
                  context,
                  _isSpaceClicked ? global.palette3 : global.palette1,
                  FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      );

  Widget _buildNumbers(context) =>
      Column(
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
                width: SizeConfig.safeBlockVertical * 12,
                height: SizeConfig.safeBlockVertical * 7,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(SizeConfig.safeBlockVertical * .5),
                  color: _is0Clicked ? global.palette1 : global.keyboardPad,
                ),
                child: Center(
                  child: Text(
                      '0',
                      style: textColored2(
                        context,
                        _is0Clicked ? global.palette3 : global.palette1,
                        FontWeight.bold,
                      )),
                ),
              ),
            ),
            SizedBox(width: SizeConfig.safeBlockVertical * 2),
            InkWell(
              onTap: () {
                setState(() {
                  _isKeyboardShow = !_isKeyboardShow;
                  _isBrowser = false;
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
                      horizontal: SizeConfig.safeBlockVertical * 1
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.keyboard_hide_outlined,
                        color: global.palette1,
                        size: SizeConfig.safeBlockVertical * 6,
                        semanticLabel: constants.capKeyboard,
                      ),
                      Icon(
                        Icons.keyboard_hide_outlined,
                        color: global.palette1,
                        size: SizeConfig.safeBlockVertical * 6,
                        semanticLabel: constants.capKeyboard,
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
            height: SizeConfig.safeBlockVertical * 8,
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
      if (_textResult.isNotEmpty) {
        if (text == constants.capsSpace) {
          _textResult += constants.emptySpace;
        }
        if (text == constants.capBackspace) {
          _textResult = _textResult.substring(0, _textResult.length -1);
        }
        if (text != constants.capBackspace && text != constants.capsSpace) {
          _textResult += text.toLowerCase();
        }
      }
      else {
        _textResult += text;
      }
      String result = _textResult.replaceAll(constants.search, constants.empty);
      _searchController.text = result;
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
    _isEnterSearchClicked = false;
  }

  void _clearTextField() {
    if (!_isKeyboardShow) {
      setState(() {
        _searchController.clear();
        _textResult = constants.empty;
      });
    }
  }

  void _keyboardStateListener(String text) {
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
        case constants.capsSpace:
          _isSpaceClicked = true;
          break;
        case constants.capBackspace:
          _isBackSpaceClicked = true;
          break;
        case constants.capsSearch:
          _isEnterSearchClicked = true;
          break;
      }
    });
  }

}
