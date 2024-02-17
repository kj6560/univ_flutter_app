import 'package:flutter/material.dart';
import '../contents/Reels.dart';

class MyReels extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      body: Reels(),
    );
  }
}
