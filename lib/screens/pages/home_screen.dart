import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:puppeton/auth/auth_provider.dart';
import 'package:puppeton/const/color_const.dart';
import 'package:puppeton/const/font_const.dart';
import 'package:puppeton/const/image_const.dart';
import 'package:puppeton/screens/pages/welcome_screen.dart';
import 'package:puppeton/views/widgets/custom_appBar.dart';
import 'package:video_player/video_player.dart';

String? name = ' ';
String? email = ' ';
String? bio = ' ';
String? profilePic = "assets/images/default_image.png";
String? phoneNumber = ' ';
String? aadhar = ' ';
String? uid = ' ';

Color white = Colors.white;

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
  User? user = FirebaseAuth.instance.currentUser;

  final List<String> videoAssets = [
    'assets/videos/1.mp4',
    'assets/videos/2.mp4',
    'assets/videos/3.mp4',
    'assets/videos/4.mp4',
    'assets/videos/5.mp4',
  ];

  final List<String> videoTitles = [
    'Puppet Story 1',
    'Puppet Story 2',
    'Puppet Story 3',
    'Puppet Story 4',
    'Puppet Story 5',
  ];

  @override
  Widget build(BuildContext context) {
    double displayWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: appbar(name: "Puppetoon"),
      drawer: const Drawer1(),
      body: ListView.builder(
        itemCount: videoAssets.length,
        itemBuilder: (BuildContext context, int index) {
          return VideoItem(
            assetPath: videoAssets[index],
            txt: videoTitles[index],
          );
        },
      ),
    );
  }
}

class VideoItem extends StatefulWidget {
  final String assetPath, txt;

  VideoItem({required this.assetPath, required this.txt});

  @override
  _VideoItemState createState() => _VideoItemState();
}

class _VideoItemState extends State<VideoItem> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    _controller = VideoPlayerController.asset(widget.assetPath);
    _initializeVideoPlayerFuture = _controller.initialize();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (_controller.value.isPlaying) {
            _controller.pause();
          } else {
            _controller.play();
          }
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder(
              future: _initializeVideoPlayerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  );
                } else {
                  return Center(
                    child: Container(
                      height: 40,
                      width: 40,
                      child: CircularProgressIndicator(
                        //  backgroundColor: Colors.red,
                        valueColor: new AlwaysStoppedAnimation<Color>(
                            ColorConst.primaryColor),
                      ),
                    ),
                  );
                }
              },
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              widget.txt,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: FontConst.nunitoSans),
            )
          ],
        ),
      ),
    );
  }
}

class Drawer1 extends StatefulWidget {
  const Drawer1({Key? key}) : super(key: key);

  @override
  State<Drawer1> createState() => _Drawer1State();
}

class _Drawer1State extends State<Drawer1> {
  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    return Drawer(
      backgroundColor: ColorConst.whiteColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage("assets/images/bg.jpeg"),
              ),
            ),
            accountName: Text(
              name.toString(),
              style: const TextStyle(
                color: ColorConst.whiteColor,
              ),
            ),
            accountEmail: Text(
              email.toString(),
              style: const TextStyle(
                color: ColorConst.whiteColor,
              ),
            ),
            currentAccountPicture: Container(
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                  ),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(profilePic.toString()),
                  )),
            ),
            // CircleAvatar(
            //   child: ClipOval(
            //     child: profilePic == "assets/images/default_image.png"
            //         ? Image.asset(StringConst.defaultImage)
            //         : Image.network(profilePic.toString()),
            //   ),
            // ),
          ),
          ListTile(
              leading: const Icon(Icons.home),
              title: const Text("Home"),
              onTap: () {
                if (Get.currentRoute == '/' ||
                    Get.currentRoute == '/HomeScreen') {
                  Get.back();
                }
              }),
          const Divider(height: 0),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Logout"),
            onTap: () async {
              Navigator.pop(context);
              ap.userSignOut().then((value) => Navigator.of(context)
                  .pushAndRemoveUntil(
                      MaterialPageRoute(builder: (c) => WelcomeScreen()),
                      (route) => false));
            },
          ),
        ],
      ),
    );
  }
}
