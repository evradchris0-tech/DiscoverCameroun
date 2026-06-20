// NOTE : Bottom-sheet de réservation multi-étapes.
// Concept mis en avant : stepper manuel (3 pages animées) + WhatsApp pré-rempli.
// Le numéro WhatsApp de contact KmerTour est câblé ici ; c'est le seul endroit.

import 'package:flutter/material.dart';

import '../core/launcher.dart';
import '../models/booking_request.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

// Numéro WhatsApp centralisé KmerTour.
const String _kDiscoverCameroonWhatsApp = '+237655746714';

/// Ouvre la feuille de réservation pour un élément donné.
Future<void> showBookingSheet(
  BuildContext context, {
  required BookingType type,
  required String itemName,
  required String destinationName,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _BookingSheet(
      type: type,
      itemName: itemName,
      destinationName: destinationName,
    ),
  );
}

// ---------------------------------------------------------------------------
// Sheet principale (StatefulWidget — 3 étapes)
// ---------------------------------------------------------------------------

class _BookingSheet extends StatefulWidget {
  final BookingType type;
  final String itemName;
  final String destinationName;

  const _BookingSheet({
    required this.type,
    required this.itemName,
    required this.destinationName,
  });

  @override
  State<_BookingSheet> createState() => _BookingSheetState();
}

class _BookingSheetState extends State<_BookingSheet>
    with SingleTickerProviderStateMixin {
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();

  // Étape 1 — identité
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();

  // Étape 2 — dates
  DateTime _arrivalDate = DateTime.now().add(const Duration(days: 7));
  int _nights = 1;
  int _guests = 1;
  final _messageCtrl = TextEditingController();

  int _step = 0; // 0 = Qui, 1 = Quand, 2 = Confirmation

  late final AnimationController _slideCtrl;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _slideCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 350));
    _slideAnim = Tween<Offset>(
            begin: const Offset(1, 0), end: Offset.zero)
        .animate(CurvedAnimation(parent: _slideCtrl, curve: Curves.easeOut));
    _slideCtrl.forward();
  }

  @override
  void dispose() {
    _slideCtrl.dispose();
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _messageCtrl.dispose();
    super.dispose();
  }

  void _next() {
    final valid = _step == 0
        ? (_formKey1.currentState?.validate() ?? false)
        : (_formKey2.currentState?.validate() ?? false);
    if (!valid) return;
    _slideCtrl.reverse().then((_) {
      setState(() => _step++);
      _slideCtrl.forward();
    });
  }

  void _back() {
    _slideCtrl.reverse().then((_) {
      setState(() => _step--);
      _slideCtrl.forward();
    });
  }

  Future<void> _sendWhatsApp() async {
    final booking = BookingRequest(
      type: widget.type,
      itemName: widget.itemName,
      destinationName: widget.destinationName,
      guestName: _nameCtrl.text.trim(),
      guestPhone: _phoneCtrl.text.trim(),
      arrivalDate: _arrivalDate,
      nights: widget.type == BookingType.experience ? 0 : _nights,
      guests: _guests,
      message: _messageCtrl.text.trim().isEmpty
          ? null
          : _messageCtrl.text.trim(),
    );

    final launched = await AppLauncher.whatsapp(
      _kDiscoverCameroonWhatsApp,
      message: booking.toWhatsAppText(),
    );

    if (mounted) {
      if (launched) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white, size: 18),
                SizedBox(width: AppSpacing.sm),
                Text('Demande envoyée via WhatsApp !'),
              ],
            ),
            backgroundColor: AppColors.whatsapp,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.snackbar)),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('WhatsApp n\'est pas disponible sur cet appareil.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(
          AppSpacing.xl, AppSpacing.lg, AppSpacing.xl, AppSpacing.xl + bottomPad),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Poignée
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // En-tête
          _BookingHeader(
            type: widget.type,
            itemName: widget.itemName,
            destinationName: widget.destinationName,
            step: _step,
          ),

          const SizedBox(height: AppSpacing.xl),

          // Stepper visuel
          _StepIndicator(current: _step, total: 3),

          const SizedBox(height: AppSpacing.xl),

          // Contenu de l'étape animé
          SlideTransition(
            position: _slideAnim,
            child: _buildStep(),
          ),

          const SizedBox(height: AppSpacing.xl),

          // Boutons de navigation
          _buildNavButtons(),
        ],
      ),
    );
  }

  Widget _buildStep() {
    switch (_step) {
      case 0:
        return _StepWho(
          formKey: _formKey1,
          nameCtrl: _nameCtrl,
          phoneCtrl: _phoneCtrl,
        );
      case 1:
        return _StepWhen(
          type: widget.type,
          arrivalDate: _arrivalDate,
          nights: _nights,
          guests: _guests,
          messageCtrl: _messageCtrl,
          formKey: _formKey2,
          onDateChanged: (d) => setState(() => _arrivalDate = d),
          onNightsChanged: (n) => setState(() => _nights = n),
          onGuestsChanged: (g) => setState(() => _guests = g),
        );
      case 2:
        return _StepConfirm(
          type: widget.type,
          itemName: widget.itemName,
          destinationName: widget.destinationName,
          guestName: _nameCtrl.text,
          guestPhone: _phoneCtrl.text,
          arrivalDate: _arrivalDate,
          nights: _nights,
          guests: _guests,
          message: _messageCtrl.text,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildNavButtons() {
    if (_step == 0) {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: _next,
          icon: const Icon(Icons.arrow_forward, size: 18),
          label: const Text('Suivant'),
          style: _primaryButtonStyle,
        ),
      );
    } else if (_step == 1) {
      return Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: _back,
              style: _outlineButtonStyle,
              child: const Text('Retour'),
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            flex: 2,
            child: ElevatedButton.icon(
              onPressed: _next,
              icon: const Icon(Icons.arrow_forward, size: 18),
              label: const Text('Confirmer'),
              style: _primaryButtonStyle,
            ),
          ),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton.icon(
            onPressed: _sendWhatsApp,
            icon: const Icon(Icons.send, size: 18),
            label: const Text('Envoyer via WhatsApp'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.whatsapp,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.smPlus),
              shape: RoundedRectangleBorder(
                  borderRadius: AppRadius.buttonBorder),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          TextButton(
            onPressed: _back,
            child: const Text('← Modifier'),
          ),
        ],
      );
    }
  }

  ButtonStyle get _primaryButtonStyle => ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.smPlus),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.buttonBorder),
      );

  ButtonStyle get _outlineButtonStyle => OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: const BorderSide(color: AppColors.primary),
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.smPlus),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.buttonBorder),
      );
}

