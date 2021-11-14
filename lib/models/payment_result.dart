class PaymentResult {
  final int orderId;
  final String message;
  final String redirectUrl;

  PaymentResult({this.orderId, this.message, this.redirectUrl});

  factory PaymentResult.fromJson(Map<String, dynamic> data) {
    return PaymentResult(
      orderId: data['orderId'],
      message: data['message'],
      redirectUrl: data['redirectUrl'],
    );
  }
}
