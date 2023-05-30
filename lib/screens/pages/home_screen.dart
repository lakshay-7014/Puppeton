import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:puppeton/const/color_const.dart';
import 'package:puppeton/views/widgets/custom_appBar.dart';

import '../../views/widgets/category_filter.dart';

class HomeScreen extends StatefulWidget {
  static double height10 = 0.0;
  static double width10 = 0.0;
  final String category;

  const HomeScreen({super.key, required this.category});

  static void mediaQueryHeightWidth(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    height10 = Get.mediaQuery.size.height * 0.0118;
    width10 = Get.mediaQuery.size.width * 0.0118 * 2.1;
    print(height10);
  }

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? name = ' ';
  String? email = ' ';
  String? bio = ' ';
  String? profilePic = "assets/images/default_image1.png";
  String? phoneNumber = ' ';
  String? aadhar = ' ';
  String? uid = ' ';

  Future<void> _getData() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    if (snapshot.exists) {
      final data = snapshot.data() as Map<String, dynamic>;
      setState(() {
        name = data['name'];
        aadhar = data['aadhar'];
        bio = data['bio'];
        email = data['email'];
        profilePic = data['profilePic'];
        phoneNumber = data['phoneNumber'];
        uid = data['uid'];
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getData();
  }

  var currentIndex = 0;
  int _selectedPageIndex = 0;
  User? user = FirebaseAuth.instance.currentUser;

  final List<String> imgList = [
    'assets/images/img17.png',
    'assets/images/img12.png',
    'assets/images/img15.png',
  ];

  @override
  Widget build(BuildContext context) {
    // final ap = Provider.of<AuthProvider>(context, listen: false);
    double displayWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: appbar(name: "Puppetoon"),
    );
  }
}
