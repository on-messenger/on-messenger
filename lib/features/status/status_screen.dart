import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:on_messenger/common/utils/colors.dart';
import 'package:on_messenger/features/task/screen/task_screen.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class QuickHelp {
  static goToNavigationScreen(Widget widget, BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => widget));
  }
}

class _FeedScreenState extends State<FeedScreen> {
  late String _idUserLogged;
  String _urlImageRetrieved = "";
  String _controllerName = "";

  _retrieveDataUser() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User userLogged = auth.currentUser!;
    _idUserLogged = userLogged.uid;

    FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentSnapshot snapshot =
        await db.collection("users").doc(_idUserLogged).get();

    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

    _controllerName = data["name"];

    if (data["profilePic"] != null) {
      _urlImageRetrieved = data["profilePic"];
      setState(() {
        _urlImageRetrieved = data["profilePic"];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _retrieveDataUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 25, left: 25, bottom: 25),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50.0),
                  child: CircleAvatar(
                    radius: 35,
                    backgroundColor: Theme.of(context).primaryColorLight,
                    backgroundImage: NetworkImage(_urlImageRetrieved),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 30, bottom: 30, right: 30, left: 15),
                child: ActionChip(
                  label: Text(
                    'No que você esta pensando, $_controllerName?',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: QuickHelp.goToNavigationScreen(
                            TaskStateScreen(), context),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget post({
    required String userImage,
    required String userName,
    required String postDate,
    required String postText,
    required String postImage,
  }) {
    var size = MediaQuery.of(context).size;

    return Container(
      margin: const EdgeInsets.only(top: 5, bottom: 5),
      color: Colors.white,
      width: size.width,
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50.0),
                  child: Image.asset(
                    userImage,
                    height: 50,
                    width: 50,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      postDate,
                    )
                  ],
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(right: 10, left: 5),
                  child: Image.asset(
                    "icon.png",
                    height: 35,
                    color: greyColor,
                  )),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              postText,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Stack(
            children: [
              Container(
                width: size.width,
                height: 400,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                        postImage,
                      ),
                      fit: BoxFit.cover),
                ),
              ),
              ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: SizedBox(
                    width: size.width,
                    height: 400,
                  ),
                ),
              ),
              Center(
                child: Container(
                  width: 250,
                  height: 400,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(
                          postImage,
                        ),
                        fit: BoxFit.cover),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          Container(
            margin: const EdgeInsets.only(left: 10, right: 10),
            width: size.width,
            height: 0.5,
            color: greyColor,
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                const SizedBox(
                  width: 10,
                ),
                Image.asset(
                  "assets/svg/ic_post_like.svg",
                  color: greyColor,
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 5),
                  child: Text(
                    '4',
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Image.asset("assets/svg/ic_post_comment.svg", color: greyColor),
                const Padding(
                  padding: EdgeInsets.only(left: 5),
                  child: Text(
                    '14',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
