import 'package:flutter/material.dart';

/// Overlays a bobbing "swipe up" hint on [body] and calls [onSwipe] when the
/// user drags up far enough.
class SwipeUp extends StatefulWidget {
  const SwipeUp({
    super.key,
    required this.body,
    required this.child,
    this.onSwipe,
    this.sensitivity = 0.5,
    this.color = Colors.black54,
  }) : assert(sensitivity > 0 && sensitivity <= 1);

  final Widget body;

  /// The hint shown at the bottom, which grows while dragging.
  final Widget child;
  final VoidCallback? onSwipe;
  final double sensitivity;
  final Color color;

  @override
  State<SwipeUp> createState() => _SwipeUpState();
}

class _SwipeUpState extends State<SwipeUp> with SingleTickerProviderStateMixin {
  double _dragStartY = 0;
  double _swipeOffset = 0;

  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 2500),
    vsync: this,
  )..repeat(reverse: true);

  late final Animation<double> _bob = CurvedAnimation(
    parent: _controller,
    curve: const Interval(0, 0.25, curve: Curves.decelerate),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onVerticalDragStart: (details) => _dragStartY = details.globalPosition.dy,
      onVerticalDragUpdate: (details) {
        final delta = details.globalPosition.dy - _dragStartY;
        if (delta < 0) {
          setState(() => _swipeOffset = -delta * widget.sensitivity);
        }
      },
      onVerticalDragEnd: (_) {
        if (_swipeOffset > screenHeight / 8) widget.onSwipe?.call();
        setState(() => _swipeOffset = 0);
      },
      child: Stack(
        children: [
          widget.body,
          AnimatedBuilder(
            animation: _bob,
            builder: (context, child) => Positioned(
              bottom: _swipeOffset / 2 + screenHeight / 40 * (1 - _bob.value),
              left: 0,
              right: 0,
              child: child!,
            ),
            child: Column(
              children: [
                Icon(Icons.keyboard_arrow_up, color: widget.color),
                Padding(
                  padding: EdgeInsets.only(
                    top: screenHeight / 240,
                    bottom: screenHeight / 40,
                  ),
                  child: Transform.scale(
                    scale: 1 + _swipeOffset * 2 / screenHeight,
                    child: widget.child,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
