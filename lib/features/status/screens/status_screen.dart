import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:on_messenger/common/utils/colors.dart';
import 'package:on_messenger/features/status/screens/status_post.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 70.0,
        backgroundColor: appBarColor,
        automaticallyImplyLeading: false,
        leadingWidth: 60,
        title: const Text("Batata"),
        centerTitle: false,
      ),
      
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  QuickHelp.goToNavigationScreen(const PostCreation(), context),
            ),
          );
        },
        backgroundColor: appBarColor,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),

      /* body: ListView(
        children: List.generate(
          Post.users.length,
          (index) => post(
            
              userName: Post.users[index]["user"]["name"],  //TUDO REFERENTE A .POST ESTA PUXANDO AS INFORMAÇÕES LOCALMENTE (DE ACORDO COM O VIDEO) E DEVE SER SUBSTITUIDO PELAS INFORMAÇÕES CONTIDAS NO BANCO DE DADOS.
              postDate: Post.post[index]["post"]["date"],
              postText: Post.post[index]["post"]["text"],
              postImage: Post.post[index]["post"]["picture"],
              userImage: Post.users[index]["user"]["picture"]),
        ),
      ),*/
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
