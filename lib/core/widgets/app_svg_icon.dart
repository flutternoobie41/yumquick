import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';


/// An SVG icon from the design, tinted with [color]. The export's own
/// colours are ignored, so one file works on any background.
class AppSvgIcon extends StatelessWidget {
  const AppSvgIcon(
    this.asset, {
    super.key,
    required this.color,
    this.size = 24,
  });

  final String asset;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      asset,
      width: size,
      height: size,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    );
  }
}