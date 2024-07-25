import 'dart:io';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';

class VideoPickerScreen extends StatefulWidget {
  @override
  _VideoPickerScreenState createState() => _VideoPickerScreenState();
}

class _VideoPickerScreenState extends State<VideoPickerScreen> {
  bool _isPickingVideo = false;
  File? _videoFile;
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  late String _videoDownloadUrl;

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

 Future<void> _pickVideo() async {
    if (_isPickingVideo) return;
    setState(() {
      _isPickingVideo = true;
    });

    try {
      final pickedFile = await ImagePicker().pickVideo(source: ImageSource.gallery);
      if (pickedFile != null) {
        final filePath = pickedFile.path;
        final fileName = DateTime.now().millisecondsSinceEpoch.toString() + '.mp4';

        final storageRef = FirebaseStorage.instance.ref().child('videos/$fileName');
        final uploadTask = storageRef.putFile(File(filePath));
        final snapshot = await uploadTask.whenComplete(() => null);

        final downloadUrl = await snapshot.ref.getDownloadURL();
        setState(() {
          _videoFile = File(filePath);
          _videoDownloadUrl = downloadUrl; // Store the download URL
        });

        print('Video URL: $_videoDownloadUrl'); // Debug log
        _initializeVideoPlayer(_videoFile!);
      }
    } catch (e) {
      print('Error picking video: $e');
    } finally {
      setState(() {
        _isPickingVideo = false;
      });
    }
  }



  Future<String> _uploadToFirebase(File file) async {
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('videos/${file.path.split('/').last}');
      final uploadTask = storageRef.putFile(file);
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading video: $e');
      return '';
    }
  }

  Future<String> _getFilePath(String fileName) async {
    // Get the temporary directory of the app
    final directory = await getTemporaryDirectory();
    return '${directory.path}/$fileName';
  }

  void _initializeVideoPlayer(File videoFile) {
  _videoPlayerController = VideoPlayerController.file(videoFile)
    ..initialize().then((_) {
      if (mounted) {
        setState(() {
          _chewieController = ChewieController(
            videoPlayerController: _videoPlayerController!,
            aspectRatio: _videoPlayerController!.value.aspectRatio,
            autoPlay: true,
            looping: true,
          );
        });
      }
    });
}

@override
void initState() {
  super.initState();
  if (_videoFile != null) {
    _initializeVideoPlayer(_videoFile!);
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Picker'),
      ),
      body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton.icon(
            onPressed: _pickVideo,
            icon: const Icon(Icons.video_collection),
            label: const Text('Select Video'),
          ),
          SizedBox(height: 20),
          _videoFile != null && _chewieController != null
              ? Container(
                  width: MediaQuery.of(context).size.width,
                  height: 300,
                  child: Chewie(controller: _chewieController!),
                )
              : Text(
                  'No video selected',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
        ],
      ),
    ),
  );
}
}
