import 'package:app_pde/app/shared/utlis/app_colors.dart';
import 'package:flutter/material.dart';

class CustomInfoMapItem extends StatelessWidget {
  final MapEntry<String, dynamic> e;

  const CustomInfoMapItem(this.e, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Text(
            e.key,
            style: const TextStyle(color: AppColors.grey, fontSize: 16),
          ),
          const Spacer(),
          Expanded(
            flex: 4,
            child: Text(
              e.value,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.end,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
