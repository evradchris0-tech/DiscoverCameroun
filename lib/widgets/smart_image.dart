// NOTE : Affiche une image qu'elle soit distante (URL réseau) ou locale (asset),
// avec indicateur de chargement et repli coloré en cas d'échec.
// Concept mis en avant : une seule API d'image pour les deux schémas de données.

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

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
      return Image.network(
        source,
        width: width,
        height: height,
        fit: fit,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return Container(
            width: width,
            height: height,
            color: fallbackColor.withValues(alpha: 0.15),
            child: const Center(
              child: SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        },
        errorBuilder: (_, __, ___) => _fallback(),
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
