import 'dart:math';
import 'package:oktv/presentation/utility/constants.dart' as constants;

String getDefaultUrl() {
  final List<String> stockUrls = [
    // 'https://www.youtube.com/watch?v=OUKGsb8CpF8${constants.cTime}',
    // 'https://www.youtube.com/watch?v=mX3YkciKirA${constants.cTime}',
    // 'https://www.youtube.com/watch?v=KkCXLABwHP0${constants.cTime}',
    // 'https://www.youtube.com/watch?v=NCA88ckKqd4${constants.cTime}',
    // 'https://www.youtube.com/watch?v=iu3Wtf5Vwjk${constants.cTime}',
    // 'https://www.youtube.com/watch?v=QcIxodo9ER8${constants.cTime}',
    // 'https://www.youtube.com/watch?v=tFuw-YZaTNo${constants.cTime}',
    // 'https://www.youtube.com/watch?v=MEpXO5lFvj0${constants.cTime}',
    // 'https://www.youtube.com/watch?v=wZ6cST5pexo${constants.cTime}',
    // 'https://www.youtube.com/watch?v=sBBFSuHATmw${constants.cTime}',
    // 'https://www.youtube.com/watch?v=JkaxUblCGz0${constants.cTime}',
    // 'https://www.youtube.com/watch?v=kVpJ6BwG8zg${constants.cTime}',


    'https://www.youtube.com/watch?v=gRj18Tk0j_Q${constants.cTime}',
    'https://www.youtube.com/watch?v=O-KacKngGGA${constants.cTime}',
    'https://www.youtube.com/watch?v=FBQeaKYmZtA${constants.cTime}',
    'https://www.youtube.com/watch?v=05e33y630oo${constants.cTime}',
    'https://www.youtube.com/watch?v=UJzU_Q8xo_U${constants.cTime}',
    'https://www.youtube.com/watch?v=TI3F7xd8JT0${constants.cTime}',
    'https://www.youtube.com/watch?v=tvDYNWxLr-4${constants.cTime}',
    'https://www.youtube.com/watch?v=B3O1OlTWXSA${constants.cTime}',
    'https://www.youtube.com/watch?v=2_bVi2ROr5Q${constants.cTime}',
    'https://www.youtube.com/watch?v=IKP-tzB5-to${constants.cTime}',
    'https://www.youtube.com/watch?v=eKTpOHkAWnk${constants.cTime}',
    'https://www.youtube.com/watch?v=xHqxRGuwzno${constants.cTime}',
  ];

  final random = Random();
  int randomIndex = random.nextInt(stockUrls.length);
  return stockUrls[randomIndex];
}


String getRandomGifImage() {
  final List<String> lottieAssets = [
    constants.gifBartSimpson,
    constants.gifBeeSinging,
    constants.gifBunnyCouple,
    constants.gifBunnyCute,
    constants.gifBunnyGuitar,
    constants.gifCatGuitar,
    constants.gifCatGuitarSing,
    constants.gifCatUkulele,
    constants.gifCatsSinging,
    constants.gifCoupleDance,
    constants.gifCute,
    constants.gifCuteDragon,
    constants.gifDragonDancing,
    constants.gifDraxyRock,
    constants.gifFlowerSing,
    constants.gifGoodMusic,
    constants.gifGuitarSing,
    constants.gifJigglyKaraoke,
    constants.gifJigglyPuffSing,
    constants.gifJumpingHeart,
    constants.gifPeachHeadphone,
    constants.gifSingCute,
    constants.gifSinging,
    constants.gifTwitGuitar,
  ];

  final random = Random();
  int randomIndex = random.nextInt(lottieAssets.length);
  return lottieAssets[randomIndex];
}