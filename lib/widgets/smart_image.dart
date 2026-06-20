// NOTE : Affiche une image distante (URL) ou locale (asset). Les images réseau sont
// mises en cache (cached_network_image) avec un placeholder shimmer + fondu d'apparition.
// Concept mis en avant : une seule API d'image, performante et moderne.

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'skeleton.dart';

class SmartImage extends StatelessWidget {
  final String source;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Color fallbackColor;
  final IconData fallbackIcon;

  const SmartImage({
    super.key,
    required this.source,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.fallbackColor = AppColors.primary,
    this.fallbackIcon = Icons.landscape,
  });

  bool get _isNetwork => source.startsWith('http');

  Widget _fallback() => Container(
        width: width,
        height: height,
        color: fallbackColor,
        child: Icon(fallbackIcon,
            color: Colors.white.withValues(alpha: 0.85), size: 32),
      );

  @override
  Widget build(BuildContext context) {
    if (source.isEmpty) return _fallback();

    if (_isNetwork) {
      return CachedNetworkImage(
        imageUrl: source,
        width: width,
        height: height,
        fit: fit,
        fadeInDuration: const Duration(milliseconds: 300),
        placeholder: (_, __) =>
            Skeleton(width: width, height: height, radius: 0),
        errorWidget: (_, __, ___) => _fallback(),
      );
    }

    return Image.asset(
      source,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (_, __, ___) => _fallback(),
    );
  }
}
