// NOTE : Onglet « Profil » — épuré et structuré : en-tête, stats, et sections
// groupées (Mon espace, Préférences, Aide & infos) à la manière des apps modernes.
// Concept mis en avant : ConsumerWidget agrégeant les providers (langue, favoris).

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../core/launcher.dart';
import '../l10n/app_localizations.dart';
import '../providers/destinations_provider.dart';
import '../providers/favorites_provider.dart';
import '../providers/locale_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import 'emergency_screen.dart';
import 'favorites_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  static const _supportPhone = '+237655746714';

  void _showAbout(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: AppRadius.cardBorder),
        title: Text(l10n.appTitle, style: AppTypography.dialogTitle),
        content: Text(l10n.aboutContent, style: AppTypography.sans(height: 1.5)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.actionClose),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final total = ref.watch(destinationsProvider).valueOrNull?.length ?? 0;
    final favorites = ref.watch(favoritesProvider).length;
    final locale = ref.watch(localeProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.profileTitle)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          const SizedBox(height: AppSpacing.md),

          // En-tête
          Center(
            child: Column(
              children: [
                Container(
                  width: 84,
                  height: 84,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryContainer,
                  ),
                  child: const Icon(Icons.person,
                      size: 44, color: AppColors.primary),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(l10n.profileTraveler, style: AppTypography.sectionTitle),
                const SizedBox(height: AppSpacing.xxs),
                Text(l10n.profileTagline, style: AppTypography.caption),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.xl),

          // Logo KmerTour
          Center(
            child: Image.asset(
              'assets/images/kmertour_logo.png',
              height: 56,
              fit: BoxFit.contain,
            ),
          ),

          const SizedBox(height: AppSpacing.xl),

          // Statistiques
          Row(
            children: [
              Expanded(
                  child: _Stat(value: '$total', label: l10n.statDestinations)),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                  child: _Stat(value: '$favorites', label: l10n.statFavorites)),
            ],
          ),

          const SizedBox(height: AppSpacing.xl),

          // --- Mon espace ---
          _GroupTitle(l10n.profileGroupAccount),
          _Card(children: [
            _Tile(
              icon: Icons.bookmark_outline,
              label: l10n.profileMyFavorites,
              trailing: _Pill(text: '$favorites'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FavoritesScreen()),
              ),
            ),
          ]),

          const SizedBox(height: AppSpacing.lg),

          // --- Préférences ---
          _GroupTitle(l10n.profileGroupPreferences),
          _Card(children: [
            _Tile(
              icon: Icons.language,
              label: l10n.profileLanguage,
              trailing: _Pill(text: locale.languageCode.toUpperCase()),
              onTap: () => ref.read(localeProvider.notifier).toggle(),
            ),
          ]),

          const SizedBox(height: AppSpacing.lg),

          // --- Aide & infos ---
          _GroupTitle(l10n.profileGroupSupport),
          _Card(children: [
            _Tile(
              icon: Icons.emergency_outlined,
              iconColor: AppColors.danger,
              label: l10n.emergencyTitle,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const EmergencyScreen()),
              ),
            ),
            const Divider(height: 1),
            _Tile(
              icon: Icons.support_agent,
              label: l10n.profileHelp,
              onTap: () => AppLauncher.whatsapp(_supportPhone,
                  message: 'Bonjour, j\'ai besoin d\'aide sur KmerTour.'),
            ),
            const Divider(height: 1),
            _Tile(
              icon: Icons.share_outlined,
              label: l10n.profileShare,
              onTap: () => Share.share(l10n.shareAppText),
            ),
            const Divider(height: 1),
            _Tile(
              icon: Icons.info_outline,
              label: l10n.profileAbout,
              onTap: () => _showAbout(context),
            ),
          ]),

          const SizedBox(height: AppSpacing.xxl),

          Center(
            child:
                Text('${l10n.appTitle} · v1.0.0', style: AppTypography.caption),
          ),
        ],
      ),
    );
  }
}

class _GroupTitle extends StatelessWidget {
  final String text;
  const _GroupTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          left: AppSpacing.xs, bottom: AppSpacing.sm),
      child: Text(
        text.toUpperCase(),
        style: AppTypography.sans(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
            color: AppColors.textLight),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String value;
  final String label;
  const _Stat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.cardBorder,
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Column(
        children: [
          Text(value,
              style: AppTypography.serif(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary)),
          const SizedBox(height: AppSpacing.xxs),
          Text(label, style: AppTypography.caption),
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final List<Widget> children;
  const _Card({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.cardBorder,
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Column(children: children),
    );
  }
}

class _Tile extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final String label;
  final Widget? trailing;
  final VoidCallback onTap;

  const _Tile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.iconColor,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: iconColor ?? AppColors.primary, size: 22),
      title: Text(label,
          style: AppTypography.sans(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark)),
      trailing: trailing ??
          const Icon(Icons.chevron_right, color: AppColors.textLight),
      onTap: onTap,
    );
  }
}

class _Pill extends StatelessWidget {
  final String text;
  const _Pill({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.primaryContainer,
        borderRadius: BorderRadius.circular(AppRadius.chip),
      ),
      child: Text(text,
          style: AppTypography.sans(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.primary)),
    );
  }
}
