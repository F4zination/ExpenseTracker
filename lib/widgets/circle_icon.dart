import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';

class CircleIcon extends StatelessWidget {
  const CircleIcon(
      {super.key,
      required this.icon,
      required this.color,
      this.iconColor,
      this.onPressed,
      this.onLongPress,
      this.iconSize = 45,
      this.ratio = 0.0,
      this.width = 75,
      this.height = 75,
      this.lightnessFactor = 0.35});

  final IconPickerIcon icon;
  final Color color;
  final Color? iconColor;
  final double width;
  final double height;
  final double iconSize;
  final double ratio;
  final double distanceRing = 7;
  final void Function()? onPressed;
  final double lightnessFactor;
  final void Function()? onLongPress;

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

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 1,
          left: 0,
          child: SizedBox(
            height: height + distanceRing,
            width: width + distanceRing,
            child: CircularProgressIndicator(
              value: ratio,
              strokeWidth: 3,
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ),
        InkWell(
          highlightColor: Colors.transparent,
          splashFactory: NoSplash.splashFactory,
          onTap: onPressed,
          onLongPress: onLongPress,
          child: Card(
            color: reduceLightness(color, lightnessFactor),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(90),
            ),
            child: Center(
              child: SizedBox(
                width: width,
                height: height,
                child:
                    Icon(icon.data, size: iconSize, color: iconColor ?? color),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
