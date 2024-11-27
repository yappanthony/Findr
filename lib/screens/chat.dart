import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;

final supabase = Supabase.instance.client;

final user = supabase.auth.currentUser;
final authID = user?.id ?? '';

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
  List<dynamic> dbMessages = [];


  void _sendMessage() async {
    if (_controller.text.isNotEmpty) {
      setState(() {
        messages.add(Message(
          text: _controller.text,
          date: DateTime.now(),
          isSentByMe: true,
        ));
      });
      try {
        final response = await supabase.from('messages').insert([
          {'message': _controller.text, 'sender': authID, 'receiver': '542b223c-be97-4377-b560-ed0822f85f07'},
        ]);
      } catch (e) {
        print('Exception: $e');
      }
      _controller.clear();
    }
  }
  
  @override
  void initState() {
    super.initState();
    fetchMessages();
    
  }

  Future<void> fetchMessages() async {
    try {
      final response = await supabase
        .from('messages')
        .select('*, date:created_at')
        .or('sender.eq.$authID,receiver.eq.$authID')
        .order('created_at', ascending: true);

      dbMessages = List<Map<String, dynamic>>.from(response);

      setState(() {
        messages.addAll(
          dbMessages.map((message) {
            return Message(
              text: message['message'], 
              date: DateTime.parse(message['date']), 
              isSentByMe: message['sender'] == authID, 
            );
          }).toList()
        );
      });
    } catch (e) {
      print('Exception: $e');
    }
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
                    color: const Color(0xFF451B0A),
                    onPressed: () {
                       context.pop();
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
            child: GroupedListView<Message, DateTime>(
              reverse: true,
              order: GroupedListOrder.DESC,
              padding: const EdgeInsets.all(8),
              elements: messages,
              groupBy: (Message element) => DateTime(element.date.year, element.date.month, element.date.day),
              groupHeaderBuilder: 
                (Message messages) => Center(
                    child: SizedBox(
                      child: Row(
                        children: [
                          const Expanded(
                            child: Divider(
                            color: Color(0xFF451B0A),
                            thickness: 1,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5),
                            child: Text(
                            DateFormat('MMM dd, yyyy').format(messages.date),
                            style: const TextStyle(color: Color(0xFF451B0A)),
                            ),
                          ),
                          const Expanded(
                            child: Divider(
                            color: Color(0xFF451B0A),
                            thickness: 1,
                            ),
                          ),
                        ],
                      ),
                    )
                ),
              itemBuilder: (context, Message messages) => Align(
                alignment: messages.isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
                child: Column(
                crossAxisAlignment: messages.isSentByMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                    Card(
                    color: !messages.isSentByMe ? Colors.white : const Color(0xFF451B0A),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(messages.text, style: TextStyle(color: !messages.isSentByMe ? const Color(0xFF451B0A) : Colors.white),),
                    ),
                    ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      timeago.format(messages.date),
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
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'Enter your message',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: _sendMessage,
                    ),
                  ),
                  onSubmitted: (value) => _sendMessage(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
