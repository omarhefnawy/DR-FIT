import 'package:dr_fit/core/utils/constants.dart';
import 'package:flutter/material.dart';

class MessageTile extends StatelessWidget {
  final String message;
  final bool isUser;
  final Color textColor;
  final Color bgColor;

  const MessageTile({
    required this.message,
    required this.isUser,
    required this.textColor,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
        color: isUser ? buttonPrimaryColor(context).withOpacity(0.2) : bgColor,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: isUser ? buttonPrimaryColor(context) : Colors.transparent,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Text(
        message,
        style: TextStyle(
          fontSize: 16,
          color: textColor,
          fontWeight: isUser ? FontWeight.w500 : FontWeight.normal,
          shadows: [
            Shadow(
              blurRadius: 2,
              color: Colors.black.withOpacity(0.3),
              offset: Offset(1, 1),
            )
          ],
        ),
        textDirection: TextDirection.rtl,
      ),
    );
  }
}
