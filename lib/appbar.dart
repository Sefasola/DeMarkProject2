import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'login/loginStatus.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<LoginStatus>(
      builder: (context, loginStatus, child) {
        return AppBar(
          title: Text('My App Bar'),
          actions: [
            if (loginStatus.isLoggedIn)
              IconButton(
                icon: Icon(Icons.logout),
                onPressed: () {
                  // perform logout action
                  Provider.of<LoginStatus>(context, listen: false).isLoggedIn =
                      false;
                },
              )
          ],
        );
      },
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
