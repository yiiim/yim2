import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../size_help.dart';

Future<int?> showYimActionSheet<int>(BuildContext context, List<Widget> actions, {String? title, bool cancel = true}) async {
  List<YimActionSheetAction> aheetActions = <YimActionSheetAction>[];
  for (var i = 0; i < actions.length; i++) {
    aheetActions.add(YimActionSheetAction(child: actions[i], onPressed: () => Navigator.pop(context, i)));
  }
  return await showCupertinoModalPopup<int>(
    context: context,
    builder: (context) {
      return YimActionSheet(
        title: title != null && title.isNotEmpty ? Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)) : null,
        cancelButton: cancel ? YimActionSheetAction(child: const Text("取消"), onPressed: () => Navigator.pop(context)) : null,
        actions: aheetActions,
      );
    },
  );
}

class YimActionSheetAction extends StatelessWidget {
  const YimActionSheetAction({Key? key, required this.child, this.onPressed}) : super(key: key);
  final Widget child;
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 44),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          child: Container(
            alignment: Alignment.center,
            child: child,
          ),
        ),
      ),
    );
  }
}

class YimActionSheet extends StatelessWidget {
  const YimActionSheet({Key? key, this.cancelButton, required this.actions, this.title}) : super(key: key);
  final Widget? cancelButton;
  final List<Widget> actions;
  final Widget? title;
  @override
  Widget build(BuildContext context) {
    List<Widget> columChildren = <Widget>[];
    if (title != null) columChildren.add(Container(padding: const EdgeInsets.symmetric(vertical: 3), child: title));
    for (var i = 0; i < actions.length; i++) {
      columChildren.add(actions[i]);
      if (i != actions.length - 1) columChildren.add(const Divider(height: 1));
    }
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
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: computeHeight(context, 190)),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: columChildren,
                    ),
                  ),
                ),
                cancelButton == null ? Container() : Container(color: Theme.of(context).dividerColor.withOpacity(0.1), height: 4),
                cancelButton == null ? Container() : cancelButton!,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
