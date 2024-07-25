import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_card/image_card.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pitchme/screen/videoplayer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pitchme/model/pitcher_model.dart';
import 'package:pitchme/screen/pdfviewscreen.dart';
import 'package:pitchme/utiles/banner_screen.dart';
import 'package:pitchme/utiles/review_widget.dart';
import 'package:pitchme/screen/message_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PostDetail extends StatefulWidget {
  final PitcherModel pitcherModel;
  PostDetail({Key? key, required this.pitcherModel}) : super(key: key);

  @override
  State<PostDetail> createState() => _PostDetailState();
}

class _PostDetailState extends State<PostDetail> {
  bool isLiked = false;

  Future<void> _toggleLike(String pitchId) async {
    final User? user = FirebaseAuth.instance.currentUser;
    final pitchDoc =
        FirebaseFirestore.instance.collection('pitches').doc(pitchId);
    final pitchSnapshot = await pitchDoc.get();

    if (pitchSnapshot.exists) {
      List<dynamic> likes = pitchSnapshot.data()?['likes'] ?? [];
      if (likes.contains(user!.uid)) {
        // Unlike the pitch
        likes.remove(user.uid);
      } else {
        // Like the pitch
        likes.add(user.uid);
      }

      await pitchDoc.update({'likes': likes});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: BouncingScrollPhysics(),
        child: SafeArea(
          child: Column(
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('PitchList')
                    .where('productsid',
                        isEqualTo: widget.pitcherModel.productsid)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No pitches found'));
                  }

                  final pitches = snapshot.data!.docs;
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: pitches.length,
                    itemBuilder: (context, index) {
                      final pitch = pitches[index];

                      // Ensure image_url is a list
                      List<String> imageUrls = [];
                      if (pitch['image_url'] is String) {
                        imageUrls = [pitch['image_url']];
                      } else if (pitch['image_url'] is List) {
                        imageUrls = List<String>.from(pitch['image_url']);
                      }

                      PitcherModel pitcherModel = PitcherModel(
                        username: pitch['username'],
                        image_url: imageUrls,
                        pdf_file: pitch['pdf_file'],
                        problem_solved: pitch['problem_solved'],
                        product_name: pitch['product_name'],
                        video_file: pitch['video_file'],
                        email: pitch['email'],
                        productsid: pitch['productsid'],
                        likes: List<String>.from(pitch['likes']),
                        timestamp: null,
                        howmuchrevenuethisyear: pitch['howmuchrevenuethisyear'],
                        specificsolutionController:
                            pitch['specificsolutionController'],
                        whatisyourbusinessinonesentence:
                            pitch['whatisyourbusinessinonesentence'],
                        whyareyoutherightperson:
                            pitch['whyareyoutherightperson'],
                      );

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Column(
                          children: [
                            // BannersWidget(pitcherModel:pitcherModel),
                            Container(
                              color: Colors.white,
                              height: 340,
                              width: 370,
                              child: Column(
                                children: [
                                  Container(
                                    height: 270,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(29),
                                      boxShadow: const [
                                        BoxShadow(
                                          offset: Offset(0, 10),
                                          blurRadius: 33,
                                          color: Colors.grey,
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        ClipRRect(
                                            borderRadius:
                                                const BorderRadius.vertical(
                                                    top: Radius.circular(15)),
                                            child: BannerCarousel(
                                              imageUrls: pitcherModel.image_url,
                                            )),
                                        // Row(
                                        //   children: [
                                        //     IconButton(
                                        //       onPressed: () {},
                                        //       icon: const Icon(
                                        //         Icons.favorite,
                                        //         color: Colors.redAccent,
                                        //         size: 32,
                                        //       ),
                                        //     ),
                                        //     Text(
                                        //       '${pitch['likes']?.length ?? 0} likes',
                                        //       style: GoogleFonts.play(
                                        //           textStyle: const TextStyle(
                                        //               fontSize: 21)),
                                        //     ),
                                        //   ],
                                        // ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),

                            Container(
                              height: 900,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "User Name: ${pitcherModel.username}",
                                        style: GoogleFonts.play(),
                                      ),
                                    ],
                                  ),
                                  const Divider(),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "Products name : ${pitcherModel.product_name}",
                                          style: GoogleFonts.play(),
                                          softWrap: true,
                                          overflow: TextOverflow
                                              .visible, // or TextOverflow.ellipsis if you want to show "..." at the end
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Divider(),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "What is your business in one sentence : ${pitcherModel.whatisyourbusinessinonesentence}",
                                          style: GoogleFonts.play(),
                                          softWrap: true,
                                          overflow: TextOverflow
                                              .visible, // or TextOverflow.ellipsis if you want to show "..." at the end
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Divider(),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "What is the problem you solving : ${pitcherModel.problem_solved}",
                                          style: GoogleFonts.play(),
                                          softWrap: true,
                                          overflow: TextOverflow
                                              .visible, // or TextOverflow.ellipsis if you want to show "..." at the end
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Divider(),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "How much revenue in this year : ${pitcherModel.howmuchrevenuethisyear}",
                                          style: GoogleFonts.play(),
                                          softWrap: true,
                                          overflow: TextOverflow
                                              .visible, // or TextOverflow.ellipsis if you want to show "..." at the end
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Divider(),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "Why are you the right person : ${pitcherModel.whyareyoutherightperson.toString()}",
                                          style: GoogleFonts.play(),
                                          softWrap: true,
                                          overflow: TextOverflow
                                              .visible, // or TextOverflow.ellipsis if you want to show "..." at the end
                                        ),
                                      ),
                                    ],
                                  ),
                                  Divider(),
                                  Row(
                                    children: [
                                      const Text("Pitch Report"),
                                      IconButton(
                                        onPressed: () => showPDF(context,
                                            widget.pitcherModel.productsid),
                                        icon: const Icon(
                                          CupertinoIcons.doc_on_doc,
                                          size: 34,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Text("Video file"),
                                      IconButton(
                                        onPressed: () {
                                          Get.to(()=>VideoViewerScreen(
                                          videoUrl: pitcherModel.video_file,
                                        ),);
                                        },
                                        icon: const Icon(
                                          CupertinoIcons.videocam_circle,
                                          size: 34,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                          "Email Address : ${pitcherModel.email}"),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Get.to(() => MessageScreen(
                                                receiverEmail:
                                                    pitcherModel.email,
                                                receiverId:
                                                    pitcherModel.productsid,
                                              ));
                                        },
                                        child: Icon(
                                          CupertinoIcons
                                              .bubble_left_bubble_right,
                                          color: Colors.blue,
                                          size: 34,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Divider(),
                                  GestureDetector(
                                    onTap: () {
                                      Get.to(() => AddReviewBar(
                                          pitcherModel: pitcherModel));
                                    },
                                    child: Container(
                                      height: 50,
                                      width: 100,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.black,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.shade400,
                                              offset: Offset(10, 10),
                                              blurRadius: 8,
                                            ),
                                            BoxShadow(
                                              color: Colors.white,
                                              offset: Offset(-5, -5),
                                              blurRadius: 8,
                                            ),
                                          ]),
                                      child: Center(
                                        child: Text(
                                          "Add Review",
                                          style: GoogleFonts.play(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Divider()
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String?> fetchPDFUrl(String productsid) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('pitchlist')
          .where('productsid', isEqualTo: productsid)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
        return documentSnapshot['pdf_file'];
      } else {
        print('Document does not exist');
        return null;
      }
    } catch (e) {
      print('Error fetching PDF URL: $e');
      return null;
    }
  }

  Future<void> showPDF(BuildContext context, String productsid) async {
    String? pdfUrl = await fetchPDFUrl(productsid);

    if (pdfUrl != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PDFViewerScreen(pdfUrl: pdfUrl),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load PDF')),
      );
    }
  }
}
