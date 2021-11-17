import 'package:flutter/material.dart';

class YimVisibilityBuilder extends StatelessWidget {
  const YimVisibilityBuilder({Key? key, required this.visible, required this.builder}) : super(key: key);
  final bool visible;
  final Widget Function(BuildContext) builder;
  @override
  Widget build(BuildContext context) {
    if (visible) return builder(context);
    return Visibility(child: Container(), visible: false);
  }
}
