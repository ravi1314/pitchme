import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:pitchme/service/genretId.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pitchme/model/Review_Model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pitchme/model/pitcher_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class AddReviewBar extends StatefulWidget {
  final PitcherModel pitcherModel;
  const AddReviewBar({super.key, required this.pitcherModel});

  @override
  State<AddReviewBar> createState() => _AddReviewBarState();
}

class _AddReviewBarState extends State<AddReviewBar> {
  final TextEditingController feedBackController = TextEditingController();
  double postRating = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(),
      body: Container(
        margin: const EdgeInsets.all(13),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Add Your Rating and Review",
              style: GoogleFonts.play(textStyle: const TextStyle(fontSize: 19)),
            ),
            const SizedBox(
              height: 20,
            ),
            RatingBar.builder(
              initialRating: 0,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                postRating = rating;
                print(postRating);
                setState(() {});
              },
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: feedBackController,
              decoration: const InputDecoration(
                labelText: "Give your Feedback",
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Center(
              child: GestureDetector(
                onTap: () async {
                  final User? user = FirebaseAuth.instance.currentUser;

                  String feedback = feedBackController.text.trim();
                  // print(postRating);
                  // print(feedback);
                  ReviewModel reviewModel = ReviewModel(
                      createdAt: DateTime.now(),
                      feedback: feedback,
                      userid: user!.uid,
                      username: user.displayName.toString(),
                      rating: postRating.toString());
                  String reviewId =
                      await GenerateReviewIds().generateReviewId();

                  await FirebaseFirestore.instance
                      .collection('PitchList')
                      .doc(widget.pitcherModel.productsid)
                      .collection('Review')
                      .doc(user.uid)
                      .set(reviewModel.toMap());
                  print("store data");
                  Get.snackbar(
                      backgroundColor: Colors.black,
                      "Feedback Submit",
                      "Thank you for your Feedback",
                      colorText: Colors.white);
                },
                child: Container(
                  height: 50,
                  width: 190,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade400,
                          offset: const Offset(10, 10),
                          blurRadius: 8,
                        ),
                        const BoxShadow(
                          color: Colors.white,
                          offset: Offset(-5, -5),
                          blurRadius: 8,
                        ),
                      ]),
                  child: Center(
                    child: Text(
                      "Send Your Feedback",
                      style: GoogleFonts.play(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
