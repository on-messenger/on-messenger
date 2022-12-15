import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  late String _idUserLogged;
  late String nameRetriver;
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
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Criar publicação',
          textAlign: TextAlign.center,
        ),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 25, right: 15, top: 15, bottom: 15),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50.0),
                    child: CircleAvatar(
                      radius: 35,
                      backgroundColor: Theme.of(context).primaryColorLight,
                      backgroundImage: NetworkImage(_urlImageRetrieved),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _controllerName,
                        textDirection: TextDirection.ltr,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),

                      // Row(
                      //   children: const [
                      //     Icon(
                      //       Icons.business,
                      //       color: greyColor,
                      //       size: 18,
                      //     ),
                      //   ],
                      // )
                    ],
                  ),
                ),
              ],
            ),
            Container(
              width: size.width,
              height: 90,
              margin: const EdgeInsets.only(left: 5, right: 5),
              child: Form(
                key: _globalKey,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: TextFormField(
                    controller: _postTextController,
                    maxLines: 5,
                    minLines: 1,
                    decoration: const InputDecoration(
                      focusedBorder: InputBorder.none,
                      border: InputBorder.none,
                      hintText: "Digite uma tarefa...",
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10, left: 5),
                  child: Image.asset(
                    "icon.png",
                    height: 35,
                  ),
                ),
                const Text(
                  "Selecione uma imagem",
                ),
              ]),
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
                  onPressed: () {},
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.grey),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  child: const Text("Publicar")),
            )
          ],
        ),
      ),
    );
  }
}
