import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_messenger/features/select_contacts/repository/select_contact_repository.dart';
import 'package:flutter/material.dart';

import '../../chat/screens/mobile_chat_screen.dart';

final selectContactControllerProvider = Provider((ref) {
  final selectContactRepository = ref.watch(selectContactsRepositoryProvider);
  return SelectContactController(
    ref: ref,
    selectContactRepository: selectContactRepository,
  );
});

class SelectContactController {
  final ProviderRef ref;
  final SelectContactRepository selectContactRepository;

  SelectContactController({
    required this.ref,
    required this.selectContactRepository,
  });

  void selectContact(Contact selectedContact, BuildContext context) {
    selectContactRepository.selectContact(selectedContact, context);
  }
}

class SearchcCt extends StatefulWidget {
  const SearchcCt({Key? key}) : super(key: key);

  @override
  State<SearchcCt> createState() => _SearchcCtState();
}

class _SearchcCtState extends State<SearchcCt> {
  final searchController = TextEditingController();
  var doc = FirebaseFirestore.instance.collection('users').snapshots();


  @override
  void initState() {
    super.initState();
    searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.dispose();
  }

  _onSearchChanged() {
    if (kDebugMode) {
      print(searchController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: searchController,
          decoration: const InputDecoration(
            hintText: 'Search',
            border: InputBorder.none,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () => Navigator.pushNamed(
                    context,
                    MobileChatScreen.routeName,
                    arguments: {
                      'name': snapshot.data?.docs[index]['name'] ?? '',
                      'uid': snapshot.data?.docs[index]['uid'] ?? '',
                      'profilePic': snapshot.data?.docs[index]['profilePic'] ?? '',
                      'isGroupChat': snapshot.data?.docs[index]['isGroupChat'] ?? '',
                    },
                  ),
                  title: Text(snapshot.data!.docs[index]['name']),
                  subtitle: Text(snapshot.data!.docs[index]['email']),
                );
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
