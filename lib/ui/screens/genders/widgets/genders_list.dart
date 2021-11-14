import 'package:flutter/material.dart';
import 'package:shopizy/main.dart';
import 'package:shopizy/models/gender.dart';
import 'package:shopizy/ui/theme/app_colors.dart';
import 'package:shopizy/ui/theme/app_shapes.dart';

class GendersList extends StatelessWidget {
  final List<Gender> genders;
  final Function(Gender) onGenderSelected;
  final int selectedGenderId;
  final double iconSize;

  GendersList(this.genders, this.onGenderSelected, this.selectedGenderId, {this.iconSize = 100});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ...genders.map((e) => gender(e, selectedGenderId == e.id)),
      ],
    );
  }

  gender(Gender gender, bool isSelected) => Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6.0),
          child: InkWell(
            onTap: () {
              // Save selected gender
              onGenderSelected(gender);
            },
            borderRadius: BorderRadius.circular(12),
            highlightColor: appTheme.colors.orange.withOpacity(0.7),
            child: Container(
              decoration: AppShapes.roundedRectDecoration(
                color: isSelected ? AppColors.PRIMARY_COLOR.withOpacity(0.2) : Colors.transparent,
                borderColor: appTheme.colors.orange.withOpacity(0.5),
                radius: 12,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                children: [
                  Image.asset(gender.icon, width: iconSize),
                  SizedBox(height: 12),
                  Text(gender.title, style: appTheme.textStyles.subtitle4.copyWith(fontWeight: appTheme.textStyles.medium)),
                ],
              ),
            ),
          ),
        ),
      );
}
