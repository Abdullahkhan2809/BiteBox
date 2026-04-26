import 'package:flutter/material.dart';
import 'colors.dart';

class BBBottomNavBar extends StatelessWidget {
  final int activeIndex;
  final ValueChanged<int> onTap;
  final VoidCallback? onFabTap;

  const BBBottomNavBar({
    super.key,
    required this.activeIndex,
    required this.onTap,
    this.onFabTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(35)),
      child: BottomAppBar(

        color: BBColors.darkRed,
        shape: const CircularNotchedRectangle(),
        notchMargin: 6,
        clipBehavior: Clip.antiAlias,
        padding: EdgeInsets.zero,
        child: SizedBox(
          height: 80,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // LEFT
                _NavIcon(
                  icon: Icons.dashboard_rounded,
                  label: 'Dashboard',
                  isActive: activeIndex == 0,
                  onTap: () => onTap(0),
                ),
                _NavIcon(
                  icon: Icons.menu_book_rounded,
                  label: 'Menu',
                  isActive: activeIndex == 1,
                  onTap: () => onTap(1),
                ),
      
                // Centre gap for notch
                const SizedBox(width: 64),
      
                // RIGHT
                _NavIcon(
                  icon: Icons.receipt_long_rounded,
                  label: 'Orders',
                  isActive: activeIndex == 2,
                  onTap: () => onTap(2),
                ),
                _NavIcon(
                  icon: Icons.person_outline_rounded,
                  label: 'Profile',
                  isActive: activeIndex == 3,
                  onTap: () => onTap(3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Single nav icon ─────────────────────────────────────────────────────────

class _NavIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavIcon({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 25,
              color: isActive ? BBColors.red : BBColors.muted,
            ),
            const SizedBox(height: 2),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: isActive ? 14 : 0,
              height: 2,
              decoration: BoxDecoration(
                color: BBColors.red,
                borderRadius: BorderRadius.circular(99),
              ),
            ),
          ],
        ),
      ),
    );
  }
}