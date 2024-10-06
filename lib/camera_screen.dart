import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:traffic_counting_project/dashboard.dart';
import 'package:traffic_counting_project/loading_screen.dart';


class CameraScreen extends StatefulWidget {
  CameraScreen() : super();

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  VideoPlayerController controller;
  Future<void> initializeVideoPlayerFuture;

  @override
  void initState() {
    // TODO: implement initState
    controller = VideoPlayerController.asset("assets/results.mp4");
    initializeVideoPlayerFuture = controller.initialize();
    controller.setLooping(false);
    controller.setVolume(1.0);

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Traffic detection"),
      ),
      body: FutureBuilder(
        future: initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return AspectRatio(
              aspectRatio: controller.value.aspectRatio,
              child: VideoPlayer(controller),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            if (controller.value.isPlaying) {
              controller.pause();
            } else {
              controller.play();
              Future.delayed(Duration(seconds: 27), () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoadingScreen()),

                );
              });
            }
          });
        },
        child:
            Icon(controller.value.isPlaying ? Icons.pause : Icons.play_arrow),
      ),
    );
  }
}

//-----------------------------jack code
// class CameraScreen extends StatefulWidget {
//   @override
//   _CameraScreenState createState() => _CameraScreenState();
// }
//
// class _CameraScreenState extends State<CameraScreen> {
//   File _galleryVideo;
//   File _cameraVideo;
//
//   ImagePicker picker = ImagePicker();
//
//   VideoPlayerController _videoPlayerController;
//   VideoPlayerController _cameraVideoPlayerController;
//
//   // This funcion will helps you to pick a Video File
//   _pickVideoFromGallery() async {
//     PickedFile pickedFile = await picker.getVideo(source: ImageSource.gallery);
//
//     _galleryVideo = File(pickedFile.path);
//
//     _videoPlayerController = VideoPlayerController.file(_galleryVideo)
//       ..initialize().then((_) {
//         setState(() {});
//         _videoPlayerController.play();
//       });
//   }
//
//   // This funcion will helps you to pick a Video File from Camera
//   _pickVideoFromCamera() async {
//     PickedFile pickedFile = await picker.getVideo(source: ImageSource.camera);
//
//     _cameraVideo = File(pickedFile.path);
//
//     _cameraVideoPlayerController = VideoPlayerController.file(_cameraVideo)
//       ..initialize().then((_) {
//         setState(() {});
//         _cameraVideoPlayerController.play();
//       });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Image / Video Picker"),
//       ),
//       body: SingleChildScrollView(
//         child: Center(
//           child: Container(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               children: <Widget>[
//                 if (_galleryVideo != null)
//                   _videoPlayerController.value.initialized
//                       ? AspectRatio(
//                           aspectRatio: _videoPlayerController.value.aspectRatio,
//                           child: VideoPlayer(_videoPlayerController),
//                         )
//                       : Container()
//                 else
//                   Text(
//                     "Use camera to take video",
//                     style: TextStyle(fontSize: 18.0),
//                   ),
//                 ElevatedButton(
//                   onPressed: () {
//                     _pickVideoFromCamera();
//                   },
//                   child: Icon(Icons.photo_camera),
//                 ),
//                 if (_cameraVideo != null)
//                   _cameraVideoPlayerController.value.initialized
//                       ? AspectRatio(
//                           aspectRatio:
//                               _cameraVideoPlayerController.value.aspectRatio,
//                           child: VideoPlayer(_cameraVideoPlayerController),
//                         )
//                       : Container()
//                 else
//                   Text(
//                     "Choose video from photo library",
//                     style: TextStyle(fontSize: 18.0),
//                   ),
//                 ElevatedButton(
//                   onPressed: () {
//                     _pickVideoFromGallery();
//                   },
//                   child: Icon(Icons.photo_library),
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

/*
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

//Camera Screen attempt, opens camera/ photo library on press, errors in retrieving file once video selected.

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  File _video;
  final picker = ImagePicker();

  VideoPlayerController _videoPlayerController;
  VideoPlayerController _cameraVideoPlayerController;

  Future videoFromCamera() async {
    final pickedFile = await picker.getVideo(source: ImageSource.camera);

    _cameraVideoPlayerController = VideoPlayerController.file(_video)
      ..initialize().then((_) {
        setState(() {});
        _videoPlayerController.play();
      });
    setState(() {
      if (pickedFile != null) {
        _video = File(pickedFile.path);
      } else {
        print('No video selected.');
      }
    });
  }

  Future videoFromGallery() async {
    final pickedFile = await picker.getVideo(source: ImageSource.gallery);

    _videoPlayerController = VideoPlayerController.file(_video)
      ..initialize().then((_) {
        setState(() {});
        _videoPlayerController.play();
      });
    setState(() {
      if (pickedFile != null) {
        _video = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Choose from Photo Library'),
                      onTap: () {
                        videoFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Use Camera'),
                    onTap: () {
                      videoFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        }
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video '),
      ),
      body: Center(
        child: _video == null
            ? Text('No video selected')
            : Image.file(_video),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showPicker(context);
        },
        tooltip: 'Pick Video',
        child: Icon(Icons.add_a_photo),
      ),
    );
  }
}
*/
/*
// Temporary stand-in screen until camera can be implemented fully without errors.
class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Camera Screen"),
        backgroundColor: Colors.red,
      ),
      backgroundColor: Colors.lightGreen,
    );
  }
}
*/
