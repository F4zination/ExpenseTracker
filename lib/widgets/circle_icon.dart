import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';

class CircleIcon extends StatefulWidget {
  const CircleIcon(
      {super.key,
      required this.icon,
      required this.color,
      this.iconColor,
      this.onPressed,
      this.onLongPress,
      this.animated = true,
      this.iconSize = 45,
      this.ratio = 0.0,
      this.width = 75,
      this.height = 75,
      this.shrinkFactor = 0.9999,
      this.lightnessFactor = 0.35});

  final IconPickerIcon icon;
  final Color color;
  final Color? iconColor;
  final double width;
  final double height;
  final double shrinkFactor;
  final double iconSize;
  final double ratio;
  final bool animated;
  final VoidCallback? onPressed;
  final double lightnessFactor;
  final VoidCallback? onLongPress;

  @override
  State<CircleIcon> createState() => _CircleIconState();
}

class _CircleIconState extends State<CircleIcon>
    with SingleTickerProviderStateMixin {
  final double distanceRing = 7;
  bool isShrinked = false;
  late final AnimationController _animationController;
  late final _iconSizeTween;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _iconSizeTween = Tween<double>(begin: 1, end: widget.shrinkFactor).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Color reduceLightness(Color color, double factor) {
    // Convert the Color to HSLColor
    HSLColor hslColor = HSLColor.fromColor(color);

    // Reduce the lightness by the factor, ensuring it doesn't go below 0
    double newLightness = (hslColor.lightness * (1 + factor)).clamp(0.0, 1.0);

    // Create a new HSLColor with the reduced lightness
    HSLColor adjustedHslColor = hslColor.withLightness(newLightness);

    // Convert it back to Flutter's Color
    return adjustedHslColor.toColor();
  }

  Color reduceSaturation(Color color, double factor) {
    // Convert the Color to HSLColor
    HSLColor hslColor = HSLColor.fromColor(color);

    // Reduce the lightness by the factor, ensuring it doesn't go below 0
    double newSaturation = (hslColor.saturation * (1 + factor)).clamp(0.0, 1.0);

    // Create a new HSLColor with the reduced lightness
    HSLColor adjustedHslColor = hslColor.withSaturation(newSaturation);

    // Convert it back to Flutter's Color
    return adjustedHslColor.toColor();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width + distanceRing + 1,
      height: widget.height + distanceRing + 1,
      child: Stack(
        children: [
          Positioned(
            top: 1,
            left: 0,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              alignment: Alignment.center,
              curve: Curves.easeInOut,
              width: isShrinked
                  ? (widget.width + distanceRing) * widget.shrinkFactor
                  : widget.width + distanceRing,
              height: isShrinked
                  ? (widget.height + distanceRing) * widget.shrinkFactor
                  : widget.height + distanceRing,
              padding: EdgeInsets.only(
                  left: isShrinked ? 15 : 0, top: isShrinked ? 15 : 0),
              child: SizedBox(
                height: widget.height + distanceRing,
                width: widget.width + distanceRing,
                child: CircularProgressIndicator(
                  value: widget.ratio,
                  strokeWidth: 3,
                  backgroundColor: Colors.transparent,
                  valueColor: AlwaysStoppedAnimation<Color>(widget.color),
                ),
              ),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            alignment: Alignment.center,
            curve: Curves.easeInOut,
            width: isShrinked
                ? (widget.width + distanceRing) * widget.shrinkFactor
                : widget.width + distanceRing,
            height: isShrinked
                ? (widget.height + distanceRing) * widget.shrinkFactor
                : widget.height + distanceRing,
            padding: EdgeInsets.only(
                left: isShrinked ? 15 : 0, top: isShrinked ? 15 : 0),
            child: InkWell(
              highlightColor: Colors.transparent,
              splashFactory: NoSplash.splashFactory,
              borderRadius: BorderRadius.circular(90),
              onTap: handlePress,
              onLongPress: widget.onLongPress,
              child: Card(
                color: reduceLightness(reduceSaturation(widget.color, 1.0),
                    widget.lightnessFactor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(90),
                ),
                child: Center(
                  child: SizedBox(
                    width: widget.width,
                    height: widget.height,
                    child: AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, _) {
                        return Icon(
                          widget.icon.data,
                          size: widget.iconSize *
                              _iconSizeTween.value, //widget.iconSize,
                          color: widget.iconColor ?? widget.color,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void handlePress() async {
    widget.onPressed?.call();
    setState(() {
      isShrinked = !isShrinked;
    });
    _animationController.forward();
    await Future.delayed(const Duration(milliseconds: 200));
    if (!mounted) return;
    _animationController.reverse();
    setState(() {
      isShrinked = !isShrinked;
    });
  }
}
