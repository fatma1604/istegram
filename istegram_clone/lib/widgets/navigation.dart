import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:istegram_clone/screen/add_screen.dart';
import 'package:istegram_clone/screen/explore.dart';
import 'package:istegram_clone/screen/home.dart';
import 'package:istegram_clone/screen/profile_screen.dart';
import 'package:istegram_clone/screen/reelsScreen.dart';

class Navigations_Screen extends StatefulWidget {
  const Navigations_Screen({super.key});

  @override
  State<Navigations_Screen> createState() => _Navigations_ScreenState();
}

class _Navigations_ScreenState extends State<Navigations_Screen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey,
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: '',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: '',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.camera),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'images/instagram-reels-icon.png',
                height: 20.h,
              ),
              label: '',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: '',
            ),
          ],
        ),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          const HomeScreen(),
          const ExploreScreen(),
          const AddScreen(),
          const ReelScreen(),
          ProfileScreen(
              // Uid: _auth.currentUser!.uid,
              ),
        ],
      ),
    );
  }
}
