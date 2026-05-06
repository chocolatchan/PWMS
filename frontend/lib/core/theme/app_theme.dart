import 'package:flutter/material.dart';

/// PWMS Material 3 Design System
/// GSP-compliant color palette derived from SOP V4.0 tote & zone colors
class AppTheme {
  AppTheme._();

  // ── Seed Color ─────────────────────────────────────────────
  static const Color _seed = Color(0xFF0F6FD7); // Deep pharma blue

  // ── Zone Accent Colors (matches SOP tote color spec) ───────
  static const Color zoneGreen = Color(0xFF1A8A3C); // Z-AVL / Green Tote
  static const Color zoneYellow = Color(0xFFCA8A04); // Z-QRN / Yellow Tote
  static const Color zoneRed = Color(0xFFDC2626); // Z-TOX / Red Tote
  static const Color zonePurple = Color(0xFF7C3AED); // Z-RET / Purple Tote
  static const Color zoneBlue = Color(0xFF0F6FD7); // Z-CLD
  static const Color zoneOrange = Color(0xFFEA580C); // Z-LAS
  static const Color zoneBlack = Color(0xFF1C1917); // Z-REJ / Black Tote

  // ── Status Colors ──────────────────────────────────────────
  static const Color statusDraft = Color(0xFF64748B);
  static const Color statusPendingQc = Color(0xFFCA8A04);
  static const Color statusCompleted = Color(0xFF1A8A3C);
  static const Color statusRecalled = Color(0xFFDC2626);
  static const Color statusColdBreach = Color(0xFF0284C7);

  // ── Light Theme ────────────────────────────────────────────
  static ThemeData lightTheme() {
    final scheme =
        ColorScheme.fromSeed(
          seedColor: _seed,
          brightness: Brightness.light,
        ).copyWith(
          primary: _seed,
          onPrimary: Colors.white,
          secondary: const Color(0xFF0EA5E9),
          tertiary: zoneGreen,
          error: zoneRed,
        );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      fontFamily: 'RobotoMono', // Mono for barcode/number readability on PDA
      visualDensity: VisualDensity.compact,
      scaffoldBackgroundColor: const Color(0xFFF1F5F9),

      // ── AppBar ──
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: const TextStyle(
          fontFamily: 'RobotoMono',
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          letterSpacing: 0.5,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      // ── Cards ──
      cardTheme: const CardThemeData(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        color: Colors.white,
        margin: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        clipBehavior: Clip.antiAlias,
      ),

      // ── Input Fields ──
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: scheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: scheme.error),
        ),
        labelStyle: TextStyle(color: scheme.onSurfaceVariant, fontSize: 14),
        prefixIconColor: WidgetStateColor.resolveWith(
          (states) => states.contains(WidgetState.focused)
              ? scheme.primary
              : scheme.onSurfaceVariant,
        ),
      ),

      // ── Buttons ──
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
          ),
          elevation: 2,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      // ── FloatingActionButton ──
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),

      // ── ListTile ──
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        minVerticalPadding: 12,
      ),

      // ── Chips ──
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      ),

      // ── Divider ──
      dividerTheme: const DividerThemeData(space: 0, thickness: 1),

      // ── Dialog ──
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 8,
      ),

      // ── SnackBar ──
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  // ── Dark Theme (for low-light warehouse environments) ──────
  static ThemeData darkTheme() {
    final scheme =
        ColorScheme.fromSeed(
          seedColor: _seed,
          brightness: Brightness.dark,
        ).copyWith(
          primary: const Color(0xFF60A5FA),
          tertiary: const Color(0xFF4ADE80),
        );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      fontFamily: 'RobotoMono',
      visualDensity: VisualDensity.compact,
      scaffoldBackgroundColor: const Color(0xFF0F172A),
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFF1E293B),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: const TextStyle(
          fontFamily: 'RobotoMono',
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          letterSpacing: 0.5,
        ),
      ),
      cardTheme: const CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        color: Color(0xFF1E293B),
        margin: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      ),
    );
  }

  // ── Tote Color Helper ─────────────────────────────────────
  static Color toteColor(String color) {
    switch (color.toUpperCase()) {
      case 'RED':
        return zoneRed;
      case 'YELLOW':
        return zoneYellow;
      case 'PURPLE':
        return zonePurple;
      case 'BLACK':
        return zoneBlack;
      case 'GREEN':
      default:
        return zoneGreen;
    }
  }

  static String toteName(String color) {
    switch (color.toUpperCase()) {
      case 'RED':
        return 'ĐỎ — Kiểm soát đặc biệt';
      case 'YELLOW':
        return 'VÀNG — Biệt trữ QA';
      case 'PURPLE':
        return 'TÍM — Hàng trả về';
      case 'BLACK':
        return 'ĐEN — Loại / Thu hồi';
      case 'GREEN':
      default:
        return 'XANH — Nhập kho thường';
    }
  }

  static Color statusColor(String status) {
    switch (status.toUpperCase()) {
      case 'DRAFT':
        return statusDraft;
      case 'INBOUND_PENDING':
        return zoneBlue;
      case 'PENDING_QC':
        return statusPendingQc;
      case 'QUARANTINE':
        return zoneYellow;
      case 'COMPLETED':
        return statusCompleted;
      case 'RECALLED':
        return statusRecalled;
      case 'COLD_BREACH_QUARANTINE':
        return statusColdBreach;
      case 'TOXIC_INBOUND':
        return zoneRed;
      case 'RETURNED_QUARANTINE':
        return zonePurple;
      case 'REJECTED':
        return zoneBlack;
      default:
        return statusDraft;
    }
  }
}
