import 'package:uuid/uuid.dart';

class GenerateIds {
  String generateProductId() {
    String formatedProductsId;
    String uuid = Uuid().v4();

    //customize id

    formatedProductsId = "PitchMe--${uuid.substring(0, 5)}";

    //return

    return formatedProductsId;
  }
}
class GenerateReviewIds {
  String generateReviewId() {
    String formatedReviewtsId;
    String uuid = Uuid().v4();

    //customize id

    formatedReviewtsId = "Review--${uuid.substring(0, 5)}";

    //return

    return formatedReviewtsId;
  }
}
