import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AWS S3 Image Frame',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false, // Debug banner removed
      home: const ImageFrameScreen(),
    );
  }
}

class ImageFrameScreen extends StatefulWidget {
  const ImageFrameScreen({super.key});

  @override
  State<ImageFrameScreen> createState() => _ImageFrameScreenState();
}

class _ImageFrameScreenState extends State<ImageFrameScreen> {
  final List<String> _imageUrls = [
    // Replace these with your S3 bucket URLs
    'https://azaybee.s3.us-east-1.amazonaws.com/one+piece1.png',
    'https://azaybee.s3.us-east-1.amazonaws.com/Screenshot+2024-11-29+152141.png',
  ];

  int _currentIndex = 0;
  bool _isPaused = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startImageRotation();
  }

  void _startImageRotation() {
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (!_isPaused) {
        setState(() {
          _currentIndex = (_currentIndex + 1) % _imageUrls.length;
        });
      }
    });
  }

  void _togglePauseResume() {
    setState(() {
      _isPaused = !_isPaused;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Digital Picture Frame'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.blueGrey,
              width: 10.0,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              _imageUrls[_currentIndex],
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.6,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _togglePauseResume,
        tooltip: _isPaused ? 'Resume' : 'Pause',
        child: Icon(_isPaused ? Icons.play_arrow : Icons.pause),
      ),
    );
  }
}
