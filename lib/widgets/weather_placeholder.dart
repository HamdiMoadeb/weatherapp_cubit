import 'package:flutter/material.dart';

Widget weatherPlaceholder() {
  return const Center(
    child: Text(
      'No City Selected',
      style: TextStyle(
        fontSize: 35.0,
        color: Colors.white,
      ),
    ),
  );
}
