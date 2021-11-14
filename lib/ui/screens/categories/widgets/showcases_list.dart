import 'package:flutter/material.dart';
import 'package:shopizy/models/showcase.dart';

import 'showcases_list_item.dart';

class ShowcasesList extends StatelessWidget {
  final List<Showcase> showcases;
  final int selectedShowcaseId;
  final Function(Showcase) onShowcaseSelected;

  ShowcasesList({this.showcases, this.selectedShowcaseId, this.onShowcaseSelected});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: showcases.length,
      itemBuilder: (ctx, index) {
        return ShowcasesListItem(
          showcases[index],
          selectedShowcaseId == showcases[index].id,
          onShowcaseSelected,
        );
      },
    );
  }
}
