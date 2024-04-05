class MessageModel {
  final String description;
  final bool isMe;

  MessageModel({required this.description, this.isMe = true});
}

final List<MessageModel> listMessageFake = [
  MessageModel(description: 'Yes'),
  MessageModel(description: 'This is your github?', isMe: false),
  MessageModel(description: 'https://github.com/lambiengcode', isMe: false),
  MessageModel(description: 'Hi, lambiengcode'),
];
