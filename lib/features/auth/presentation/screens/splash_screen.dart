import 'package:flutter/material.dart';
import 'package:yum_quick/app/theme/app_colors.dart';

const _logoOnYellowAsset = 'assets/images/logo_on_yellow.png';
const _logoOnOrangeAsset = 'assets/images/logo_on_orange.png';
const _titleOnYellowAsset = 'assets/images/title_on_yellow.png';
const _titleOnOrangeAsset = 'assets/images/title_on_orange.png';

/// Launch intro from the design: the yellow screen turns orange, the logo
/// and title fade to their orange-screen versions and the tagline fades in.
/// It also covers the time spent restoring the saved session.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, this.onFinished});

  /// Called once the intro has played. The router stays on the splash
  /// until then.
  final VoidCallback? onFinished;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2200),
  );

  // Hold yellow, swap to orange, fade the tagline in, then hold orange.
  late final Animation<double> _swap = CurvedAnimation(
    parent: _controller,
    curve: const Interval(0.25, 0.6, curve: Curves.easeInOut),
  );
  late final Animation<double> _tagline = CurvedAnimation(
    parent: _controller,
    curve: const Interval(0.6, 0.8, curve: Curves.easeOut),
  );

  @override
  void initState() {
    super.initState();
    _controller.forward().whenComplete(() {
      if (mounted) {
        widget.onFinished?.call();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final swap = _swap.value;
        final tagline = _tagline.value;

        return Scaffold(
          backgroundColor:
              Color.lerp(AppColors.yellowBase, AppColors.orangeBase, swap),
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _CrossFade(
                  progress: swap,
                  from: _logoOnYellowAsset,
                  to: _logoOnOrangeAsset,
                  width: 210,
                ),
                const SizedBox(height: 32),
                _CrossFade(
                  progress: swap,
                  from: _titleOnYellowAsset,
                  to: _titleOnOrangeAsset,
                  width: 196,
                  semanticLabel: 'YumQuick',
                ),
                const SizedBox(height: 48),
                Opacity(
                  opacity: tagline,
                  child: Transform.translate(
                    offset: Offset(0, 12 * (1 - tagline)),
                    child: Text(
                      'Your favourite meals,\ndelivered quick.',
                      textAlign: TextAlign.center,
                      style: textTheme.bodyMedium?.copyWith(
                        color: AppColors.font2,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Fades from the yellow-screen version of an image to the orange one.
class _CrossFade extends StatelessWidget {
  const _CrossFade({
    required this.progress,
    required this.from,
    required this.to,
    required this.width,
    this.semanticLabel,
  });

  final double progress;
  final String from;
  final String to;
  final double width;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      excludeSemantics: true,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Opacity(
            opacity: 1 - progress,
            child: Image.asset(from, width: width),
          ),
          Opacity(
            opacity: progress,
            child: Image.asset(to, width: width),
          ),
        ],
      ),
    );
  }
}