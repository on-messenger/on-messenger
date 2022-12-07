import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';

class Configuration extends StatefulWidget {
  const Configuration({Key? key}) : super(key: key);
  static const String routeName = '/user-configuration';
  @override
  State<Configuration> createState() => _ConfigurationState();
}

class _ConfigurationState extends State<Configuration> {
  final TextEditingController _controllerName = TextEditingController();
  late XFile _image;
  late String _idUserLogged;
  String _urlImageRetrieved = "";

  bool _uploadingImage = false;

  _retrieveImage(String originImage) async {
    late XFile imageSelected;
    switch (originImage) {
      case "camera":
        // ignore: invalid_use_of_visible_for_testing_member
        imageSelected = (await ImagePicker.platform.getImage(
          source: ImageSource.camera,
          maxWidth: null,
          maxHeight: null,
          imageQuality: null,
          preferredCameraDevice: CameraDevice.rear,
        )) as XFile;
        break;
      case "galeria":
        // ignore: invalid_use_of_visible_for_testing_member
        imageSelected = (await ImagePicker.platform.getImage(
          source: ImageSource.gallery,
          maxWidth: null,
          maxHeight: null,
          imageQuality: null,
          preferredCameraDevice: CameraDevice.rear,
        )) as XFile;
        break;
    }
    setState(() {
      _image = imageSelected;
      _uploadingImage = true;
      _uploadImage();
    });
  }

  _updateNameFirestore() {
    String name = _controllerName.text;
    FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentReference ref = db.collection("users").doc(_idUserLogged);
    ref.update({'name': name});
  }

  Future _uploadImage() async {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference dirRoot = storage.ref();
    Reference arquivo = dirRoot.child("perfil").child("$_idUserLogged.jpg");

    final File imagefile = File(_image.path);

    UploadTask task = arquivo.putFile(imagefile);

    _updateUrlImageFirestore(String urlImg) async {
      FirebaseFirestore db = FirebaseFirestore.instance;

      Map<String, dynamic> updateData = {'urlImg': urlImg};

      DocumentReference ref = db.collection('users').doc(_idUserLogged);
      await ref.update(updateData);
    }

    Future _retrieveUrlImage(TaskSnapshot taskSnapshot) async {
      String url = await taskSnapshot.ref.getDownloadURL();
      _updateUrlImageFirestore(url);
      setState(() {
        _urlImageRetrieved = url;
      });
    }

    task.snapshotEvents.listen((TaskSnapshot taskSnapshot) {
      if (taskSnapshot.state == TaskState.running) {
        setState(() {
          _uploadingImage = true;
        });
      } else if (taskSnapshot.state == TaskState.success) {
        _retrieveUrlImage(taskSnapshot);
        setState(() {
          _uploadingImage = false;
        });
      }
    });
  }

  _retrieveDataUser() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User userLogged = auth.currentUser!;
    _idUserLogged = userLogged.uid;

    FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentSnapshot snapshot =
        await db.collection("users").doc(_idUserLogged).get();

    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    _controllerName.text = data["name"];

    if (data["urlImage"] != null) {
      _urlImageRetrieved = data["urlImage"];
      setState(() {
        _urlImageRetrieved = data["urlImage"];
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
      appBar: AppBar(title: const Text("Configuracoes")),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
              child: Column(
            children: <Widget>[
              Container(
                  padding: const EdgeInsets.all(16),
                  child: _uploadingImage
                      ? const CircularProgressIndicator()
                      : Container()),
              CircleAvatar(
                radius: 100,
                backgroundColor: Theme.of(context).primaryColorLight,
                // ignore: unnecessary_null_comparison
                backgroundImage: _urlImageRetrieved != null
                    ? NetworkImage(_urlImageRetrieved)
                    : null,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextButton(
                    child: const Text("Galeria"),
                    onPressed: () {
                      _retrieveImage("galeria");
                    },
                  ),
                  TextButton(
                    child: const Text("Camera"),
                    onPressed: () {
                      _retrieveImage("camera");
                    },
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: TextField(
                    controller: _controllerName,
                    keyboardType: TextInputType.text,
                    style: TextStyle(
                        fontSize: 20,
                        color: Theme.of(context).secondaryHeaderColor),
                    decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.fromLTRB(32, 16, 32, 16),
                        hintText: 'Nome',
                        filled: true,
                        fillColor: Colors.white70,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32)))),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 10),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).primaryColorDark,
                        padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32))),
                    onPressed: () {
                      _updateNameFirestore();
                    },
                    child: Text(
                      "Salvar",
                      style: TextStyle(
                          color: Theme.of(context).primaryColorLight,
                          fontSize: 20),
                    )),
              ),
            ],
          )),
        ),
      ),
    );
  }
}
