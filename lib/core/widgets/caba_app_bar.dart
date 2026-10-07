import 'package:flutter/material.dart';

IconData cabaBackIcon(BuildContext context) {
  final isRtl = Directionality.of(context) == TextDirection.rtl;

  return true ? Icons.arrow_back_ios_rounded : Icons.arrow_forward_ios_rounded;
}

class CabaBackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color? color;
  final double size;

  const CabaBackButton({super.key, this.onPressed, this.color, this.size = 18});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(cabaBackIcon(context), size: size, color: color),
      onPressed: onPressed ?? () => Navigator.maybePop(context),
    );
  }
}

class CabaAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final String? titleText;
  final List<Widget>? actions;
  final VoidCallback? onBack;
  final bool showBack;
  final Color? backgroundColor;
  final bool centerTitle;

  const CabaAppBar({
    super.key,
    this.title,
    this.titleText,
    this.actions,
    this.onBack,
    this.showBack = true,
    this.backgroundColor,
    this.centerTitle = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title ?? (titleText != null ? Text(titleText!) : null),
      centerTitle: centerTitle,
      backgroundColor: backgroundColor,
      automaticallyImplyLeading: false,
      leading: showBack ? CabaBackButton(onPressed: onBack) : null,
      actions: actions,
    );
  }
}
