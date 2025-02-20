import 'package:flutter/material.dart';
import 'package:another_telephony/telephony.dart';

class MessageScreen extends StatefulWidget {
  final String title;

  const MessageScreen({super.key, required this.title});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final Telephony telephony = Telephony.instance;
  List<SmsMessage> messages = [];

  @override
  void initState() {
    super.initState();
    fetchMessages();
  }

  Future<void> fetchMessages() async {
    bool? permissionsGranted = await telephony.requestSmsPermissions;
    if (permissionsGranted ?? false) {
      List<SmsMessage> smsList = await telephony.getInboxSms(
        columns: [SmsColumn.ADDRESS, SmsColumn.BODY],
        sortOrder: [OrderBy(SmsColumn.DATE, sort: Sort.DESC)],
      );
      setState(() {
        messages = smsList;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: messages.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: messages.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              leading: Icon(Icons.message, color: Colors.blueAccent),
              title: Text(messages[index].address ?? "Unknown"),
              subtitle: Text(messages[index].body ?? ""),
            ),
          );
        },
      ),
    );
  }
}