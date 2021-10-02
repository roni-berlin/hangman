import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/provider/google_sign_in.dart';
import 'package:provider/provider.dart';

class LoggedOutWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Container(
      alignment: Alignment.center,
      color: Colors.blueGrey.shade900,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          CircleAvatar(
            maxRadius: 100,
            backgroundImage: NetworkImage(user.photoURL),
          ),
          ElevatedButton(
            onPressed: () async {
              final provider =
              Provider.of<GoogleSignInProvider>(context, listen: false);
              provider.logout();
            },
            child: Text('התנתק'),
          )
        ],
      ),
    );
  }
}