import 'package:flutter/material.dart';

class BaseSearchField extends StatelessWidget {
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final String hint;
  final Widget? suffixIcon;
  final EdgeInsets padding;

  const BaseSearchField({
    super.key,
    this.controller,
    this.onChanged,
    required this.hint,
    this.suffixIcon,
    this.padding = const EdgeInsets.fromLTRB(12, 8, 12, 8),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: const Icon(Icons.search),
          suffixIcon: suffixIcon,
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 0,
            horizontal: 12,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
