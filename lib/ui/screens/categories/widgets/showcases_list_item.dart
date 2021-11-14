import 'package:flutter/material.dart';
import 'package:shopizy/main.dart';
import 'package:shopizy/models/showcase.dart';

class ShowcasesListItem extends StatelessWidget {
  final Showcase showcase;
  final bool isSelected;
  final Function(Showcase) onShowcaseSelected;

  ShowcasesListItem(this.showcase, this.isSelected, this.onShowcaseSelected);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onShowcaseSelected(showcase),
      child: Container(
        height: 80,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey[300].withOpacity(0.8))),
          color: isSelected ? Colors.white38 : Colors.grey[100],
        ),
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        child: Text(
          showcase.name,
          style: appTheme.textStyles.subtitle3.copyWith(color: isSelected ? appTheme.colors.orange : Colors.grey[500]),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
