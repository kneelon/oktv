import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oktv/presentation/utility/global.dart' as global;
import 'package:oktv/presentation/utility/size_config.dart';
import 'package:oktv/presentation/utility/toast_widget.dart';

class CustomCameraPage extends StatefulWidget {
  const CustomCameraPage({super.key});

  @override
  State<CustomCameraPage> createState() => _CustomCameraPageState();
}

class _CustomCameraPageState extends State<CustomCameraPage> {

  int _cameraHeight = 1;
  int _top = -40;
  int _right = -23;
  int _bottom = 40;
  double _cameraSize = 75;
  double _verticalPadding = 20;
  double _adjustAngle = 90 * 3.1415927 / 180;

  void changeCameraAspectRatio(int n) {
    switch (n) {
      case 1:
        _top = -40;
        _right = -23;
        _bottom = 40;
        _cameraSize = 75;
        _verticalPadding = 20;
        break;
      case 2:
        _top = -40;
        _right = -23;
        _bottom = 40;
        _cameraSize = 75;
        _verticalPadding = 20;
        break;
      case 3:
        _top = -40;
        _right = -23;
        _bottom = 40;
        _cameraSize = 75;
        _verticalPadding = 20;
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Positioned(
      top: -40,
      right: -22,
      bottom: 40,
      child: Container(
        width: SizeConfig.safeBlockVertical * 75, /// Don't delete This is the Camera height
        color: Colors.transparent,
        child: Transform.rotate(
          angle: _adjustAngle,
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: SizeConfig.safeBlockVertical * 20,
            ),
            child: SizedBox(
              child: CameraAwesomeBuilder.custom(
                sensorConfig: SensorConfig.single(
                  sensor: Sensor.position(SensorPosition.front),
                  aspectRatio: CameraAspectRatios.ratio_4_3,
                  zoom: 0.0,
                ),
                builder: (CameraState state, Preview preview) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        if (_adjustAngle == 90 * 3.1415927 / 180) {
                          _adjustAngle = -90 * 3.1415927 / 180;
                        } else {
                          _adjustAngle = 90 * 3.1415927 / 180;
                        }
                      });
                    },
                    child: const SizedBox(),
                  );
                },
                saveConfig: SaveConfig.video(),
              ),
            ),
          ),
        ),
      ),
    );




    // return Positioned(
    //   right: -23,
    //   top: -40,
    //   bottom: 40,
    //   child: Container(
    //     width: SizeConfig.safeBlockVertical * 75, /// Don't delete This is the Camera height
    //     color: Colors.transparent,
    //     child: Transform.rotate(
    //       angle: 90 * 3.1415927 / 180,
    //       child: Padding(
    //         padding: EdgeInsets.symmetric(
    //           vertical: SizeConfig.safeBlockVertical * 20,
    //         ),
    //         child: Stack(
    //           children: <Widget>[
    //             Positioned(
    //               child: CameraAwesomeBuilder.custom(
    //                 sensorConfig: SensorConfig.single(
    //                   sensor: Sensor.position(SensorPosition.front),
    //                   aspectRatio: CameraAspectRatios.ratio_4_3,
    //                   zoom: 0.0,
    //                 ),
    //                 builder: (CameraState state, Preview preview) {
    //                   return const SizedBox();
    //                 },
    //                 saveConfig: SaveConfig.video(),
    //               ),
    //             ),
    //             Positioned(
    //               bottom: 5,
    //               right: 5,
    //               child: InkWell(
    //                 onTap: () {
    //                   setState(() {
    //                     _cameraHeight++;
    //                     if (_cameraHeight > 3) {
    //                       _cameraHeight = 1;
    //                     }
    //                   });
    //                   showToastWidget('$_cameraHeight', global.successColor);
    //                 },
    //                 child: Icon(
    //                   Icons.fullscreen,
    //                   color: global.palette3,
    //                   size: SizeConfig.safeBlockVertical * 7,
    //                 ),
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }
}
