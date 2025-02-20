import 'package:flutter/material.dart';
import 'package:call_log/call_log.dart';
import 'package:permission_handler/permission_handler.dart';

class CallLogScreen extends StatefulWidget {

  final String title;

  const CallLogScreen({super.key, required this.title});

  @override
  _CallLogScreenState createState() => _CallLogScreenState();
}

class _CallLogScreenState extends State<CallLogScreen> {
  List<CallLogEntry> callLogs = [];

  @override
  void initState() {
    super.initState();
    _getCallLogs();
  }

  Future<void> _getCallLogs() async {
    if (await Permission.phone.request().isGranted) {
      Iterable<CallLogEntry> entries = await CallLog.get();
      setState(() {
        callLogs = entries.toList();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Permission denied")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text("Call Logs")),
      body: callLogs.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: callLogs.length,
        itemBuilder: (context, index) {
          CallLogEntry entry = callLogs[index];
          return ListTile(
            leading: Icon(Icons.call),
            title: Text(entry.name ?? entry.number ?? "Unknown"),
            subtitle: Text(
                "${entry.callType} | Duration: ${entry.duration} sec"),
            trailing: Text(
                "${DateTime.fromMillisecondsSinceEpoch(entry.timestamp ?? 0)}"),
          );
        },
      ),
    );
  }
}