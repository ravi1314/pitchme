import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:file_picker/file_picker.dart';
import 'package:pitchme/service/genretId.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pitchme/model/pitcher_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pitchme/controller/products_add_controller.dart';

class CreatePitchScreen extends StatefulWidget {
  @override
  _CreatePitchScreenState createState() => _CreatePitchScreenState();
}

class _CreatePitchScreenState extends State<CreatePitchScreen> {
  final _formKey = GlobalKey<FormState>();
  final User? user = FirebaseAuth.instance.currentUser;
  final AddProductsImageController addProductsImageController =
      Get.put(AddProductsImageController());

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController whatisyourbusinessinonesentence =
      TextEditingController();
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _problemController = TextEditingController();
  final TextEditingController _specificsolutionController =
      TextEditingController();
  final TextEditingController _howmuchrevenuethisyear = TextEditingController();
  final TextEditingController _whyareyoutherightperson =
      TextEditingController();
  final TextEditingController _emailcontoller = TextEditingController();

  File? _pdfFile;
  File? _imageFile;
  File? _videoFile;

  bool _isPickingImage = false;
  bool _isPickingVideo = false;
  final ImagePicker _picker = ImagePicker();

  Future<String> _getFilePath(String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/$fileName';
  }

  Future<void> _pickImage() async {
    if (_isPickingImage) return;
    setState(() {
      _isPickingImage = true;
    });

    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final filePath = await _getFilePath(pickedFile.name);
        final savedFile = await File(pickedFile.path).copy(filePath);
        setState(() {
          _imageFile = savedFile;
        });

        // Update profile picture path in Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .update({
          'profilePicPath': savedFile.path,
        });

        // Submit form after picking the image
        _submitForm();
      }
    } catch (e) {
      print('Error picking image: $e');
    } finally {
      setState(() {
        _isPickingImage = false;
      });
    }
  }

  Future<void> _pickVideo() async {
    final pickedFile = await _picker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _videoFile = File(pickedFile.path);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("No video selected")),
      );
    }
  }

  Future<String?> _uploadVideo(File videoFile) async {
    try {
      // Get a reference to Firebase Storage
      String fileName = path.basename(videoFile.path);
      Reference storageRef =
          FirebaseStorage.instance.ref().child('videos/$fileName');

      // Upload the video file to Firebase Storage
      UploadTask uploadTask = storageRef.putFile(videoFile);
      TaskSnapshot snapshot = await uploadTask;

      // Get the download URL of the uploaded file
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print("Error uploading video: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error uploading video: $e")),
      );
      return null;
    }
  }

  Future<void> pickPdf() async {
    // Request storage permission if not granted
    PermissionStatus status = await Permission.storage.status;
    if (!status.isGranted) {
      // Show dialog explaining why permission is needed
      bool? isGranted = await _showPermissionDialog();
      if (!isGranted!) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Permission denied. Cannot select PDF.")),
        );
        return;
      }
    }

    // Proceed with file picking
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result == null || result.files.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("No PDF file selected or operation was canceled.")),
      );
      return;
    }

    try {
      // Handle the picked file
      final filePath = await _getFilePath(result.files.single.name);
      final savedFile = await File(result.files.single.path!).copy(filePath);
      setState(() {
        _pdfFile = savedFile;
      });
    } catch (e) {
      print("Error handling picked file: ${e.toString()}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error handling picked PDF: $e")),
      );
    }
  }

  Future<String?> _uploadPdf(File pdfFile) async {
    try {
      String fileName = path.basename(pdfFile.path);
      Reference storageRef =
          FirebaseStorage.instance.ref().child('Pdf/$fileName');

      UploadTask uploadTask = storageRef.putFile(pdfFile);
      TaskSnapshot snapshot = await uploadTask;

      String downloadUrlPdf = await snapshot.ref.getDownloadURL();
      return downloadUrlPdf;
    } catch (e) {
      print("Error uploading PDF: ${e.toString()}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error uploading PDF: $e")),
      );
      return null;
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        String productId = await GenerateIds().generateProductId();

        await FirebaseFirestore.instance
            .collection('pitchlist')
            .doc(productId)
            .set({
          'productsid': productId,
          'email': _emailcontoller.text, // Ensure user email is not null
          'username': _usernameController.text.isNotEmpty
              ? _usernameController.text
              : '',
          'whyareyoutherightperson': _whyareyoutherightperson.text.isNotEmpty
              ? _whyareyoutherightperson.text
              : '',
          'whatisyourbusinessinonesentence':
              whatisyourbusinessinonesentence.text.isNotEmpty
                  ? whatisyourbusinessinonesentence.text
                  : '',
          'product_name': _productNameController.text.isNotEmpty
              ? _productNameController.text
              : '',
          'howmuchrevenuethisyear': _howmuchrevenuethisyear.text.isNotEmpty
              ? _howmuchrevenuethisyear.text
              : '',
          'problem_solved':
              _problemController.text.isNotEmpty ? _problemController.text : '',
          'specificsolutionController':
              _specificsolutionController.text.isNotEmpty
                  ? _specificsolutionController.text
                  : '',
          'image_url': _imageFile?.path ?? '',
          'pdf_file': _pdfFile?.path,
          'video_file': _videoFile,
          'timestamp': FieldValue.serverTimestamp(),
          'likes': [], // Initialize with an empty list of likes
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pitch created successfully')),
        );

        setState(() {
          _usernameController.clear();
          whatisyourbusinessinonesentence.clear();
          _productNameController.clear();
          _problemController.clear();
          _whyareyoutherightperson.clear();
          whatisyourbusinessinonesentence.clear();
          _specificsolutionController.clear();
          _howmuchrevenuethisyear.clear();
          _emailcontoller.clear();
          _pdfFile = null;
          _imageFile = null;
          _videoFile = null;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error creating pitch: $e')),
        );
      }
    }
  }

  Future<Map<String, dynamic>?> getUserProfile(String uid) async {
    try {
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (userDoc.exists) {
        return userDoc.data() as Map<String, dynamic>?;
      }
    } catch (e) {
      print('Error fetching user profile: $e');
    }
    return null;
  }

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
  Widget buildPitchCard(Map<String, dynamic> pitch) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: getUserProfile(pitch['email']),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        var userProfile = snapshot.data;
        String profilePicPath = userProfile?['profilePicPath'] ?? '';
        List<dynamic> likes = pitch['likes'] ?? [];
        bool isLiked = user != null ? likes.contains(user!.uid) : false;

        return Card(
          elevation: 20,
          color: Colors.white,
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: profilePicPath.isNotEmpty
                  ? FileImage(File(profilePicPath))
                  : const AssetImage('asset/image/bg.png') as ImageProvider,
            ),
            title: Text(pitch['username']),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (pitch['image_url'] != null && pitch['image_url'].isNotEmpty)
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => _toggleLike(
                            pitch['id']), // Update to use the correct ID
                        icon: Icon(
                          isLiked ? Icons.favorite : Icons.favorite_border,
                          color: isLiked ? Colors.red : Colors.black,
                        ),
                      ),
                      Text('${pitch['likes']?.length ?? 0} likes'),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<List<Map<String, dynamic>>> fetchPitches() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('pitchlist').get();
    return querySnapshot.docs.map((doc) {
      var data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id; // Add document ID to the data
      return data;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Create Pitch'),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Images"),
                    MaterialButton(
                      elevation: 30,
                      color: Colors.white,
                      onPressed: () {
                        addProductsImageController.showImagesPickerDialog();
                      },
                      child: const Text("Pick Image"),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              //shoe image
              GetBuilder<AddProductsImageController>(
                  init: AddProductsImageController(),
                  builder: (imagController) {
                    return imagController.selectedImage.length > 0
                        ? Container(
                            width: MediaQuery.of(context).size.width - 20,
                            height: Get.height / 2.0,
                            child: GridView.builder(
                              itemCount: addProductsImageController
                                  .selectedImage.length,
                              physics: const BouncingScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 150,
                                mainAxisExtent: 150,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                              ),
                              itemBuilder: (BuildContext context, index) {
                                return Stack(
                                  children: [
                                    Image.file(
                                      File(addProductsImageController
                                          .selectedImage[index].path),
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: double.infinity,
                                    ),
                                    Positioned(
                                      top: 5,
                                      right: 5,
                                      child: GestureDetector(
                                        onTap: () {
                                          imagController.removeImages(index);
                                        },
                                        child: const CircleAvatar(
                                          backgroundColor: Colors.black,
                                          radius: 12,
                                          child: Icon(
                                            Icons.close,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          )
                        : const SizedBox.shrink();
                  }),

              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _usernameController,
                          decoration: const InputDecoration(
                            labelText: 'Username',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your username';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: whatisyourbusinessinonesentence,
                          decoration: const InputDecoration(
                            labelText: 'What is your business in one sentence?',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a sentence about your business';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _productNameController,
                          decoration: const InputDecoration(
                            labelText: 'Product Name',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter product name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _problemController,
                          decoration: const InputDecoration(
                            labelText: 'Problem solved',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the problem solved';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _specificsolutionController,
                          decoration: const InputDecoration(
                            labelText: 'Specific Solution ',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the solution ';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _howmuchrevenuethisyear,
                          decoration: const InputDecoration(
                            labelText: 'How much revenue this year',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter this year';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _whyareyoutherightperson,
                          decoration: const InputDecoration(
                            labelText: 'Why are you the right person',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the person';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _emailcontoller,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            } else if (!value.contains('@')) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                      ],
                    )),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: addProductsImageController.pickAndUploadPDF,
                    icon: const Icon(Icons.attach_file),
                    label: const Text('Select PDF'),
                  ),
                  ElevatedButton.icon(
                    onPressed: _pickVideo,
                    icon: const Icon(Icons.video_collection),
                    label: const Text('Select Video'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  try {
                    await addProductsImageController.uploadFunction(
                        addProductsImageController.selectedImage);
                    String postId = await GenerateIds().generateProductId();

                    String? videoUrl;
                    if (_videoFile != null) {
                      videoUrl = await _uploadVideo(_videoFile!);
                    }
                    String? pdfUrl;
                    if (_pdfFile != null) {
                      pdfUrl = await _uploadPdf(_pdfFile!);
                    }

                    if (_formKey.currentState!.validate()) {
                      PitcherModel pitcherModel = PitcherModel(
                          username: _usernameController.text.trim(),
                          image_url: addProductsImageController.arrimageUrl,
                          pdf_file: pdfUrl.toString(),
                          problem_solved: _problemController.text.trim(),
                          product_name: _productNameController.text.trim(),
                          video_file: videoUrl.toString(),
                          email: _emailcontoller.text.trim(),
                          productsid: postId,
                          likes: [],
                          timestamp: FieldValue.serverTimestamp(),
                          howmuchrevenuethisyear:
                              _howmuchrevenuethisyear.text.trim(),
                          specificsolutionController:
                              _specificsolutionController.text.trim(),
                          whatisyourbusinessinonesentence:
                              _whyareyoutherightperson.text.trim(),
                          whyareyoutherightperson:
                              _whyareyoutherightperson.text.trim());

                      await FirebaseFirestore.instance
                          .collection('PitchList')
                          .doc(postId)
                          .set(pitcherModel.toMap());
                      Get.snackbar(
                          backgroundColor: Colors.black,
                          "Thank you",
                          "Your Pitch is Submit",
                          colorText: Colors.white);
                    }
                  } catch (e) {
                    // ignore: avoid_print
                    print("Error is ${e.toString()}");
                  }
                },
                child: const Text('Create Pitch'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _showPermissionDialog() async {
    bool isGranted = false;
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Permission Request'),
          content: Text('This app needs storage access to pick files.'),
          actions: <Widget>[
            TextButton(
              child: Text('Deny'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Allow'),
              onPressed: () async {
                Navigator.of(context).pop();
                isGranted = await Permission.storage.request().isGranted;
              },
            ),
          ],
        );
      },
    );
    return isGranted;
  }
}
