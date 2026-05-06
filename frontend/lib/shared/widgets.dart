import 'package:flutter/material.dart';
import 'package:pwms_frontend/core/theme/app_theme.dart';

// ═══════════════════════════════════════════════════════════
// StatusBadge — M3 chip for inventory/receipt status
// ═══════════════════════════════════════════════════════════
class StatusBadge extends StatelessWidget {
  final String status;
  final double fontSize;

  const StatusBadge(this.status, {super.key, this.fontSize = 11});

  static String _label(String s) {
    const map = {
      'DRAFT': 'Nháp',
      'INBOUND_PENDING': 'Chờ nhập',
      'PENDING_QC': 'Chờ QA',
      'QUARANTINE': 'Biệt trữ',
      'COMPLETED': 'Hoàn tất',
      'RECALLED': 'Thu hồi',
      'COLD_BREACH_QUARANTINE': 'Vi phạm nhiệt',
      'TOXIC_INBOUND': 'Kiểm soát',
      'RETURNED_QUARANTINE': 'Trả về',
      'REJECTED': 'Loại',
      'RELEASED': 'Đã duyệt',
      'AVAILABLE': 'Có sẵn',
      'SHIPPED': 'Đã xuất',
      'PICKING': 'Đang nhặt',
      'PACKING': 'Đang đóng gói',
    };
    return map[s.toUpperCase()] ?? s;
  }

  @override
  Widget build(BuildContext context) {
    final color = AppTheme.statusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.5), width: 1),
      ),
      child: Text(
        _label(status),
        style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// ToteBanner — Color-coded banner for tote classification
// ═══════════════════════════════════════════════════════════
class ToteBanner extends StatelessWidget {
  final String toteColor;

  const ToteBanner(this.toteColor, {super.key});

  @override
  Widget build(BuildContext context) {
    final color = AppTheme.toteColor(toteColor);
    final name = AppTheme.toteName(toteColor);
    return Material(
      color: color.withValues(alpha: 0.1),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            Container(
              width: 20, height: 20,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 12),
            Text(
              'Rổ $name',
              style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// SectionHeader — M3 labelled section
// ═══════════════════════════════════════════════════════════
class SectionHeader extends StatelessWidget {
  final String title;
  final Widget? trailing;

  const SectionHeader(this.title, {super.key, this.trailing});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title.toUpperCase(),
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
                color: cs.primary,
              ),
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// InfoRow — Key-value row for detail views
// ═══════════════════════════════════════════════════════════
class InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icon;
  final bool mono;

  const InfoRow({
    super.key,
    required this.label,
    required this.value,
    this.icon,
    this.mono = false,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16, color: cs.onSurfaceVariant),
            const SizedBox(width: 8),
          ],
          SizedBox(
            width: 120,
            child: Text(label, style: TextStyle(fontSize: 13, color: cs.onSurfaceVariant)),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                fontFamily: mono ? 'RobotoMono' : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// ScanPlaceholder — Animated scan prompt
// ═══════════════════════════════════════════════════════════
class ScanPlaceholder extends StatefulWidget {
  final String message;
  final IconData icon;

  const ScanPlaceholder({
    super.key,
    required this.message,
    this.icon = Icons.qr_code_scanner,
  });

  @override
  State<ScanPlaceholder> createState() => _ScanPlaceholderState();
}

class _ScanPlaceholderState extends State<ScanPlaceholder>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))..repeat(reverse: true);
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FadeTransition(
              opacity: _fade,
              child: Container(
                width: 120, height: 120,
                decoration: BoxDecoration(
                  color: cs.primaryContainer.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Icon(widget.icon, size: 64, color: cs.primary),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              widget.message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: cs.onSurfaceVariant,
                letterSpacing: 0.5,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// AlertBanner — Prominent error / warning bar
// ═══════════════════════════════════════════════════════════
class AlertBanner extends StatelessWidget {
  final String message;
  final Color? color;
  final IconData icon;

  const AlertBanner({
    super.key,
    required this.message,
    this.color,
    this.icon = Icons.warning_amber_rounded,
  });

  @override
  Widget build(BuildContext context) {
    final c = color ?? Theme.of(context).colorScheme.error;
    return Material(
      color: c.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: c, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: TextStyle(color: c, fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// PdaProgressBar — GSP-styled progress bar with count
// ═══════════════════════════════════════════════════════════
class PdaProgressBar extends StatelessWidget {
  final int current;
  final int total;
  final String label;

  const PdaProgressBar({
    super.key,
    required this.current,
    required this.total,
    this.label = 'Tiến độ',
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final progress = total == 0 ? 0.0 : current / total;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: cs.surfaceContainerHighest.withValues(alpha: 0.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: TextStyle(fontSize: 12, color: cs.onSurfaceVariant, fontWeight: FontWeight.w600)),
              Text('$current / $total', style: TextStyle(fontSize: 12, color: cs.primary, fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: cs.surfaceContainerHighest,
            ),
          ),
        ],
      ),
    );
  }
}
