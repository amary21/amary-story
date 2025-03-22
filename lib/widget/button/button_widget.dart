import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final bool isLoading;
  final bool isEnable;
  final String textButton;
  final Function() onTap;

  const ButtonWidget({
    super.key,
    required this.isLoading,
    required this.isEnable,
    required this.textButton,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isEnable ? Colors.blue : Colors.blue[200],
        minimumSize: Size(double.infinity, 45),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child:
          isLoading
              ? SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 3,
                ),
              )
              : Text(textButton, style: TextStyle(color: Colors.white)),
      onPressed: () {
        if (isEnable) {
          onTap();
        }
      },
    );
  }
}
