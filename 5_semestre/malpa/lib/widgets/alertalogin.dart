import 'package:flutter/material.dart';

class AlertDialogWidget extends StatelessWidget {
  final String message;

  const AlertDialogWidget({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(message),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("OK"),
        )
      ],
    );
  }
}
