class ReviewModel {
  final String username;
  final String userid;
  final String feedback;
  final dynamic createdAt;
  final String rating;

  ReviewModel({
    required this.createdAt,
    required this.feedback,
    required this.userid,
    required this.username,
    required this.rating
  });
  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'userid': userid,
      'feedback': feedback,
      'createdAt': createdAt,
      'rating':rating,
    };
  }

  factory ReviewModel.fromMap(Map<String, dynamic> json) {
    return ReviewModel(
      username: json['username'],
      userid: json['userid'],
      feedback: json['feedback'],
      createdAt: json['createdAt'],
      rating: json['rating']
    );
  }
}
