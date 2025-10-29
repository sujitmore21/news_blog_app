import 'package:flutter/material.dart';

/// Profile section widget
class ProfileSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const ProfileSection({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            title,
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 13,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF2A2A2A),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF3A3A3A), width: 1),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}

/// Profile item widget
class ProfileItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;
  final Color? iconColor;
  final Color? titleColor;
  final Widget? trailing;

  const ProfileItem({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
    this.iconColor,
    this.titleColor,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final isClickable = onTap != null;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: const Color(0xFF3A3A3A), width: 0.5),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: iconColor ?? const Color(0xFF2196F3), size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: titleColor ?? Colors.white,
                  fontSize: 15,
                  fontWeight: isClickable ? FontWeight.w500 : FontWeight.normal,
                ),
              ),
            ),
            if (trailing != null) ...[
              const SizedBox(width: 8),
              trailing!,
            ] else if (isClickable) ...[
              Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[600]),
            ],
          ],
        ),
      ),
    );
  }
}
