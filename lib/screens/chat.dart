import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

final user = supabase.auth.currentUser;
final fullName = user?.userMetadata?['full_name'];

class Message {
  final String text;
  final DateTime date;
  final bool isSentByMe;

  Message({required this.text, required this.date, required this.isSentByMe});
}

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final TextEditingController _controller = TextEditingController();
  final List<Message> messages = [];

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        messages.add(Message(
          text: _controller.text,
          date: DateTime.now(),
          isSentByMe: true,
        ));
        _controller.clear();
      });
    }
  }
  
  @override
  void initState() {
    super.initState();
    messages.addAll([
      Message(text: 'Hello!', date: DateTime.now(), isSentByMe: false),
      Message(text: 'How can I help you today?', date: DateTime.now(), isSentByMe: false),
      Message(text: 'Please provide more details.', date: DateTime.now(), isSentByMe: false),
      Message(text: 'I need assistance with my account.', date: DateTime.now(), isSentByMe: true),
      Message(text: 'Sure, what seems to be the problem?', date: DateTime.now(), isSentByMe: false),
      Message(text: 'I am unable to login.', date: DateTime.now(), isSentByMe: true),
      Message(text: 'Have you tried resetting your password?', date: DateTime.now(), isSentByMe: false),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                  child: IconButton(
                    hoverColor: Colors.white,
                    highlightColor: Colors.white,
                    color: Color(0xFF451B0A),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const FaIcon(
                      FontAwesomeIcons.arrowLeft,
                      size: 20,),
                  ),
                ),
              const Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  "Admin Chat",
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Roboto',
                  ),
                ),
              ),
            ],
          ),
            Expanded(
            child: 
              GroupedListView<Message, DateTime>(
              padding: const EdgeInsets.all(8),
              elements: messages,
              groupBy: (Message element) => element.date,
              groupHeaderBuilder: (Message messages) => SizedBox(),
              itemBuilder: (context, Message messages) => Align(
                alignment: messages.isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
                child: Column(
                crossAxisAlignment: messages.isSentByMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                    Card(
                    color: Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(messages.text),
                    ),
                    ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      DateFormat('kk:mm').format(messages.date),
                      style: const TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  )
                ],
                ),
              ),
              )
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Enter your message',
                    ),
                    onSubmitted: (value) => _sendMessage(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
