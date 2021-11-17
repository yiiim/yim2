import 'dart:math';

import 'package:flutter/material.dart';

class YimLoading extends StatelessWidget {
  const YimLoading({Key? key, this.text, this.textStyle, this.size = 44}) : super(key: key);
  final String? text;
  final double size;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation(
              Theme.of(context).primaryColor,
            ),
          ),
        ),
        Visibility(visible: text != null && text!.isNotEmpty, child: Padding(padding: const EdgeInsets.only(top: 8), child: Text(text ?? "", style: textStyle)))
      ],
    );
  }
}

class _YimIosLoadingCustomPainter extends CustomPainter {
  _YimIosLoadingCustomPainter(this.progress, this.color, {this.indicatorHeight, this.indicatorWidth = 4, this.indicatorCount = 8});
  final double progress;
  final Color color;
  final double? indicatorHeight;
  final double? indicatorWidth;
  final double indicatorCount;

  void rotatedAtCenter(Canvas canvas, Size size, double angle) {
    final double r = sqrt(size.width * size.width + size.height * size.height) / 2;
    final alpha = atan(size.height / size.width);
    final beta = alpha + angle;
    final shiftY = r * sin(beta);
    final shiftX = r * cos(beta);
    final translateX = size.width / 2 - shiftX;
    final translateY = size.height / 2 - shiftY;
    canvas.translate(translateX, translateY);
    canvas.rotate(angle);
  }

  @override
  void paint(Canvas canvas, Size size) {
    double circleSize = min(size.width, size.height);
    double itemHeight = indicatorHeight ?? circleSize / 3.2;
    double itemWidth = indicatorWidth ?? 4;

    Path path = Path();
    path.addRRect(RRect.fromRectAndRadius(Rect.fromLTWH((size.width - itemWidth) / 2, (size.height - circleSize) / 2, itemWidth, itemHeight), Radius.circular(itemWidth / 2.0)));
    var animationProgress = indicatorCount * progress;
    for (var i = 0; i < indicatorCount; i++) {
      canvas.save();
      rotatedAtCenter(canvas, size, pi / 180 * (i * 360 / indicatorCount));
      var itemTween = Tween<double>(begin: 1.0 * i - indicatorCount, end: 1.0 * i);
      double current = animationProgress < itemTween.end! ? animationProgress : (animationProgress - itemTween.end! + itemTween.begin!);
      double progress = 1 - (current - itemTween.begin!) / indicatorCount;
      // if (progress < 0.5) progress = 1 - progress;
      if (progress < 0.3) progress = 0;
      // progress = max(0.5, progress);
      Color c = ColorTween(begin: color.withOpacity(0.3), end: color).transform(progress)!;
      canvas.drawPath(path, (Paint()..style = PaintingStyle.fill)..color = c);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _YimIosLoadingCustomPainter oldDelegate) => oldDelegate.progress != progress;
}

class YimIosLoading extends StatefulWidget {
  const YimIosLoading({Key? key, this.color, this.indicatorHeight, this.indicatorWidth, this.size, this.duration = const Duration(seconds: 1)}) : super(key: key);
  final Duration duration;
  final Color? color;
  final double? indicatorHeight;
  final double? indicatorWidth;
  final double? size;
  @override
  State<StatefulWidget> createState() => _YimIosLoadingState();
}

class _YimIosLoadingState extends State<YimIosLoading> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, lowerBound: 0, upperBound: 1);
    _animationController.repeat(period: const Duration(milliseconds: 1000));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, view) {
        double size = min(view.maxHeight, view.maxHeight);
        return SizedBox(
          height: widget.size ?? size,
          width: widget.size ?? size,
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return CustomPaint(
                painter: _YimIosLoadingCustomPainter(
                  _animationController.value,
                  widget.color ?? Theme.of(context).primaryColor,
                  indicatorHeight: widget.indicatorHeight,
                  indicatorWidth: widget.indicatorWidth,
                ),
              );
            },
          ),
        );
      },
    );
  }
}
