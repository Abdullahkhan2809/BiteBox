import 'package:flutter/material.dart';

abstract final class BBColors {
  BBColors._();

  // ── 60% — Dominant ────────────────────────────────────────────────────────
  static const Color bg       = Color(0xFF0A0A0F);
  static const Color border   = Color(0x12FFFFFF);
  static const Color hintText = Color(0xFF4D4C4C);

  // ── 30% — Secondary ───────────────────────────────────────────────────────
  static const Color surface  = Color(0xFF1C1C24);
  static const Color surface2 = Color(0xFF221F1F);
  static const Color muted    = Color(0x91FFFFFF);

  // ── 10% — Accent (CTAs & brand moments only) ──────────────────────────────
  static const Color red      = Color(0xFFE51904);
  static const Color darkRed  = Color(0xFF7D0A0A);
  static const Color redMuted = Color(0x80FF0000);

  // ── Semantic (functional meaning only — not for layout/decoration) ─────────
  static const Color green    = Color(0xFF30D158);
  static const Color amber    = Color(0xFFEF9F27);
  static const Color blue     = Color(0xFF378ADD);

  // ── Semantic tints (badge & toast backgrounds) ────────────────────────────
  static const Color greenTint = Color(0x1A30D158);
  static const Color amberTint = Color(0x1AEF9F27);
  static const Color blueTint  = Color(0x1A378ADD);
  static const Color redTint   = Color(0x1AE51904);
}