// ---------------------------------------------------------------------------
// En-tête de la sheet
// ---------------------------------------------------------------------------

class _BookingHeader extends StatelessWidget {
  final BookingType type;
  final String itemName;
  final String destinationName;
  final int step;

  const _BookingHeader({
    required this.type,
    required this.itemName,
    required this.destinationName,
    required this.step,
  });

  String get _title {
    switch (step) {
      case 0: return 'Vos coordonnées';
      case 1: return 'Dates & détails';
      default: return 'Confirmation';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md, vertical: AppSpacing.xs),
          decoration: BoxDecoration(
            color: AppColors.goldContainer,
            borderRadius: BorderRadius.circular(AppRadius.chip),
          ),
          child: Text(
            '${type.label} · $destinationName',
            style: AppTypography.chipLabel.copyWith(color: AppColors.onGoldContainer),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(itemName,
            style: AppTypography.headingMedium
                .copyWith(color: AppColors.textDark)),
        const SizedBox(height: AppSpacing.xxs),
        Text(_title,
            style: AppTypography.meta.copyWith(color: AppColors.primary)),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Indicateur d'étape (barres de progression)
// ---------------------------------------------------------------------------

class _StepIndicator extends StatelessWidget {
  final int current;
  final int total;

  const _StepIndicator({required this.current, required this.total});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(total, (i) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: i < total - 1 ? AppSpacing.sm : 0),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: 4,
              decoration: BoxDecoration(
                color: i <= current ? AppColors.primary : AppColors.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        );
      }),
    );
  }
}

// ---------------------------------------------------------------------------
// Étape 1 — Qui êtes-vous ?
// ---------------------------------------------------------------------------

