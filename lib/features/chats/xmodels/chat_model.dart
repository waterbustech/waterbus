enum StatusSeenMessage {
  unseen,
  seen,
}

enum StatusMessage {
  none,
  file,
  endCall,
  missCall,
}

class ChatModel {
  final List<String> urlImage;
  final String title;
  final String lastestMessage;
  final bool typing;
  final int countUnreadMessage;
  final String dateTime;
  final StatusSeenMessage statusLastedMessage;
  final StatusMessage statusMessage;
  ChatModel({
    required this.urlImage,
    required this.title,
    required this.lastestMessage,
    this.typing = false,
    required this.countUnreadMessage,
    required this.dateTime,
    required this.statusLastedMessage,
    this.statusMessage = StatusMessage.none,
  });

  ChatModel copyWith({
    List<String>? urlImage,
    String? title,
    String? lastestMessage,
    bool? typing,
    int? countUnredMessage,
    String? dateTime,
    StatusSeenMessage? statusLastedMessage,
    StatusMessage? statusMessage,
  }) {
    return ChatModel(
      urlImage: urlImage ?? this.urlImage,
      title: title ?? this.title,
      lastestMessage: lastestMessage ?? this.lastestMessage,
      typing: typing ?? this.typing,
      countUnreadMessage: countUnredMessage ?? countUnreadMessage,
      dateTime: dateTime ?? this.dateTime,
      statusLastedMessage: statusLastedMessage ?? this.statusLastedMessage,
      statusMessage: statusMessage ?? this.statusMessage,
    );
  }

  bool get isGroup => urlImage.length > 1;
}

