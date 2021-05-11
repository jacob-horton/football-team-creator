import 'package:flutter/material.dart';

class InputBox extends StatelessWidget {
  final IconData? icon;
  final String hint;

  const InputBox({Key? key, required this.hint, this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(blurRadius: 5, color: Colors.black12)],
        color: Colors.white,
      ),
      child: Row(
        children: [
          Padding(padding: const EdgeInsets.only(left: 15, top: 5, bottom: 5)),
          icon != null
              ? Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: Icon(icon, color: Theme.of(context).textTheme.caption?.color),
                )
              : Container(),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintStyle: Theme.of(context).textTheme.caption,
                hintText: hint,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
