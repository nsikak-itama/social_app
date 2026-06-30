import 'package:flutter/material.dart';

class MessageButton extends StatelessWidget {
 final void Function()? onPressed;
 final bool isFollower;
  const MessageButton({super.key, required this.onPressed, required this.isFollower});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
         child: Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.primary,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(12), 
      ),
      child: MaterialButton(
        onPressed: onPressed,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12)
        ),
        padding: const EdgeInsets.all(25),
        color: Colors.transparent,
        hoverColor: Theme.of(context).colorScheme.background,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        elevation: 0,
        hoverElevation: 0,
        child: Text(
          "Message",
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
  ),
);
  }
}