final List<ChatModel> listFakeChat = [
  ChatModel(
    urlImage: [
      'https://images.unsplash.com/photo-1533973860717-d49dfd14cf64?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mzh8fG1vZGVsfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=900&q=60',
    ],
    title: 'Wade Warren',
    lastestMessage: "Don't forget karaoke at 10pm",
    countUnreadMessage: 2,
    dateTime: '04:01 am',
    statusLastedMessage: StatusSeenMessage.unseen,
  ),
  ChatModel(
    urlImage: [
      'https://images.unsplash.com/photo-1524638431109-93d95c968f03?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NDB8fG1vZGVsfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=900&q=60',
    ],
    title: 'Lestin Kejora',
    lastestMessage: "Wow look amazing 🤗",
    countUnreadMessage: 0,
    dateTime: '04:02 am',
    statusLastedMessage: StatusSeenMessage.seen,
  ),
  ChatModel(
    urlImage: [
      'https://plus.unsplash.com/premium_photo-1667810132017-c40be88c6b25?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTN8fG1vZGVsfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=900&q=60',
    ],
    title: 'Zahri K.',
    lastestMessage: "Don't forget karaoke at 10pm",
    countUnreadMessage: 0,
    dateTime: '04:04 am',
    typing: true,
    statusLastedMessage: StatusSeenMessage.unseen,
  ),
  ChatModel(
    urlImage: [
      'https://images.unsplash.com/photo-1621784563330-caee0b138a00?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NDh8fG1vZGVsfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=900&q=60',
      'https://images.unsplash.com/photo-1524638431109-93d95c968f03?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NDB8fG1vZGVsfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=900&q=60',
      'https://plus.unsplash.com/premium_photo-1667810132017-c40be88c6b25?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTN8fG1vZGVsfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=900&q=60',
      'https://plus.unsplash.com/premium_photo-1667810132017-c40be88c6b25?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTN8fG1vZGVsfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=900&q=60',
      'https://plus.unsplash.com/premium_photo-1667810132017-c40be88c6b25?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTN8fG1vZGVsfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=900&q=60',
    ],
    title: 'Group Chat 🌈',
    lastestMessage: "Don't forget karaoke at 10pm",
    countUnreadMessage: 71,
    dateTime: '09:01 pm',
    statusLastedMessage: StatusSeenMessage.seen,
  ),
  ChatModel(
    urlImage: [
      'https://plus.unsplash.com/premium_photo-1667810132017-c40be88c6b25?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTN8fG1vZGVsfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=900&q=60',
    ],
    title: 'Marzuki Ali',
    lastestMessage: '',
    countUnreadMessage: 2,
    dateTime: '04:01 am',
    statusMessage: StatusMessage.endCall,
    statusLastedMessage: StatusSeenMessage.seen,
  ),
  ChatModel(
    urlImage: [
      'https://images.unsplash.com/photo-1524638431109-93d95c968f03?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NDB8fG1vZGVsfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=900&q=60',
    ],
    title: 'Lestin Kejora',
    lastestMessage: "Wow look amazing 🤗",
    countUnreadMessage: 0,
    dateTime: '04:02 am',
    statusLastedMessage: StatusSeenMessage.seen,
  ),
  ChatModel(
    urlImage: [
      'https://plus.unsplash.com/premium_photo-1667810132017-c40be88c6b25?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTN8fG1vZGVsfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=900&q=60',
    ],
    title: 'Zahri K.',
    lastestMessage: "Don't forget karaoke at 10pm",
    countUnreadMessage: 0,
    dateTime: '04:04 am',
    typing: true,
    statusLastedMessage: StatusSeenMessage.unseen,
  ),
  ChatModel(
    urlImage: [
      'https://images.unsplash.com/photo-1621784563330-caee0b138a00?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NDh8fG1vZGVsfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=900&q=60',
      'https://plus.unsplash.com/premium_photo-1667810132017-c40be88c6b25?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTN8fG1vZGVsfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=900&q=60',
      'https://plus.unsplash.com/premium_photo-1667810132017-c40be88c6b25?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTN8fG1vZGVsfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=900&q=60',
      'https://plus.unsplash.com/premium_photo-1667810132017-c40be88c6b25?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTN8fG1vZGVsfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=900&q=60',
    ],
    title: 'Group Chat 🌈',
    lastestMessage: "Don't forget karaoke at 10pm",
    countUnreadMessage: 2,
    dateTime: '09:01 pm',
    statusLastedMessage: StatusSeenMessage.seen,
  ),
  ChatModel(
    urlImage: [
      'https://images.unsplash.com/photo-1533973860717-d49dfd14cf64?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mzh8fG1vZGVsfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=900&q=60',
    ],
    title: 'Wade Warren',
    lastestMessage: "Don't forget karaoke at 10pm",
    countUnreadMessage: 2,
    dateTime: '04:01 am',
    statusLastedMessage: StatusSeenMessage.unseen,
  ),
  ChatModel(
    urlImage: [
      'https://images.unsplash.com/photo-1524638431109-93d95c968f03?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NDB8fG1vZGVsfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=900&q=60',
    ],
    title: 'Lestin Kejora',
    lastestMessage: "Wow look amazing 🤗",
    countUnreadMessage: 0,
    dateTime: '04:02 am',
    statusLastedMessage: StatusSeenMessage.seen,
  ),
  ChatModel(
    urlImage: [
      'https://plus.unsplash.com/premium_photo-1667810132017-c40be88c6b25?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTN8fG1vZGVsfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=900&q=60',
    ],
    title: 'Zahri K.',
    lastestMessage: "Don't forget karaoke at 10pm",
    countUnreadMessage: 0,
    dateTime: '04:04 am',
    typing: true,
    statusLastedMessage: StatusSeenMessage.unseen,
  ),
  ChatModel(
    urlImage: [
      'https://images.unsplash.com/photo-1621784563330-caee0b138a00?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NDh8fG1vZGVsfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=900&q=60',
      'https://plus.unsplash.com/premium_photo-1667810132017-c40be88c6b25?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTN8fG1vZGVsfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=900&q=60',
      'https://plus.unsplash.com/premium_photo-1667810132017-c40be88c6b25?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTN8fG1vZGVsfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=900&q=60',
      'https://plus.unsplash.com/premium_photo-1667810132017-c40be88c6b25?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTN8fG1vZGVsfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=900&q=60',
    ],
    title: 'Group Chat 🌈',
    lastestMessage: "Don't forget karaoke at 10pm",
    countUnreadMessage: 2,
    dateTime: '09:01 pm',
    statusLastedMessage: StatusSeenMessage.seen,
  ),
  ChatModel(
    urlImage: [
      'https://images.unsplash.com/photo-1533973860717-d49dfd14cf64?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mzh8fG1vZGVsfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=900&q=60',
    ],
    title: 'Wade Warren',
    lastestMessage: "Don't forget karaoke at 10pm",
    countUnreadMessage: 2,
    dateTime: '04:01 am',
    statusLastedMessage: StatusSeenMessage.unseen,
  ),
  ChatModel(
    urlImage: [
      'https://images.unsplash.com/photo-1524638431109-93d95c968f03?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NDB8fG1vZGVsfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=900&q=60',
    ],
    title: 'Lestin Kejora',
    lastestMessage: "Wow look amazing 🤗",
    countUnreadMessage: 0,
    dateTime: '04:02 am',
    statusLastedMessage: StatusSeenMessage.seen,
  ),
  ChatModel(
    urlImage: [
      'https://plus.unsplash.com/premium_photo-1667810132017-c40be88c6b25?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTN8fG1vZGVsfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=900&q=60',
    ],
    title: 'Zahri K.',
    lastestMessage: "Don't forget karaoke at 10pm",
    countUnreadMessage: 0,
    dateTime: '04:04 am',
    typing: true,
    statusLastedMessage: StatusSeenMessage.unseen,
  ),
  ChatModel(
    urlImage: [
      'https://images.unsplash.com/photo-1621784563330-caee0b138a00?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NDh8fG1vZGVsfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=900&q=60',
      'https://plus.unsplash.com/premium_photo-1667810132017-c40be88c6b25?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTN8fG1vZGVsfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=900&q=60',
      'https://plus.unsplash.com/premium_photo-1667810132017-c40be88c6b25?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTN8fG1vZGVsfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=900&q=60',
      'https://plus.unsplash.com/premium_photo-1667810132017-c40be88c6b25?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTN8fG1vZGVsfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=900&q=60',
    ],
    title: 'Group Chat 🌈',
    lastestMessage: "Don't forget karaoke at 10pm",
    countUnreadMessage: 2,
    dateTime: '09:01 pm',
    statusLastedMessage: StatusSeenMessage.seen,
  ),
];
