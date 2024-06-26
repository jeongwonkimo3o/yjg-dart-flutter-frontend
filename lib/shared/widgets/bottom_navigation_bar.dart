import 'package:flutter/material.dart';
import 'package:yjg/shared/service/auth_service.dart';
import 'package:yjg/shared/theme/palette.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: '',
        ),
      ],
      unselectedItemColor: Colors.grey,
      selectedItemColor: Palette.mainColor,
      onTap: (int index) async {
        switch (index) {
          case 0:
            final initialRoute = await AuthService().getInitialRoute();
            if (context.mounted) {
              Navigator.of(context).pushNamedAndRemoveUntil(
                initialRoute!,
                (route) => false,
              );
            }
            break;
          case 1:
            Navigator.of(context).pushNamed('/setting');
            break;
        }
      },
    );
  }
}
