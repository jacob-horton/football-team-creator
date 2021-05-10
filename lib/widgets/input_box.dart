import 'package:flutter/material.dart';

class InputBox extends StatelessWidget {
  final IconData? icon;
  final String hint;

  const InputBox({Key? key, required this.hint, this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(blurRadius: 5, color: Colors.black12)],
        color: Colors.white,
      ),
      child: Row(
        children: [
          Padding(padding: const EdgeInsets.only(left: 20, top: 10, bottom: 10)),
          icon != null
              ? Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: Icon(icon, color: const Color(0xffb0b0b0)),
                )
              : Container(),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hint,
                hintStyle: TextStyle(color: const Color(0xffb0b0b0)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}