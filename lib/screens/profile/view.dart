import 'package:client/services/storage.dart';
import 'package:flutter/material.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(automaticallyImplyActions: true),
        body: Column(),
        bottomNavigationBar: Expanded(
          child: TextButton(
            onPressed: () {
              StorageService().emptyStorage();
              Navigator.of(context).pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
            },
            child: Text("quit"),
          ),
        ),
      ),
    );
  }
}
