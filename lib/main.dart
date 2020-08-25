import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final String urlToStreamVideo = 'tcp://192.168.41.1:35001';
  VlcPlayerController controller;

  String log = "--------------------";
  Uint8List imageSnapshot;

  @override
  void initState() {
    controller = new VlcPlayerController(
        // Start playing as soon as the video is loaded.
        onInit: () {
      controller.play();
    });
    controller.addListener(() {
      print(controller.playingState);
      setState(() {
        log = "${controller.playingState} :"
            "${controller.playbackSpeed} :"
            "${controller.position.inMilliseconds} :"
            "${controller.duration.inMilliseconds}";
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          imageSnapshot != null ? Image.memory(imageSnapshot) : Container(),
          Text(
            log ?? "",
            style: TextStyle(color: Colors.red, fontSize: 14),
          ),
          Row(
            children: [
              FlatButton(
                child: Text("Pause"),
                onPressed: () {
                  controller.pause();
                },
              ),
              FlatButton(
                child: Text("play"),
                onPressed: () {
                  controller.play();
                },
              ),
              FlatButton(
                child: Text("stop"),
                onPressed: () {
                  controller.stop();
                },
              ),
              FlatButton(
                child: Text("capture"),
                onPressed: () async {
                  var data = await controller.takeSnapshot();
                   setState(() {
                     imageSnapshot = data;
                   });
                },
              ),
            ],
          ),
          VlcPlayer(
            aspectRatio: 16 / 9,
            url: "tcp://192.168.41.1:35001",
            controller: controller,
            placeholder: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ],
      ),
    );
  }
}
