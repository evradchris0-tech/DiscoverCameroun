// NOTE : Écran de démarrage affiché au lancement de l'application avant la page d'accueil.
// Concept mis en avant : AnimationController unique pilotant plusieurs animations via des Interval.

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import 'main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

// SingleTickerProviderStateMixin fournit le "ticker" nécessaire à l'AnimationController.
class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _logoScale;
  late Animation<double> _logoFade;
  late Animation<Offset> _titleSlide;
  late Animation<double> _titleFade;
  late Animation<double> _taglineFade;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );

    // Chaque Interval définit la plage de temps pendant laquelle l'animation s'active.
    final logoInterval = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
    );
    final titleInterval = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.35, 0.75, curve: Curves.easeOutCubic),
    );
    final taglineInterval = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.6, 1.0, curve: Curves.easeIn),
    );

    _logoScale = Tween<double>(begin: 0.0, end: 1.0).animate(logoInterval);
    _logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.4, curve: Curves.easeIn),
      ),
    );
    // Offset(0, 0.4) = décalé de 40% vers le bas au départ.
    _titleSlide = Tween<Offset>(
      begin: const Offset(0, 0.4),
      end: Offset.zero,
    ).animate(titleInterval);
    _titleFade = Tween<double>(begin: 0.0, end: 1.0).animate(titleInterval);
    _taglineFade = Tween<double>(begin: 0.0, end: 1.0).animate(taglineInterval);

    _controller.forward().then((_) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (!mounted) return;
        // pushReplacement : l'utilisateur ne peut pas revenir au splash en arrière.
        Navigator.pushReplacement(
          context,
          _buildFadeRoute(const MainScreen()),
        );
      });
    });
  }

  PageRouteBuilder<void> _buildFadeRoute(Widget page) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 600),
      pageBuilder: (context, animation, _) => page,
      transitionsBuilder: (context, animation, _, child) {
        return FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: Curves.easeIn),
          child: child,
        );
      },
    );
  }

  @override
  void dispose() {
    // Toujours libérer l'AnimationController pour éviter les fuites mémoire.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo : ScaleTransition + FadeTransition combinés.
            ScaleTransition(
              scale: _logoScale,
              child: FadeTransition(
                opacity: _logoFade,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.1),
                    border: Border.all(
                      color: AppColors.gold,
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.explore,
                    color: AppColors.gold,
                    size: 50,
                  ),
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.xxxl),

            // Titre : vient du bas grâce à SlideTransition + fondu.
            SlideTransition(
              position: _titleSlide,
              child: FadeTransition(
                opacity: _titleFade,
                child: Text(
                  'Discover',
                  style: AppTypography.splashTitle.copyWith(color: Colors.white),
                ),
              ),
            ),

            SlideTransition(
              position: _titleSlide,
              child: FadeTransition(
                opacity: _titleFade,
                child: Text(
                  'Cameroon',
                  style:
                      AppTypography.splashTitle.copyWith(color: AppColors.gold),
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.md),

            FadeTransition(
              opacity: _taglineFade,
              child: Text(
                'Guide touristique officiel',
                style: AppTypography.tagline
                    .copyWith(color: Colors.white.withValues(alpha: 0.55)),
              ),
            ),

            const SizedBox(height: AppSpacing.huge),

            FadeTransition(
              opacity: _taglineFade,
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.gold.withValues(alpha: 0.7),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
