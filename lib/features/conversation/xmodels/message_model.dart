class MessageModel {
  final String description;
  final bool isMe;

  MessageModel({required this.description, this.isMe = true});
}

final List<MessageModel> listMessageFake = [
  MessageModel(description: 'Hello'),
  MessageModel(description: 'Hi', isMe: false),
  MessageModel(
    description: "Let's go on vacation. I have exciting vacation plans!",
    isMe: false,
  ),
  MessageModel(description: 'Hi', isMe: false),
  MessageModel(
    description: "Let's go on vacation. I have exciting vacation plans!",
    isMe: false,
  ),
  MessageModel(
    description: "Let's go on vacation. What's the plan?",
  ),
  MessageModel(description: 'Hi', isMe: false),
  MessageModel(
    description: "Let's go on vacation. I have exciting vacation plans!",
    isMe: false,
  ),
  MessageModel(
    description: "Let's go on vacation. What's the plan?",
  ),
  MessageModel(description: 'Hello'),
  MessageModel(description: 'Hi', isMe: false),
  MessageModel(
    description: "Let's go on vacation. I have exciting vacation plans!",
    isMe: false,
  ),
  MessageModel(
    description: "Let's go on vacation. What's the plan?",
  ),
  MessageModel(description: 'Hello'),
  MessageModel(description: 'Hi', isMe: false),
  MessageModel(
    description: "Let's go on vacation. I have exciting vacation plans!",
    isMe: false,
  ),
  MessageModel(
    description: "Let's go on vacation. What's the plan?",
  ),
];
