/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart' as _svg;
import 'package:vector_graphics/vector_graphics.dart' as _vg;

class $GoogleFontsGen {
  const $GoogleFontsGen();

  /// File path: google_fonts/Inter-Black.ttf
  String get interBlack => 'google_fonts/Inter-Black.ttf';

  /// File path: google_fonts/Inter-Bold.ttf
  String get interBold => 'google_fonts/Inter-Bold.ttf';

  /// File path: google_fonts/Inter-ExtraBold.ttf
  String get interExtraBold => 'google_fonts/Inter-ExtraBold.ttf';

  /// File path: google_fonts/Inter-ExtraLight.ttf
  String get interExtraLight => 'google_fonts/Inter-ExtraLight.ttf';

  /// File path: google_fonts/Inter-Light.ttf
  String get interLight => 'google_fonts/Inter-Light.ttf';

  /// File path: google_fonts/Inter-Medium.ttf
  String get interMedium => 'google_fonts/Inter-Medium.ttf';

  /// File path: google_fonts/Inter-Regular.ttf
  String get interRegular => 'google_fonts/Inter-Regular.ttf';

  /// File path: google_fonts/Inter-SemiBold.ttf
  String get interSemiBold => 'google_fonts/Inter-SemiBold.ttf';

  /// File path: google_fonts/Inter-Thin.ttf
  String get interThin => 'google_fonts/Inter-Thin.ttf';

  /// File path: google_fonts/OFL.txt
  String get ofl => 'google_fonts/OFL.txt';

  /// List of all assets
  List<String> get values => [
        interBlack,
        interBold,
        interExtraBold,
        interExtraLight,
        interLight,
        interMedium,
        interRegular,
        interSemiBold,
        interThin,
        ofl
      ];
}

class $LibGen {
  const $LibGen();

  /// File path: lib/.env
  String get aEnv => 'lib/.env';

  /// List of all assets
  List<String> get values => [aEnv];
}

class $AssetsIconsGen {
  const $AssetsIconsGen();

  /// File path: assets/icons/icon_category.svg
  SvgGenImage get iconCategory =>
      const SvgGenImage('assets/icons/icon_category.svg');

  /// File path: assets/icons/icon_home.svg
  SvgGenImage get iconHome => const SvgGenImage('assets/icons/icon_home.svg');

  /// File path: assets/icons/icon_recommendation.svg
  SvgGenImage get iconRecommendation =>
      const SvgGenImage('assets/icons/icon_recommendation.svg');

  /// File path: assets/icons/icon_search.svg
  SvgGenImage get iconSearch =>
      const SvgGenImage('assets/icons/icon_search.svg');

  /// File path: assets/icons/icon_watch.svg
  SvgGenImage get iconWatch => const SvgGenImage('assets/icons/icon_watch.svg');

  /// File path: assets/icons/logo deltakode.svg
  SvgGenImage get logoDeltakode =>
      const SvgGenImage('assets/icons/logo deltakode.svg');

  /// List of all assets
  List<SvgGenImage> get values => [
        iconCategory,
        iconHome,
        iconRecommendation,
        iconSearch,
        iconWatch,
        logoDeltakode
      ];
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/dummy_berita.png
  AssetGenImage get dummyBerita =>
      const AssetGenImage('assets/images/dummy_berita.png');

  /// File path: assets/images/dummy_slider.png
  AssetGenImage get dummySlider =>
      const AssetGenImage('assets/images/dummy_slider.png');

  /// File path: assets/images/dummy_video.png
  AssetGenImage get dummyVideo =>
      const AssetGenImage('assets/images/dummy_video.png');

  /// File path: assets/images/logo dnews putih.png
  AssetGenImage get logoDnewsPutih =>
      const AssetGenImage('assets/images/logo dnews putih.png');

  /// File path: assets/images/logo.png
  AssetGenImage get logo => const AssetGenImage('assets/images/logo.png');

  /// List of all assets
  List<AssetGenImage> get values =>
      [dummyBerita, dummySlider, dummyVideo, logoDnewsPutih, logo];
}

class Assets {
  Assets._();

  static const $AssetsIconsGen icons = $AssetsIconsGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();
  static const $GoogleFontsGen googleFonts = $GoogleFontsGen();
  static const $LibGen lib = $LibGen();
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

class SvgGenImage {
  const SvgGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
  }) : _isVecFormat = false;

  const SvgGenImage.vec(
    this._assetName, {
    this.size,
    this.flavors = const {},
  }) : _isVecFormat = true;

  final String _assetName;
  final Size? size;
  final Set<String> flavors;
  final bool _isVecFormat;

  _svg.SvgPicture svg({
    Key? key,
    bool matchTextDirection = false,
    AssetBundle? bundle,
    String? package,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    AlignmentGeometry alignment = Alignment.center,
    bool allowDrawingOutsideViewBox = false,
    WidgetBuilder? placeholderBuilder,
    String? semanticsLabel,
    bool excludeFromSemantics = false,
    _svg.SvgTheme? theme,
    ColorFilter? colorFilter,
    Clip clipBehavior = Clip.hardEdge,
    @deprecated Color? color,
    @deprecated BlendMode colorBlendMode = BlendMode.srcIn,
    @deprecated bool cacheColorFilter = false,
  }) {
    final _svg.BytesLoader loader;
    if (_isVecFormat) {
      loader = _vg.AssetBytesLoader(
        _assetName,
        assetBundle: bundle,
        packageName: package,
      );
    } else {
      loader = _svg.SvgAssetLoader(
        _assetName,
        assetBundle: bundle,
        packageName: package,
        theme: theme,
      );
    }
    return _svg.SvgPicture(
      loader,
      key: key,
      matchTextDirection: matchTextDirection,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
      placeholderBuilder: placeholderBuilder,
      semanticsLabel: semanticsLabel,
      excludeFromSemantics: excludeFromSemantics,
      colorFilter: colorFilter ??
          (color == null ? null : ColorFilter.mode(color, colorBlendMode)),
      clipBehavior: clipBehavior,
      cacheColorFilter: cacheColorFilter,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
