import 'dart:io';
import 'package:get/get.dart';
import '../model/pitcher_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_card/image_card.dart';
import 'package:pitchme/screen/chatbot.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pitchme/model/Review_Model.dart';
import 'package:pitchme/screen/post_detail.dart';
import 'package:random_string/random_string.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pitchme/screen/setting_screen.dart';
import 'package:pitchme/screen/profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pitchme/screen/create_ptch_screen.dart';
import 'package:pitchme/screen/messag_email_screen.dart';
import 'package:pitchme/controller/prfile_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  static final List<Widget> _widgetOptions = <Widget>[
    PitchListScreen(),
    const ProfileScreen(),
    CreatePitchScreen(),
    const SettingScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final ProfileController _profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: 0,
        items: const [
          Icon(Icons.home_outlined, size: 30),
          Icon(Icons.person, size: 30),
          Icon(Icons.add, size: 30),
          Icon(Icons.settings, size: 30),
        ],
        color: Colors.white,
        buttonBackgroundColor: Colors.white,
        backgroundColor: Colors.black,
        animationCurve: Curves.linear,
        animationDuration: const Duration(milliseconds: 600),
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        letIndexChange: (index) => true,
      ),
    );
  }
}

class PitchListScreen extends StatefulWidget {
  @override
  State<PitchListScreen> createState() => _PitchListScreenState();
}

