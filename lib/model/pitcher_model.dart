// ignore_for_file: file_names, non_constant_identifier_names

class PitcherModel {
  final String email;
  final String productsid;
  final String username;
  final String whatisyourbusinessinonesentence;
  final String product_name;
  final String problem_solved;
  final String pdf_file;
  final String video_file;
  final List<String> image_url;
  final List likes;
  final String specificsolutionController;
  final String howmuchrevenuethisyear;
  final String whyareyoutherightperson;
  final dynamic timestamp;

  PitcherModel({
    required this.username,
    required this.image_url,
    required this.pdf_file,
    required this.problem_solved,
    required this.product_name,
    required this.video_file,
    required this.email,
    required this.productsid,
    required this.likes,
    required this.timestamp,
    required this.howmuchrevenuethisyear,
    required this.specificsolutionController,
    required this.whatisyourbusinessinonesentence,
    required this.whyareyoutherightperson,
  });

  // Serialize the UserModel instance to a JSON map
  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'image_url': image_url,
      'pdf_file': pdf_file,
      'problem_solved': problem_solved,
      'product_name': product_name,
      'video_file': video_file,
      'email': email,
      'productsid': productsid,
      'likes': likes,
      'howmuchrevenuethisyear': howmuchrevenuethisyear,
      'specificsolutionController': specificsolutionController,
      'whatisyourbusinessinonesentence': whatisyourbusinessinonesentence,
      'whyareyoutherightperson': whyareyoutherightperson,
      'timestamp': timestamp,
    };
  }

  // Create a UserModel instance from a JSON map
  factory PitcherModel.fromMap(Map<String, dynamic> json) {
    List<String> imageUrls = [];
    if (json['image_url'] is String) {
      imageUrls = [json['image_url']];
    } else if (json['image_url'] is List) {
      imageUrls = List<String>.from(json['image_url']);
    }

    return PitcherModel(
      username: json['username'],
      image_url: imageUrls,
      pdf_file: json['pdf_file'],
      problem_solved: json['problem_solved'],
      product_name: json['product_name'],
      video_file: json['video_file'],
      email: json['email'],
      productsid: json['productsid'],
      likes: json['likes'],
      timestamp: json['timestamp'],
      howmuchrevenuethisyear: json['howmuchrevenuethisyear'],
      specificsolutionController: json['specificsolutionController'],
      whatisyourbusinessinonesentence: json['whatisyourbusinessinonesentence'],
      whyareyoutherightperson: json['whyareyoutherightperson'],
    );
  }
}
