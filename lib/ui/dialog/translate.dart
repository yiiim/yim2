import 'package:flutter/material.dart';

Future<T?> showAlignmentDialog<T>(BuildContext context, Widget child, {Alignment from = Alignment.bottomCenter, Alignment to = Alignment.topCenter, bool barrierDismissible = true, double? offset}) {
  return showGeneralDialog<T>(
    context: context,
    pageBuilder: (context, animation, secondaryAnimation) => child,
    barrierDismissible: barrierDismissible,
    barrierLabel: "Dismiss",
    barrierColor: Colors.black26,
    transitionDuration: const Duration(milliseconds: 300),
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return AlignTransition(
        alignment: CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOut,
        ).drive(Tween<AlignmentGeometry>(begin: from, end: to)),
        child: Material(
          color: Colors.transparent,
          child: child,
        ),
      );
    },
  );
}
