import 'package:flutter/material.dart';

class YimEmptyOrFailOrBlankView extends StatelessWidget {
  final bool fail;
  final bool empty;
  final bool blank;
  final Widget? failText;
  final Widget? emptyText;
  final void Function()? failTap;
  final void Function()? emptyTap;
  final EdgeInsets contentPadding;
  final Widget Function(BuildContext context)? emptyBuilder;
  final Widget Function(BuildContext context)? failBuilder;
  @required
  final Widget Function(BuildContext context) childBuilder;
  const YimEmptyOrFailOrBlankView({Key? key, this.fail = false, this.contentPadding = EdgeInsets.zero, this.empty = false, this.blank = false, this.failTap, this.emptyTap, this.failText, this.emptyText, required this.childBuilder, this.emptyBuilder, this.failBuilder}) : super(key: key);
  Widget _buildFailText(BuildContext context) {
    if (failText != null) return failText!;
    if (failTap != null) return const Text("加载失败,点击重试");
    return const Text("加载失败，请稍后重试");
  }

  Widget _buildEmptyText(BuildContext context) {
    if (emptyText != null) return emptyText!;
    if (emptyTap != null) return const Text("暂无数据,点击刷新");
    return const Text("暂无数据");
  }

  Widget _buildFail(BuildContext context) {
    if (failBuilder != null) return failBuilder!(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _buildFailText(context),
      ],
    );
  }

  Widget _buildEmpty(BuildContext context) {
    if (emptyBuilder != null) return emptyBuilder!(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _buildEmptyText(context),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (fail) return Padding(padding: contentPadding, child: GestureDetector(behavior: HitTestBehavior.translucent, onTap: failTap, child: Center(child: _buildFail(context))));
    if (blank) return Container();
    if (empty) return emptyBuilder != null ? emptyBuilder!(context) : Padding(padding: contentPadding, child: GestureDetector(onTap: emptyTap, behavior: HitTestBehavior.translucent, child: Center(child: _buildEmpty(context))));
    return childBuilder(context);
  }
}
