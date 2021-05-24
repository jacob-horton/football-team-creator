import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:football/utils/regex_input_formatter.dart';

class InputBox extends StatelessWidget {
  final IconData? icon;
  final String? hint;
  final Function(String)? onChanged;
  final TextEditingController? controller;
  final List<TextInputFormatter>? inputFormatters;

  InputBox({Key? key, this.hint, this.icon, this.onChanged, this.controller, this.inputFormatters}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(blurRadius: 5, color: Colors.black.withOpacity(0.05))],
        color: Colors.white,
      ),
      child: Row(
        children: [
          Padding(padding: const EdgeInsets.only(left: 20)),
          icon != null
              ? Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Icon(icon, color: Theme.of(context).textTheme.caption?.color),
                )
              : Container(),
          Expanded(
            child: TextFormField(
              inputFormatters: inputFormatters,
              onChanged: onChanged,
              controller: controller,
              style: Theme.of(context).textTheme.bodyText2?.copyWith(fontSize: 20.0),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintStyle: Theme.of(context).textTheme.caption?.copyWith(fontSize: 20.0),
                hintText: hint,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
