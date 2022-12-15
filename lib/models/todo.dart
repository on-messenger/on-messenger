class ToDo {
<<<<<<< HEAD
  String senderId;
  String recieverId;
  DateTime timeSent;
  String? id;
  String? todoText;
  bool isSeen;
  bool isDone;

  ToDo({
    required this.senderId,
    required this.recieverId,
    required this.timeSent,
    required this.id,
    required this.todoText,
    required this.isSeen,
    required this.isDone
  });

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
        isDone: map['isDone'] ?? false
    );
=======
  String? id;
  String? todoText;
  bool isDone;

  ToDo({
    required this.id,
    required this.todoText,
    this.isDone = false,
  });

  static List<ToDo> todoList() {
    return [
      ToDo(id: '01', todoText: 'Morning Excercise', isDone: true ),
      ToDo(id: '02', todoText: 'Buy Groceries', isDone: true ),
      ToDo(id: '03', todoText: 'Check Emails', ),
      ToDo(id: '04', todoText: 'Team Meeting', ),
      ToDo(id: '05', todoText: 'Work on mobile apps for 2 hour', ),
      ToDo(id: '06', todoText: 'Dinner with Jenny', ),
    ];
>>>>>>> bac0d1285ea17eb62fe02f29730f0797c337db91
  }
}