// NOTE : Bouton "j'aime" avec un compteur persistant entre les sessions de l'application.
// Concept mis en avant : TweenSequence pour enchaîner deux animations + SharedPreferences pour la persistance locale.

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

class LikeButton extends StatefulWidget {
  final int initialLikes;
  final String destinationId;

  const LikeButton({
    super.key,
    this.initialLikes = 0,
    required this.destinationId,
  });

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton>
    with SingleTickerProviderStateMixin {

  late int _likeCount;
  bool _isLiked = false;

  late AnimationController _pulseController;

  // TweenSequence : grossit jusqu'à 1.35x puis revient à 1.0x (effet rebond).
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _likeCount = widget.initialLikes;
    _loadLikes();

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 350),
      vsync: this,
    );

    _pulseAnim = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 1.35)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 60,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.35, end: 1.0)
            .chain(CurveTween(curve: Curves.elasticIn)),
        weight: 40,
      ),
    ]).animate(_pulseController);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _loadLikes() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _isLiked = prefs.getBool('liked_${widget.destinationId}') ?? false;
      _likeCount = prefs.getInt('count_${widget.destinationId}') ?? widget.initialLikes;
    });
  }

  Future<void> _saveLikes() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('liked_${widget.destinationId}', _isLiked);
    await prefs.setInt('count_${widget.destinationId}', _likeCount);
  }

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
      _likeCount += _isLiked ? 1 : -1;
    });
    // forward(from: 0) relance l'animation depuis le début à chaque tap.
    _pulseController.forward(from: 0);
    _saveLikes();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: _toggleLike,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg, vertical: AppSpacing.smPlus),
        decoration: BoxDecoration(
          color: _isLiked
              ? colorScheme.primary.withValues(alpha: 0.12)
              : AppColors.textLight.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(AppRadius.pill),
          border: Border.all(
            color: _isLiked
                ? colorScheme.primary.withValues(alpha: 0.5)
                : AppColors.outline,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ScaleTransition(
              scale: _pulseAnim,
              child: Icon(
                _isLiked ? Icons.favorite : Icons.favorite_border,
                color: _isLiked ? colorScheme.primary : AppColors.textLight,
                size: 20,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            // AnimatedSwitcher anime le changement de nombre avec un slide vers le haut.
            // La ValueKey est indispensable pour que Flutter détecte le changement.
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (child, animation) => SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, -0.5),
                  end: Offset.zero,
                ).animate(animation),
                child: FadeTransition(opacity: animation, child: child),
              ),
              child: Text(
                '$_likeCount',
                key: ValueKey(_likeCount),
                style: AppTypography.sans(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: _isLiked ? colorScheme.primary : AppColors.textMedium,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
