import 'package:flutter/material.dart';

const Size appDesignSizeIPhone4 = Size(320, 480);
const Size appDesignSizeIPhone5 = Size(320, 567);
const Size appDesignSizeIPhone6 = Size(375, 667);
const Size appDesignSizeIPhone6Plus = Size(540, 960);
const Size appDesignSizeIPhoneX = Size(375, 812);

double computeHeight(BuildContext context, double designValue, {Size designSize = appDesignSizeIPhone6}) {
  return MediaQuery.of(context).size.height / designSize.height * designValue;
}

double computeWidth(BuildContext context, double designValue, {Size designSize = appDesignSizeIPhone6}) {
  return MediaQuery.of(context).size.width / designSize.width * designValue;
}

double computeRatioHeight(double width, Size ratioSize) {
  return width / (ratioSize.width / ratioSize.height);
}

double computeRatioWidth(double height, Size ratioSize) {
  return height / (ratioSize.height / ratioSize.width);
}