class _StepWho extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameCtrl;
  final TextEditingController phoneCtrl;

  const _StepWho({
    required this.formKey,
    required this.nameCtrl,
    required this.phoneCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Vos informations',
              style: AppTypography.bodyText
                  .copyWith(fontWeight: FontWeight.w600, color: AppColors.textDark)),
          const SizedBox(height: AppSpacing.lg),
          TextFormField(
            controller: nameCtrl,
            textCapitalization: TextCapitalization.words,
            decoration: _inputDeco(
                hint: 'Votre nom complet', icon: Icons.person_outline),
            validator: (v) => (v == null || v.trim().isEmpty) ? 'Requis' : null,
          ),
          const SizedBox(height: AppSpacing.lg),
          TextFormField(
            controller: phoneCtrl,
            keyboardType: TextInputType.phone,
            decoration: _inputDeco(
                hint: 'Votre numéro (ex. +237 6…)', icon: Icons.phone_outlined),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              const Icon(Icons.lock_outline, size: 14, color: AppColors.textLight),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  'Vos données restent sur votre appareil. '
                  'Seul votre message WhatsApp est partagé.',
                  style: AppTypography.meta.copyWith(
                      fontSize: 11, color: AppColors.textLight),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Étape 2 — Quand / combien ?
// ---------------------------------------------------------------------------

class _StepWhen extends StatelessWidget {
  final BookingType type;
  final DateTime arrivalDate;
  final int nights;
  final int guests;
  final TextEditingController messageCtrl;
  final GlobalKey<FormState> formKey;
  final ValueChanged<DateTime> onDateChanged;
  final ValueChanged<int> onNightsChanged;
  final ValueChanged<int> onGuestsChanged;

  const _StepWhen({
    required this.type,
    required this.arrivalDate,
    required this.nights,
    required this.guests,
    required this.messageCtrl,
    required this.formKey,
    required this.onDateChanged,
    required this.onNightsChanged,
    required this.onGuestsChanged,
  });

  String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date d'arrivée
          _FieldLabel(label: "Date d'arrivée"),
          const SizedBox(height: AppSpacing.sm),
          InkWell(
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: arrivalDate,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365)),
                builder: (ctx, child) => Theme(
                  data: Theme.of(ctx).copyWith(
                    colorScheme: Theme.of(ctx).colorScheme.copyWith(
                          primary: AppColors.primary,
                          secondary: AppColors.gold,
                        ),
                  ),
                  child: child!,
                ),
              );
              if (picked != null) onDateChanged(picked);
            },
            borderRadius: AppRadius.inputBorder,
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg, vertical: AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: AppRadius.inputBorder,
                border: Border.all(color: AppColors.outline),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today_outlined,
                      size: 18, color: AppColors.primary),
                  const SizedBox(width: AppSpacing.md),
                  Text(_formatDate(arrivalDate),
                      style: AppTypography.bodyText
                          .copyWith(color: AppColors.textDark)),
                  const Spacer(),
                  const Icon(Icons.chevron_right,
                      size: 18, color: AppColors.textLight),
                ],
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          // Nuits (uniquement pour hébergement)
          if (type == BookingType.accommodation) ...[
            _FieldLabel(label: 'Nombre de nuits'),
            const SizedBox(height: AppSpacing.sm),
            _Counter(
              value: nights,
              min: 1,
              max: 30,
              onChanged: onNightsChanged,
              suffix: nights > 1 ? 'nuits' : 'nuit',
            ),
            const SizedBox(height: AppSpacing.lg),
          ],

          // Nombre de voyageurs
          _FieldLabel(label: 'Nombre de voyageurs'),
          const SizedBox(height: AppSpacing.sm),
          _Counter(
            value: guests,
            min: 1,
            max: 20,
            onChanged: onGuestsChanged,
            suffix: guests > 1 ? 'personnes' : 'personne',
          ),

          const SizedBox(height: AppSpacing.lg),

          // Message optionnel
          _FieldLabel(label: 'Message (optionnel)'),
          const SizedBox(height: AppSpacing.sm),
          TextFormField(
            controller: messageCtrl,
            maxLines: 3,
            maxLength: 300,
            textCapitalization: TextCapitalization.sentences,
            decoration: _inputDeco(
              hint: 'Questions, préférences particulières…',
              icon: Icons.chat_bubble_outline,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Étape 3 — Récapitulatif
// ---------------------------------------------------------------------------

class _StepConfirm extends StatelessWidget {
  final BookingType type;
  final String itemName;
  final String destinationName;
  final String guestName;
  final String guestPhone;
  final DateTime arrivalDate;
  final int nights;
  final int guests;
  final String message;

  const _StepConfirm({
    required this.type,
    required this.itemName,
    required this.destinationName,
    required this.guestName,
    required this.guestPhone,
    required this.arrivalDate,
    required this.nights,
    required this.guests,
    required this.message,
  });

  String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Carte récapitulatif
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: AppRadius.cardBorder,
            border: Border.all(color: AppColors.outlineVariant),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SummaryRow(icon: Icons.person_outline, label: 'Nom', value: guestName),
              if (guestPhone.isNotEmpty)
                _SummaryRow(icon: Icons.phone_outlined, label: 'Téléphone', value: guestPhone),
              _SummaryRow(icon: Icons.calendar_today_outlined,
                  label: 'Arrivée', value: _formatDate(arrivalDate)),
              if (type == BookingType.accommodation)
                _SummaryRow(icon: Icons.nights_stay_outlined,
                    label: 'Nuits', value: '$nights'),
              _SummaryRow(icon: Icons.group_outlined,
                  label: 'Voyageurs', value: '$guests'),
              if (message.isNotEmpty)
                _SummaryRow(icon: Icons.chat_bubble_outline,
                    label: 'Message', value: message),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.lg),

        // Avertissement WhatsApp
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.whatsappContainer,
            borderRadius: AppRadius.cardBorder,
            border: Border.all(color: AppColors.whatsapp.withValues(alpha: 0.4)),
          ),
          child: Row(
            children: [
              const Icon(Icons.chat, color: AppColors.whatsapp, size: 24),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  'En appuyant sur « Envoyer via WhatsApp », '
                  'votre message sera pré-rempli dans l\'application WhatsApp '
                  'vers notre équipe.',
                  style: AppTypography.meta.copyWith(
                      color: AppColors.onWhatsappContainer, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Widgets utilitaires internes
// ---------------------------------------------------------------------------

class _FieldLabel extends StatelessWidget {
  final String label;
  const _FieldLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: AppTypography.bodyText.copyWith(
          fontWeight: FontWeight.w600, color: AppColors.textDark),
    );
  }
}

class _Counter extends StatelessWidget {
  final int value;
  final int min;
  final int max;
  final String suffix;
  final ValueChanged<int> onChanged;

  const _Counter({
    required this.value,
    required this.min,
    required this.max,
    required this.suffix,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.inputBorder,
        border: Border.all(color: AppColors.outline),
      ),
      child: Row(
        children: [
          _CounterButton(
            icon: Icons.remove,
            onPressed: value > min ? () => onChanged(value - 1) : null,
          ),
          Expanded(
            child: Text(
              '$value $suffix',
              textAlign: TextAlign.center,
              style: AppTypography.bodyText
                  .copyWith(color: AppColors.textDark, fontWeight: FontWeight.w600),
            ),
          ),
          _CounterButton(
            icon: Icons.add,
            onPressed: value < max ? () => onChanged(value + 1) : null,
          ),
        ],
      ),
    );
  }
}

class _CounterButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;

  const _CounterButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon, size: 20),
      onPressed: onPressed,
      color: onPressed != null ? AppColors.primary : AppColors.outline,
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _SummaryRow(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: AppColors.primary),
          const SizedBox(width: AppSpacing.sm),
          SizedBox(
            width: 90,
            child: Text(label,
                style: AppTypography.meta
                    .copyWith(color: AppColors.textLight)),
          ),
          Expanded(
            child: Text(value,
                style: AppTypography.meta.copyWith(
                    color: AppColors.textDark, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Helpers de décoration
// ---------------------------------------------------------------------------

InputDecoration _inputDeco({required String hint, required IconData icon}) {
  return InputDecoration(
    hintText: hint,
    prefixIcon: Icon(icon, size: 18, color: AppColors.textLight),
    filled: true,
    fillColor: AppColors.surface,
    hintStyle: AppTypography.meta,
    contentPadding:
        const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
    border: OutlineInputBorder(
      borderRadius: AppRadius.inputBorder,
      borderSide: const BorderSide(color: AppColors.outline),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: AppRadius.inputBorder,
      borderSide: const BorderSide(color: AppColors.outline),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: AppRadius.inputBorder,
      borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: AppRadius.inputBorder,
      borderSide: const BorderSide(color: AppColors.danger),
    ),
  );
}
