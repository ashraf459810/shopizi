import 'package:intl/intl.dart';

class Review {
  final String customer;
  final String review;
  final int rate;
  final String createdOn;

  Review({this.customer, this.review, this.rate, this.createdOn});

  factory Review.fromJson(Map<String, dynamic> data) {
    return Review(
      customer: data['customer'],
      review: data['review'],
      rate: data['rate'],
      createdOn: DateFormat('MMM dd, yyyy  hh:mm:ss a').format(DateFormat('yyyy-MM-ddTHH:mm:ss').parse(data['createdOn'], true)),
    );
  }
}
