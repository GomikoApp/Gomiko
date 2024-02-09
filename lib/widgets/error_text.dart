import 'package:flutter/material.dart';

class ErrorText extends StatelessWidget {
  final String? errorMessage;
  final VoidCallback onClose;

  const ErrorText({super.key, this.errorMessage, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
      child: Visibility(
        visible: errorMessage != null && errorMessage!.isNotEmpty,
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xFFF08181),
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          child: Row(
            children: [
              const SizedBox(width: 10),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    errorMessage ?? '',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.black),
                onPressed: onClose,
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
