// NOTE : Affiche le temps de trajet estimé (voiture) depuis la position de l'utilisateur
// vers une cible. S'efface proprement si la localisation est indisponible/refusée.
// Concept mis en avant : ConsumerWidget + FutureProvider.family (routeToProvider).

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/app_localizations.dart';
import '../providers/location_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

class RouteInfo extends ConsumerWidget {
  final double lat;
  final double lng;

  const RouteInfo({super.key, required this.lat, required this.lng});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final routeAsync = ref.watch(routeToProvider((lat: lat, lng: lng)));

    return routeAsync.maybeWhen(
      data: (route) {
        if (route == null) return const SizedBox.shrink();
        return Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
          padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm, vertical: AppSpacing.xxs),
          decoration: BoxDecoration(
            color: AppColors.primaryContainer,
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.directions_car,
                  size: 14, color: AppColors.primary),
              const SizedBox(width: AppSpacing.xxs),
              Flexible(
                child: Text(
                  l10n.routeFromYou(route.distanceLabel, route.durationLabel),
                  style: AppTypography.sans(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary),
                ),
              ),
            ],
          ),
        );
      },
      orElse: () => const SizedBox.shrink(),
    );
  }
}
