import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class YimListRow extends StatefulWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final Color? backgroundColor;
  final EdgeInsets padding;
  final Widget? dividingLine;
  bool get enabled => onPressed != null;
  const YimListRow({Key? key, required this.child, this.onPressed, this.backgroundColor, this.padding = const EdgeInsets.symmetric(horizontal: 16), this.dividingLine}) : super(key: key);
  @override
  State<StatefulWidget> createState() => YimListRowState();
}

class YimListRowState extends State<YimListRow> with SingleTickerProviderStateMixin {
  static const Duration kFadeOutDuration = Duration(milliseconds: 10);
  static const Duration kFadeInDuration = Duration(milliseconds: 100);

  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      value: 0.0,
      vsync: this,
    );
    _opacityAnimation = _animationController.drive(CurveTween(curve: Curves.decelerate)).drive(Tween<double>(begin: 0.0, end: 1.0));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  bool _heldDown = false;

  void _handleTapDown(TapDownDetails event) {
    if (!_heldDown) {
      _heldDown = true;
      _animate();
    }
  }

  void _handleTapUp(TapUpDetails event) {
    if (_heldDown) {
      _heldDown = false;
      _animate();
    }
  }

  void _handleTapCancel() {
    if (_heldDown) {
      _heldDown = false;
      _animate();
    }
  }

  void _animate() {
    if (_animationController.isAnimating) return;
    final bool wasHeldDown = _heldDown;
    final TickerFuture ticker = _heldDown ? _animationController.animateTo(1.0, duration: kFadeOutDuration) : _animationController.animateTo(0.0, duration: kFadeInDuration);
    ticker.then<void>((void value) {
      if (mounted && wasHeldDown != _heldDown) _animate();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool enabled = widget.enabled;
    return DecoratedBox(
      decoration: BoxDecoration(color: widget.backgroundColor ?? Theme.of(context).backgroundColor),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTapDown: enabled ? _handleTapDown : null,
        onTapUp: enabled ? _handleTapUp : null,
        onTapCancel: enabled ? _handleTapCancel : null,
        onTap: widget.onPressed,
        child: Stack(
          children: <Widget>[
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              top: 0,
              child: FadeTransition(
                opacity: _opacityAnimation,
                child: DecoratedBox(decoration: BoxDecoration(color: Theme.of(context).hoverColor)),
              ),
            ),
            Container(padding: widget.padding, child: widget.child),
            if (widget.dividingLine != null) Positioned(bottom: 0, left: 0, right: 0, child: widget.dividingLine ?? Container())
          ],
        ),
      ),
    );
  }
}
