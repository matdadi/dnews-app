import 'package:deltanews/utils/const.dart';
import 'package:flutter_animate/flutter_animate.dart';

List<Effect<dynamic>> customItemZoomAppearanceEffects({
  Duration? delay,
  Duration? duration,
}) {
  return isApplicationItemAnimationOn
      ? [
          ScaleEffect(
            delay: delay,
            duration: duration ??
                const Duration(
                  milliseconds: 200,
                ),
          ),
        ]
      : [];
}
