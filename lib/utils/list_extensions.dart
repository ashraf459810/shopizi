import 'package:shopizy/ui/enum/list_item_location.dart';

extension ListExtensions on List {
  ListItemLocation getItemLocation(int index) {
    if (index == 0)
      return ListItemLocation.first;
    else if (index == length - 1)
      return ListItemLocation.last;
    else
      return ListItemLocation.middle;
  }
}
