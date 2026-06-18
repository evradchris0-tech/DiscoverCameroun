// NOTE : Galerie d'images défilable horizontalement pour la page de détail.
// Concept mis en avant : PageView avec PageController et indicateur de page animé (dots).

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import 'smart_image.dart';

class ImageGallery extends StatefulWidget {
  final List<String> images;
  final String heroTag;
  final Color fallbackColor;
  final IconData fallbackIcon;

  const ImageGallery({
    super.key,
    required this.images,
    required this.heroTag,
    this.fallbackColor = AppColors.primary,
    this.fallbackIcon = Icons.landscape,
  });

  @override
  State<ImageGallery> createState() => _ImageGalleryState();
}

class _ImageGalleryState extends State<ImageGallery> {
  final _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 280,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.images.length,
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemBuilder: (context, i) {
              final image = SmartImage(
                source: widget.images[i],
                width: double.infinity,
                height: 280,
                fallbackColor: widget.fallbackColor,
                fallbackIcon: widget.fallbackIcon,
              );
              // Le premier élément porte le Hero pour la transition depuis la liste.
              return i == 0 ? Hero(tag: widget.heroTag, child: image) : image;
            },
          ),
        ),
        if (widget.images.length > 1) ...[
          const SizedBox(height: AppSpacing.sm),
          _DotsIndicator(
              count: widget.images.length, current: _currentPage),
        ],
      ],
    );
  }
}

class _DotsIndicator extends StatelessWidget {
  final int count;
  final int current;

  const _DotsIndicator({required this.count, required this.current});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: i == current ? 16 : 6,
          height: 6,
          decoration: BoxDecoration(
            color: i == current
                ? AppColors.primary
                : AppColors.primaryContainer,
            borderRadius: BorderRadius.circular(AppRadius.dot),
          ),
        );
      }),
    );
  }
}
