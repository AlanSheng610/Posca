import 'package:defer_pointer/defer_pointer.dart';
import 'package:flutter/material.dart';

/// Lets the user drag, pinch-zoom and rotate [child] within bounds.
class Transformable extends StatefulWidget {
  const Transformable({
    super.key,
    required this.child,
    this.minScale = 0.8,
    this.maxScale = 2.5,
    this.maxTranslationX = 100,
    this.maxTranslationY = 100,
    this.initialOffset = Offset.zero,
    this.initialScale = 1.0,
  });

  final Widget child;
  final double minScale;
  final double maxScale;
  final double maxTranslationX;
  final double maxTranslationY;
  final Offset initialOffset;
  final double initialScale;

  @override
  State<Transformable> createState() => _TransformableState();
}

class _TransformableState extends State<Transformable> {
  late Offset _offset = widget.initialOffset;
  late double _scale = widget.initialScale;
  double _rotation = 0;

  // Values captured when the current gesture started.
  Offset _gestureStart = Offset.zero;
  Offset _gestureOffset = Offset.zero;
  double _startScale = 1;
  double _startRotation = 0;

  // Lets the child receive taps even after it's been moved outside the
  // bounds of this widget.
  final _pointerLink = DeferredPointerHandlerLink();

  @override
  Widget build(BuildContext context) {
    return DeferredPointerHandler(
      link: _pointerLink,
      child: ClipRect(
        child: Align(
          alignment: Alignment.topLeft,
          child: _buildTransformed(),
        ),
      ),
    );
  }

  Widget _buildTransformed() {
    return Transform.translate(
      offset: _clamp(_offset + _gestureOffset),
      child: Transform.scale(
        scale: _scale,
        child: Transform.rotate(
          angle: _rotation,
          child: DeferPointer(
            link: _pointerLink,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onScaleStart: _onScaleStart,
              onScaleUpdate: _onScaleUpdate,
              onScaleEnd: _onScaleEnd,
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }

  void _onScaleStart(ScaleStartDetails details) {
    _gestureStart = details.focalPoint;
    _startScale = _scale;
    _startRotation = _rotation;
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    setState(() {
      _gestureOffset = details.focalPoint - _gestureStart;
      _scale =
          (_startScale * details.scale).clamp(widget.minScale, widget.maxScale);
      _rotation = _startRotation + details.rotation;
    });
  }

  void _onScaleEnd(ScaleEndDetails details) {
    setState(() {
      _offset += _gestureOffset;
      _gestureOffset = Offset.zero;
    });
  }

  Offset _clamp(Offset offset) => Offset(
        offset.dx.clamp(-widget.maxTranslationX, widget.maxTranslationX),
        offset.dy.clamp(-widget.maxTranslationY, widget.maxTranslationY),
      );
}
