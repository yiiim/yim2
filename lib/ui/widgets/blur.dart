import 'dart:ui';

import 'package:flutter/material.dart';

class YimAppBlurWidget extends StatelessWidget {
  const YimAppBlurWidget({Key? key, this.child, this.color}) : super(key: key);
  final Widget? child;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          child: child,
          decoration: BoxDecoration(color: color ?? Theme.of(context).backgroundColor.withOpacity(0.75)),
        ),
      ),
    );
  }
}
