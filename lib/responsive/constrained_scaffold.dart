import 'package:flutter/material.dart';

class ConstrainedScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? drawer;
  const ConstrainedScaffold({
    super.key, 
    required this.body, 
    this.appBar, 
    this.drawer, 
    required Color backgroundColor
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      drawer: drawer,
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 500
          ),
          child: body,
        ),
      ),
    );
  }
}
