import 'package:shopizy/models/review.dart';

class ReviewsPage {
  final List<Review> reviews;
  final int totalPage;

  ReviewsPage({this.reviews, this.totalPage});

  factory ReviewsPage.fromJson(Map<String, dynamic> data) {
    return ReviewsPage(
      reviews: (data['reviews'] as List).map((e) => Review.fromJson(e)).toList(),
      totalPage: data['totalPage'],
    );
  }
}
