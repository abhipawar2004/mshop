class ProductReviewModel {
  bool success;
  String message;
  ProductReviewData data;

  ProductReviewModel({
    this.success = false,
    this.message = '',
    ProductReviewData? data,
  }) : data = data ?? ProductReviewData();

  ProductReviewModel.fromJson(Map<String, dynamic> json)
      : success = json['success'] ?? false,
        message = json['message'] ?? '',
        data = json['data'] != null
            ? ProductReviewData.fromJson(json['data'])
            : ProductReviewData();

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.toJson(),
    };
  }
}

class ProductReviewData {
  int currentPage;
  int lastPage;
  int perPage;
  int total;
  ReviewData data;

  ProductReviewData({
    this.currentPage = 1,
    this.lastPage = 1,
    this.perPage = 10,
    this.total = 0,
    ReviewData? data,
  }) : data = data ?? ReviewData();

  ProductReviewData.fromJson(Map<String, dynamic> json)
      : currentPage = json['current_page'] ?? 1,
        lastPage = json['last_page'] ?? 1,
        perPage = json['per_page'] ?? 10,
        total = json['total'] ?? 0,
        data = json['data'] != null
            ? ReviewData.fromJson(json['data'])
            : ReviewData();

  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'last_page': lastPage,
      'per_page': perPage,
      'total': total,
      'data': data.toJson(),
    };
  }
}

class ReviewData {
  int totalReviews;
  String averageRating;
  RatingsBreakdown ratingsBreakdown;
  List<Reviews> reviews;

  ReviewData({
    this.totalReviews = 0,
    this.averageRating = '0.0',
    RatingsBreakdown? ratingsBreakdown,
    List<Reviews>? reviews,
  }) : ratingsBreakdown = ratingsBreakdown ?? RatingsBreakdown(),
        reviews = reviews ?? [];

  ReviewData.fromJson(Map<String, dynamic> json)
      : totalReviews = json['total_reviews'] ?? 0,
        averageRating = json['average_rating']?.toString() ?? '0.0',
        ratingsBreakdown = json['ratings_breakdown'] != null
            ? RatingsBreakdown.fromJson(json['ratings_breakdown'])
            : RatingsBreakdown(),
        reviews = json['reviews'] != null
            ? (json['reviews'] as List).map((v) => Reviews.fromJson(v)).toList()
            : [];

  Map<String, dynamic> toJson() {
    return {
      'total_reviews': totalReviews,
      'average_rating': averageRating,
      'ratings_breakdown': ratingsBreakdown.toJson(),
      'reviews': reviews.map((v) => v.toJson()).toList(),
    };
  }
}

class RatingsBreakdown {
  String star1;
  String star2;
  String star3;
  String star4;
  String star5;

  RatingsBreakdown({
    this.star1 = '0',
    this.star2 = '0',
    this.star3 = '0',
    this.star4 = '0',
    this.star5 = '0',
  });

  RatingsBreakdown.fromJson(Map<String, dynamic> json)
      : star1 = json['1_star']?.toString() ?? '0',
        star2 = json['2_star']?.toString() ?? '0',
        star3 = json['3_star']?.toString() ?? '0',
        star4 = json['4_star']?.toString() ?? '0',
        star5 = json['5_star']?.toString() ?? '0';

  Map<String, dynamic> toJson() {
    return {
      '1_star': star1,
      '2_star': star2,
      '3_star': star3,
      '4_star': star4,
      '5_star': star5,
    };
  }
}

class Reviews {
  int id;
  int productId;
  int rating;
  String title;
  String slug;
  String comment;
  List<String> reviewImages;
  User user;
  String createdAt;

  Reviews({
    this.id = 0,
    this.productId = 0,
    this.rating = 0,
    this.title = '',
    this.slug = '',
    this.comment = '',
    List<String>? reviewImages,
    User? user,
    this.createdAt = '',
  }) : reviewImages = reviewImages ?? [],
        user = user ?? User();

  Reviews.fromJson(Map<String, dynamic> json)
      : id = json['id'] ?? 0,
        productId = json['product_id'] ?? 0,
        rating = json['rating'] ?? 0,
        title = json['title'] ?? '',
        slug = json['slug'] ?? '',
        comment = json['comment'] ?? '',
        reviewImages = json['review_images'] != null
            ? List<String>.from(json['review_images'])
            : [],
        user = json['user'] != null
            ? User.fromJson(json['user'])
            : User(),
        createdAt = json['created_at'] ?? '';

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'rating': rating,
      'title': title,
      'slug': slug,
      'comment': comment,
      'review_images': reviewImages,
      'user': user.toJson(),
      'created_at': createdAt,
    };
  }
}

class User {
  int id;
  String name;

  User({
    this.id = 0,
    this.name = '',
  });

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'] ?? 0,
        name = json['name'] ?? '';

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
