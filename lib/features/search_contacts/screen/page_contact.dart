import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:on_messenger/common/utils/colors.dart';
import 'package:on_messenger/features/chat/screens/mobile_chat_screen.dart';
import 'package:on_messenger/features/search_contacts/screen/search_contact.dart';

// final selectContactControllerProvider = Provider((ref) {
//   final selectContactRepository = ref.watch(selectContactsRepositoryProvider);
//   return SelectContactController(
//     ref: ref,
//     selectContactRepository: selectContactRepository,
//   );
// });

// class SelectContactController {
//   final ProviderRef ref;
//   final SelectContactRepository selectContactRepository;

//   SelectContactController({
//     required this.ref,
//     required this.selectContactRepository,
//   });

//   void selectContact(Contact selectedContact, BuildContext context) {
//     selectContactRepository.selectContact(selectedContact, context);
//   }
// }

class PageContact extends StatefulWidget {
  const PageContact({Key? key}) : super(key: key);

  @override
  State<PageContact> createState() => _PageContactState();
}

class _PageContactState extends State<PageContact> {
  final ref = FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MobileChatScreen(
                          name: snapshot.data!.docs[index]['name'],
                          uid: snapshot.data!.docs[index]['uid'],
                          isGroupChat: false,
                          profilePic: snapshot.data!.docs[index]['profilePic'],
                        ),
                      ),
                    );
                  },
                  title: Text(snapshot.data!.docs[index]['name']),
                  subtitle: Text(snapshot.data!.docs[index]['email']),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                      snapshot.data!.docs[index]['profilePic'],
                    ),
                  ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SearchContact(),
            ),
          );
        },
        backgroundColor: appBarColor,
        child: const Icon(
          Icons.search,
          color: Colors.white,
        ),
      ),
    );
  }
}
