import 'package:flutter/material.dart';
import 'package:on_messenger/common/utils/colors.dart';

class PostCreation extends StatefulWidget {
  const PostCreation({Key? key}) : super(key: key);

  @override
  State<PostCreation> createState() => _PostCreationState();
}

class _PostCreationState extends State<PostCreation> {

  final _globalKey = GlobalKey<FormState>();
  final _postTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0.2,
        backgroundColor: Colors.white,
        leading: const BackButton(color: Colors.black,),
        centerTitle: false,
        title: const Text(
          "Criar post",
          style: TextStyle(
                  color: Colors.black
                ),
        ),
        actions: [
          TextButton(
              onPressed: (){},
              child: const Text(
                "Publicar",
                style:TextStyle(
                  color: Colors.black
                ),
              ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50.0),
                    child: Image.asset("icon.png",
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
                      Text("Chancilson Smart Lion",
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.public,
                            color: greyColor,
                            size: 18,
                          ),
                          Text("Share with the public",
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(left: 10, right: 10, top: 3),
              width: size.width,
              height: 0.5,
              color: greyColor.withOpacity(0.3),
            ),
            Container(
              width: size.width,
              height: 90,
              color: greyColor.withOpacity(0.15),
              child: Form(
                key: _globalKey,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: TextFormField(
                    controller: _postTextController,
                    maxLines: 5,
                    minLines:1,
                    decoration: InputDecoration(
                      focusedBorder: InputBorder.none,
                      border: InputBorder.none,
                      hintText: "What are you thinking?",
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10, left: 5),
                    child: Image.asset(
                      "user_null.png",
                      color: greyColor,
                      height: 35,
                    ),
                  ),
                  Text(
                      "Picture",
                  ),
                ]
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              width: size.width,
              height: 0.5,
              color: greyColor.withOpacity(0.3),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20, left: 10, right: 10),
              width: size.width,
              height: 50,
              child: ElevatedButton(
                onPressed: (){},
                child: Text(
                    "Publish"),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.grey),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  )
              ),
            )
          ],
        ),
      ),
    );
  }
}