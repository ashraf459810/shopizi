class Language {
  String key;
  String title;
  String helpText;
  String flag;

  Language({this.key, this.title, this.helpText, this.flag});

  factory Language.fromJson(Map<String, dynamic> data) {
    return Language(
      key: data['key'],
      title: data['title'],
      helpText: data['helpText'],
      flag: 'assets/images/${data['key']}.png',
    );
  }
}
