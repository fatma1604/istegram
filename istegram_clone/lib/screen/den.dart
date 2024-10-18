import 'package:flutter/material.dart';
import 'package:istegram_clone/screen/chat.dart';
import 'package:istegram_clone/screen/new.dart';
import 'package:istegram_clone/widgets/navigation.dart';

class Den extends StatefulWidget {
  @override
  _DenState createState() => _DenState();
}

class _DenState extends State<Den> {
  final PageController _pageController = PageController(initialPage: 1);

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          PhotoPicker(),
          Navigations_Screen(),
          ChatPage(),
        ],
      ),
    );
  }
}