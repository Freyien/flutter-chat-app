import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat/pages/users_page.dart';
import 'package:chat/pages/login_page.dart';
import 'package:chat/services/auth_service.dart';

class LoadingPage extends StatelessWidget {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: checkLoginState(context),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(
              child: CircularProgressIndicator()
            );

          return Container();
        }
      ),
   );
  }

  Future checkLoginState(BuildContext context) async {
    final authService = Provider.of<AuthService>(context, listen: false);

    final autenticate = await authService.isLoggedIn();

    if ( autenticate ) {
      // Connect socket server
      Navigator.pushReplacement(
        context, 
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => UsersPage()
        )
      );
    } else {
      Navigator.pushReplacement(
        context, 
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => LoginPage()
        )
      );
    }
  }
}