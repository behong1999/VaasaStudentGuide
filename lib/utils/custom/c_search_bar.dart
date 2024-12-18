import 'package:flutter/material.dart';
import 'package:students_guide/utils/custom/c_theme_data.dart';

class CustomSearchBar extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onChanged;
  final Widget? suffixIcon;

  const CustomSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
    this.suffixIcon,
  });

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  @override
  Widget build(BuildContext context) {
    double radius = 30;
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: radius,
            spreadRadius: 0.05,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextFormField(
        controller: widget.controller,
        onChanged: widget.onChanged,
        cursorColor: mColor,
        style: const TextStyle(color: mColor),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          filled: true,
          fillColor: white,
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black12),
            borderRadius: BorderRadius.all(Radius.circular(radius)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: mColor),
            borderRadius: BorderRadius.all(Radius.circular(radius)),
          ),
          hintText: 'Search by title...',
          hintStyle: const TextStyle(color: Colors.black38),
          suffixIcon: widget.suffixIcon,
        ),
      ),
    );
  }
}
