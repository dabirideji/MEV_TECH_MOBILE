import 'package:flutter/material.dart';
import 'package:mevtech/features/chat/mock/mock_models.dart';
import 'package:mevtech/features/chat/widget/main_chat_layout.dart';

class TestingPage extends StatefulWidget {
  const TestingPage({super.key});

  @override
  State<TestingPage> createState() => _TestingPageState();
}

class _TestingPageState extends State<TestingPage> {
  TextEditingController txtMesaage = TextEditingController();

  final channels = MockUtility.channels;
  List<Message> messages = [];

  List<Message> loadCurrentMessages(Channel channel) {
    final channels = MockUtility.channels;

    final result = channels.firstWhere((c) => c == channel);
    final messages = result.messages;

    return messages;
  }

  void sendMsg(String content) {
    final channel = channels.first;

    var messages = List<Message>.from(channel.messages);

    final newMessage = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: 'User_1',
      username: 'nero',
      content: content,
      timestamp: DateTime.now(),
    );

    // final result = [...messages, newMessage];
    messages.add(newMessage);
    setState(() {
      // messages = result;
    });
  }

  @override
  void initState() {
    super.initState();
    messages = loadCurrentMessages(channels[0]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Testing class'),
      ),
      // body: MainChatLayout(
      //   channels: channels,
      //   selectedChannelId: 'default',
      //   messages: messages,
      //   onTapChannel: (id) {
      //     // context.pushReplacementNamed(
      //     //   AppRouter.chat,
      //     //   pathParameters: {'channelId': id},
      //     // );
      //   },
      //   txtMessage: txtMesaage,
      //   onMessageSend: txtMesaage.text.isEmpty
      //       ? null
      //       : () {
      //           sendMsg(txtMesaage.text);
      //           // txtMesaage.clear();
      //         },
      // ),
    );
  }
}

class CourseDetail01 extends StatelessWidget {
  const CourseDetail01({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 100,
          height: 200,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/Basics of Accounting.jpg'),
              fit: BoxFit.fill,
            ),
          ),
        ),
      ],
    );
  }
}