class _PitchListScreenState extends State<PitchListScreen> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final User? user = FirebaseAuth.instance.currentUser;
  final ProfileController _profileController = Get.put(ProfileController());
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<String> _likedPosts = [];
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = _firebaseAuth.currentUser;
    _fetchLikedPosts();
  }

  Future<void> _fetchLikedPosts() async {
    if (_currentUser != null) {
      try {
        DocumentSnapshot userSnapshot = await _firestore
            .collection('PitchList')
            .doc(_currentUser!.uid)
            .get();
        if (userSnapshot.exists) {
          setState(() {
            _likedPosts = List<String>.from(userSnapshot['likes'] ?? []);
          });
        }
      } catch (e) {
        print('Error fetching liked posts: $e');
      }
    }
  }

  String timeAgo(DateTime date) {
    final Duration diff = DateTime.now().difference(date);
    if (diff.inDays > 365) {
      return '${(diff.inDays / 365).floor()} years ago';
    } else if (diff.inDays > 30) {
      return '${(diff.inDays / 30).floor()} months ago';
    } else if (diff.inDays > 0) {
      return '${diff.inDays} ${diff.inDays == 1 ? 'day' : 'days'} ago';
    } else if (diff.inHours > 0) {
      return '${diff.inHours} ${diff.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (diff.inMinutes > 0) {
      return '${diff.inMinutes} ${diff.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else {
      return 'just now';
    }
  }

  Future<void> _toggleLike(String uid) async {
    if (_currentUser != null) {
      try {
        DocumentReference postRef = _firestore.collection('PitchList').doc(uid);
        DocumentSnapshot postSnapshot = await postRef.get();

        if (!postSnapshot.exists) {
          print('Document does not exist');
          return;
        }

        if (_likedPosts.contains(uid)) {
          await postRef.update({
            'likes': FieldValue.arrayRemove([_currentUser!.uid]),
          });
          setState(() {
            _likedPosts.remove(uid);
          });
        } else {
          await postRef.update({
            'likes': FieldValue.arrayUnion([_currentUser!.uid]),
          });
          setState(() {
            _likedPosts.add(uid);
          });
        }

        await _firestore.collection('PitchList').doc(_currentUser!.uid).update({
          'likes': _likedPosts,
        });
      } catch (e) {
        print('Error toggling like: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 0, top: 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Row(
              children: [
                const SizedBox(width: 20),
                Obx(() {
                  return CircleAvatar(
                      backgroundImage:
                          _profileController.isProfilePicPathSet.value
                              ? FileImage(
                                  File(_profileController.profilePicPath.value))
                              : AssetImage('asset/image/bg.png'));
                }),
                const SizedBox(width: 20),
                Text(
                  "P i t c h M e",
                  style: GoogleFonts.play(
                    textStyle: const TextStyle(
                      fontSize: 23,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    var genuid = randomBetween(1, 9);
                    Get.to(() => ChatBot());
                  },
                  color: Colors.black,
                  icon: const Icon(
                    CupertinoIcons.chat_bubble_text_fill,
                    size: 32,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 14, right: 14),
              child: Container(
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
                child: const Divider(
                  endIndent: 10,
                  indent: 10,
                  thickness: 1,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('PitchList')
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  final pitches = snapshot.data!.docs;
                  return ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: pitches.length,
                    itemBuilder: (context, index) {
                      final pitch = pitches[index];
                      List<String> imageUrls = [];
                      if (pitch['image_url'] is String) {
                        imageUrls = [pitch['image_url']];
                      } else if (pitch['image_url'] is List) {
                        imageUrls = List<String>.from(pitch['image_url']);
                      }
                      
                      PitcherModel pitcherModel = PitcherModel(
                        username: pitch['username'],
                        image_url: imageUrls,
                        pdf_file: pitch['pdf_file'].toString(),
                        problem_solved: pitch['problem_solved'],
                        product_name: pitch['product_name'],
                        video_file: pitch['video_file'].toString(),
                        email: pitch['email'],
                        productsid: pitch['productsid'],
                        likes: List<String>.from(pitch['likes']),
                        timestamp: pitch['timestamp'] != null
                            ? (pitch['timestamp'] as Timestamp).toDate()
                            : null,
                        howmuchrevenuethisyear: pitch['howmuchrevenuethisyear'],
                        specificsolutionController:
                            pitch['specificsolutionController'],
                        whatisyourbusinessinonesentence:
                            pitch['whatisyourbusinessinonesentence'],
                        whyareyoutherightperson: '',
                      );

                      return StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .doc(_currentUser?.uid)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(
                              child: Text(
                                "Pitch is not Found",
                                style: GoogleFonts.play(),
                              ),
                            );
                          }
                          final userData =
                              snapshot.data!.data() as Map<String, dynamic>? ??
                                  {};
                          final profilePicUrl = userData['profilePicUrl'] ?? '';
                          final timestamp = pitch['timestamp'] != null
                              ? pitch['timestamp'] as Timestamp
                              : Timestamp.now();
                          String postId = pitch.id;
                          bool isLiked = _likedPosts.contains(postId);

                          return Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  offset: const Offset(0, 10),
                                  blurRadius: 10,
                                  color: Colors.grey.withOpacity(0.9),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: 16,
                                  ),
                                  leading: CircleAvatar(
                                    backgroundImage: CachedNetworkImageProvider(
                                        pitcherModel.image_url[0]),
                                  ),
                                  title: Text(
                                    pitcherModel.username,
                                    style: GoogleFonts.play(
                                      textStyle: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  subtitle: Text(
                                    timeAgo(timestamp.toDate()),
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                  trailing: IconButton(
                                    icon: Icon(
                                      isLiked
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: isLiked ? Colors.red : Colors.grey,
                                    ),
                                    onPressed: () {
                                      _toggleLike(postId);
                                    },
                                  ),
                                ),
                                Container(
                                    width: 350,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(20),
                                          bottomRight: Radius.circular(30)),
                                      border: Border.all(
                                        color: Colors.white, // Border color
                                        width: 4.0, // Border width
                                      ),
                                    ),
                                    child: FillImageCard(
                                        width: 330,
                                        heightImage: 450,
                                        imageProvider:
                                            CachedNetworkImageProvider(
                                                pitcherModel.image_url[0]))),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 5, left: 16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        pitcherModel.product_name,
                                        style: GoogleFonts.play(
                                          textStyle: const TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        "Problem Solved : ${pitcherModel.problem_solved}",
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                                StreamBuilder(
                                  stream: FirebaseFirestore.instance
                                      .collection("PitchList")
                                      .doc(pitcherModel.productsid)
                                      .collection("Review")
                                      .snapshots(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (snapshot.hasError) {
                                      return Center(
                                        child:
                                            Text("Error is ${snapshot.error}"),
                                      );
                                    }
                                    if (!snapshot.hasData) {
                                      return const Center(
                                        child: Text("No Review Added"),
                                      );
                                    }
                                    int reviewCount =
                                        snapshot.data!.docs.length;
                                    int showCount =
                                        reviewCount > 2 ? 2 : reviewCount;
                                    return ListView.builder(
                                      itemCount: showCount,
                                      physics: const BouncingScrollPhysics(),
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        final data = snapshot.data!.docs[index];
                                        ReviewModel reviewModel = ReviewModel(
                                            createdAt: data['createdAt'],
                                            feedback: data['feedback'],
                                            userid: data['userid'],
                                            username: data['username'],
                                            rating: data['rating']);
                                        return ListTile(
                                          leading: const Icon(
                                            CupertinoIcons.star_fill,
                                            color: Colors.amber,
                                          ),
                                          title: Text("${reviewModel.rating}"),
                                          subtitle:
                                              Text("${reviewModel.feedback}"),
                                        );
                                      },
                                    );
                                  },
                                ),
                                ButtonBar(
                                  alignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        '${pitch['likes']?.length ?? 0} likes'),
                                    TextButton(
                                      onPressed: () {
                                        Get.to(() => PostDetail(
                                            pitcherModel: pitcherModel));
                                      },
                                      child: const Text('Learn More'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<File> _loadImageFile(String path) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$path');
      if (await file.exists()) {
        return file;
      } else {
        throw Exception('File not found');
      }
    } catch (e) {
      throw Exception('Error loading file: $e');
    }
  }

  bool _isLocalFile(String path) {
    return File(path).existsSync();
  }
}
