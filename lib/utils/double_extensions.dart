import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:shopizy/settings/storage_keys.dart';

extension DoubleExtensions on double {
  String currencyFormat({bool withSymbol = true}) {
    final value = new NumberFormat("#,##0", "en_US");
    String currencySymbol = GetStorage().read(StorageKeys.language) == 'en' ? 'IQD' : 'د.ع.';
    return '${withSymbol ? currencySymbol : ''} ${value.format(int.parse(this.toStringAsFixed(0)))}';
  }
}
