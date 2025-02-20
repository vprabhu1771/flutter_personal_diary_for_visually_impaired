import 'package:flutter/material.dart';


import 'package:url_launcher/url_launcher.dart';

import 'contact/CallLogScreen.dart';
import 'contact/MobileContactScreen.dart';

class ContactScreen extends StatefulWidget {

  final String title;

  const ContactScreen({super.key, required this.title});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> with SingleTickerProviderStateMixin {

  late TabController _tabController;

  final List<Widget> screenList = [
    const MobileContactScreen(title: 'Mobile Contact',),
    const CallLogScreen(title: 'Call Logs'),
    // const DialerScreen(title: 'Dialer'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: screenList.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        bottom:TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              text: "Contacts",
            ),
            Tab(
                text:"Call Logs"
            ),
            // Tab(
            //     text:"Dialer"
            // )
          ],
        ),
      ),

      body: TabBarView(
        controller: _tabController,
        children: screenList,
      ),
    );
  }
}