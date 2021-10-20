import 'package:app_pde/app/shared/utlis/app_colors.dart';
import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final Widget? leading;
  final Widget icon;
  final void Function()? onTap;
  final EdgeInsets? contentPadding;

  const CustomListTile({
    Key? key,
    this.title = '',
    this.subtitle,
    this.trailing,
    this.leading,
    this.onTap,
    required this.icon,
    this.contentPadding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      horizontalTitleGap: 24,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 6,
      ),
      title: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 4,
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkGrey)),
                            const SizedBox(height: 3),
                    subtitle != null
                        ? Text(subtitle!,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ))
                        : Container()
                  ],
                ),
              ),
            ),
            Flexible(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [icon],
                ),
              ),
            )
          ],
        ),
      ),
      leading: leading,
      trailing: trailing,
      onTap: onTap,
    );
  }
}
