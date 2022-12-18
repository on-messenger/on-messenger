class ToDo {
  String senderId;
  String recieverId;
  DateTime timeSent;
  String? id;
  String? todoText;
  bool isSeen;
  bool isDone;

  ToDo(
      {required this.senderId,
      required this.recieverId,
      required this.timeSent,
      required this.id,
      required this.todoText,
      required this.isSeen,
      required this.isDone});

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'recieverid': recieverId,
      'timeSent': timeSent.millisecondsSinceEpoch,
      'id': id,
      'todoText': todoText,
      'isSeen': isSeen,
      'isDone': isDone
    };
  }

  factory ToDo.fromMap(Map<String, dynamic> map) {
    return ToDo(
        senderId: map['senderId'] ?? '',
        recieverId: map['recieverid'] ?? '',
        timeSent: DateTime.fromMillisecondsSinceEpoch(map['timeSent']),
        todoText: map['todoText'] ?? '',
        id: map['id'] ?? '',
        isSeen: map['isSeen'] ?? false,
        isDone: map['isDone'] ?? false);
  }
}
