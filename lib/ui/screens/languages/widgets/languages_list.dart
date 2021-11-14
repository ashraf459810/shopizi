import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shopizy/models/language.dart';
import 'package:shopizy/settings/storage_keys.dart';

import 'languages_list_item.dart';

class LanguagesList extends StatelessWidget {
  final List<Language> languages;
  final Function(Language) onLanguageSelected;
  final bool showHelpText;
  final bool showFlag;
  final String showLoadingFor;

  LanguagesList({this.languages, this.onLanguageSelected, this.showHelpText, this.showFlag = true, this.showLoadingFor});

  @override
  Widget build(BuildContext context) {
    String selectedLanguageCode = GetStorage().read(StorageKeys.language);
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: languages.length,
      itemBuilder: (ctx, index) => LanguagesListItem(
          language: languages[index],
          isSelected: languages[index].key == selectedLanguageCode,
          onLanguageSelected: onLanguageSelected,
          showHelpText: showHelpText,
          showLoading: showLoadingFor == languages[index].key),
    );
  }
}
