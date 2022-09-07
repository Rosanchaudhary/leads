import 'package:flutter/material.dart';
import 'package:leads/view/leads_screen.dart';
import 'package:leads/view/message_screen.dart';
import 'package:leads/view/request_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 100,
          elevation: 0.0,
          backgroundColor: Colors.white,
          bottom: const TabBar(
            indicatorColor: Colors.black,
            tabs: [
              Tab(
                child: Text(
                  "Leads",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              Tab(
                child: Text(
                  "Messages",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              Tab(
                child: Text(
                  "Requests",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
          title: const Text(
            'MESSAGES',
            style: TextStyle(fontSize: 22, color: Colors.black),
          ),
        ),
        body: TabBarView(
          children: [
            LeadScreen(),
            const MessageScreen(),
            const RequestScreen()
          ],
        ),
      ),
    );
    
  }
}
