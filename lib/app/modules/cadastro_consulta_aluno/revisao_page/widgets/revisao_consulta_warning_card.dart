import 'package:app_pde/app/shared/utlis/app_colors.dart';
import 'package:app_pde/app/shared/widgets/custom_card.dart';
import 'package:flutter/material.dart';

class RevisaoConsultaWarningCard extends StatelessWidget {
  const RevisaoConsultaWarningCard({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      padding: const EdgeInsets.all(24),
      color: AppColors.accentLight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'IMPORTANTE',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
              color: AppColors.darkGrey,
            ),
          ),
          const SizedBox(height: 12),
          RichText(
            text: const TextSpan(
              style: TextStyle(color: AppColors.accentDark),
              children: const [
                TextSpan(text: "A consulta requisitada será avaliada por um de nossos consultores, "
                "qualquer dúvida entre em contato através de uma de nossas plataformas de comunicação."),
              ],
            ),
          ),
        ],
      ),
    );
  }
}