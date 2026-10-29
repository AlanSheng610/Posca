import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:posca/controllers/profile_controller.dart';
import 'package:posca/screens/home/tabs/friends_tab.dart';
import 'package:posca/screens/home/tabs/gallery_tab.dart';
import 'package:posca/screens/home/tabs/inbox_tab.dart';
import 'package:posca/screens/home/tabs/send_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 1;

  // The inbox unlocks only after the user sends a public postcard.
  late final bool _canReceive =
      Get.find<ProfileController>().sendConfig.canReceiveAt(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: IndexedStack(
        index: _currentIndex,
        children: [
          const GalleryTab(),
          _canReceive ? const InboxTab() : const SendTab(),
          const FriendsTab(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey[850],
        elevation: 0,
        iconSize: 35,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.confirmation_num),
            label: 'Postcards',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.mail), label: 'Send'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Friends'),
        ],
      ),
    );
  }
}
