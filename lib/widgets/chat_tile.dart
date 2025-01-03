import 'package:flutter/material.dart';
import 'package:talkaholic/models/user_profile.dart';

class ChatTile extends StatelessWidget {
  final UserProfile userProfile;

  final Function onTap;

  const ChatTile({
    super.key,
    required this.userProfile,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
   return ListTile(
    onTap:(){
      onTap();
    } ,
    dense: false,
    leading: CircleAvatar(
  backgroundColor: Colors.blue, // Replace with your desired color
  child: Icon(
    Icons.person, // Default contact icon
    color: Colors.white, // Icon color
    size: 24.0, // Icon size
  ),
),

        title: Text("${userProfile.name}"),
   );
  }
}