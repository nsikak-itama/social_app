import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/responsive/constrained_scaffold.dart';
import 'package:social_app/theme/theme-provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedScaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(10)
            ),
            margin: EdgeInsets.all(25),
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Dark Mode", style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.inversePrimary),),
                  CupertinoSwitch(
                    value: Provider.of<ThemeProvider>(context, listen: false).isDarkMode, 
                    onChanged: (value) => Provider.of<ThemeProvider>(context, listen: false).toggleTheme()
                  )
                ],
              ),
            ),
          ),

        ],
      ), backgroundColor: Theme.of(context).colorScheme.background,
    );
  }
}