import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

class MobileContactScreen extends StatefulWidget {

  final String title;

  const MobileContactScreen({super.key, required this.title});

  @override
  State<MobileContactScreen> createState() => _MobileContactScreenState();
}

class _MobileContactScreenState extends State<MobileContactScreen> {

  List<Contact> _contacts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchContacts();
  }

  Future<void> _fetchContacts() async {
    if (await FlutterContacts.requestPermission()) {
      List<Contact> contacts = await FlutterContacts.getContacts(withProperties: true);
      setState(() {
        _contacts = contacts;
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text('Contacts')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _contacts.isEmpty
          ? Center(child: Text('No contacts found'))
          : ListView.builder(
        itemCount: _contacts.length,
        itemBuilder: (context, index) {
          final contact = _contacts[index];
          return ListTile(
            leading: CircleAvatar(
              child: Text(contact.displayName[0]),
            ),
            title: Text(contact.displayName),
            subtitle: Text(contact.phones.isNotEmpty ? contact.phones.first.number : 'No number'),
          );
        },
      ),
    );
  }
}