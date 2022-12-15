import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controller/task_controller.dart';

class BottomTaskField extends ConsumerStatefulWidget {
  const BottomTaskField({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<BottomTaskField> createState() => _BottomTaskFieldState();
}

class _BottomTaskFieldState extends ConsumerState<BottomTaskField> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final TextEditingController _todoTextController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  FocusNode focusNode = FocusNode();

  void showKeyboard() => focusNode.requestFocus();
  void hideKeyboard() => focusNode.unfocus();

  void _addToDoItem(context, String toDo) {
    String recieverEmail = _emailController.text;

    ref.read(taskControllerProvider).sendTextTask(
        context: context,
        senderId: auth.currentUser!.uid,
        recieverEmail: recieverEmail,
        todoText: toDo,
        isSeen: false,
        isDone: false);
  }

  @override
  void dispose() {
    super.dispose();
    _todoTextController.dispose();
    _emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Column(
        children: [
          const SizedBox(width: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey,
                border:
                    Border.all(color: const Color.fromARGB(255, 237, 224, 224)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: TextField(
                  controller: _todoTextController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Digite a tarefa',
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey,
                border:
                    Border.all(color: const Color.fromARGB(255, 237, 224, 224)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Digite o email do funcionario',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      Container(
        margin: const EdgeInsets.only(
          top: 5,
          bottom: 20,
          right: 20,
        ),
        child: ElevatedButton(
          onPressed: () {
            _addToDoItem(context, _todoTextController.text);
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.blue,
            minimumSize: const Size(900, 60),
            maximumSize: const Size(900, 60),
            elevation: 10,
          ),
          child: const Text(
            '+',
            style: TextStyle(
              fontSize: 40,
            ),
          ),
        ),
      ),
    ]);
  }
}
