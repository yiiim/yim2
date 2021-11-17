import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<bool?> showComfirmDialog(BuildContext context, String body, {String? title, bool cancel = false, String cancelTitle = "取消", String confirmTitle = "确定", bool barrierDismissible = false}) {
  return showGeneralDialog<bool?>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierLabel: "",
    pageBuilder: (context, a1, a2) {
      return SimpleDialog(
        contentPadding: EdgeInsets.zero,
        titlePadding: EdgeInsets.zero,
        title: title == null
            ? null
            : Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                alignment: Alignment.center,
                decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Theme.of(context).dividerColor, width: 1))),
                child: Text(title, style: Theme.of(context).textTheme.bodyText1?.copyWith(fontSize: 14)),
              ),
        children: [
          Padding(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16), child: Text(body, style: Theme.of(context).textTheme.bodyText1)),
          Container(height: 1, color: Theme.of(context).dividerColor),
          SizedBox(
            height: 44,
            child: Row(
              children: [
                if (cancel)
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: CupertinoButton(
                            minSize: 0,
                            padding: EdgeInsets.zero,
                            child: Center(child: Text(cancelTitle, style: Theme.of(context).textTheme.bodyText1?.copyWith(fontSize: 14, fontWeight: FontWeight.normal))),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ),
                        Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Container(decoration: BoxDecoration(color: Theme.of(context).dividerColor, borderRadius: BorderRadius.circular(0.5)), width: 1)),
                      ],
                    ),
                  ),
                Expanded(
                  child: CupertinoButton(
                    minSize: 0,
                    padding: EdgeInsets.zero,
                    child: Center(child: Text(confirmTitle, style: TextStyle(fontSize: 14, color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold))),
                    onPressed: () => Navigator.of(context).pop(true),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    },
  );
}
