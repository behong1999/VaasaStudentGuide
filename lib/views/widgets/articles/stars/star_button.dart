import 'package:flutter/material.dart';

class StarButton extends StatefulWidget {
  const StarButton({
    super.key,
    required this.isStarred,
    required this.onPressed,
  });

  final bool isStarred;
  final VoidCallback onPressed;

  @override
  State<StarButton> createState() => _StarButtonState();
}

class _StarButtonState extends State<StarButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        widget.isStarred ? Icons.star : Icons.star_border_rounded,
        color: Colors.yellow,
      ),
      onPressed: widget.onPressed,
    );
  }
}
