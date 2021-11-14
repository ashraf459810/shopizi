class PaymentOption {
  final int id;
  final String title;
  final bool isSelected;
  final bool isActive;

  PaymentOption({
    this.id,
    this.title,
    this.isSelected,
    this.isActive,
  });

  factory PaymentOption.fromJson(Map<String, dynamic> data) {
    return PaymentOption(
      isActive: data["isActive"],
      isSelected: data["isSelected"],
      id: data['id'],
      title: data['title'],
    );
  }
}
