import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

Future<T?> showBottomHorizontalAction<T>(BuildContext context, List<Widget> actions, {String? title}) async {
  return await showCupertinoModalPopup<T>(
    context: context,
    builder: (context) {
      return AppBottomHorizontalAction(
        title: title != null && title.isNotEmpty ? Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)) : null,
        actions: actions,
      );
    },
  );
}

class AppBottomHorizontalIconActionItem extends StatelessWidget {
  const AppBottomHorizontalIconActionItem({Key? key, required this.icon, required this.title, this.onPressed}) : super(key: key);
  final Widget icon;
  final Widget title;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      minSize: 0,
      padding: EdgeInsets.zero,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[icon, title],
      ),
      onPressed: onPressed,
    );
  }
}

class AppBottomHorizontalAction extends StatelessWidget {
  const AppBottomHorizontalAction({Key? key, required this.actions, this.title}) : super(key: key);
  final List<Widget> actions;
  final Widget? title;
  @override
  Widget build(BuildContext context) {
    List<Widget> columChildren = <Widget>[];
    if (title != null) columChildren.add(Container(padding: const EdgeInsets.symmetric(vertical: 3), child: title));
    columChildren.add(
      Container(
        height: 84,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: ListView(
          children: actions.map((e) => Padding(padding: const EdgeInsets.symmetric(horizontal: 8), child: e)).toList(),
          scrollDirection: Axis.horizontal,
        ),
      ),
    );
    return Semantics(
      child: Material(
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).dialogBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: columChildren,
            ),
          ),
        ),
      ),
    );
  }
}
