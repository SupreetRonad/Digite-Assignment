import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

void showMsg(context, String msg, Color color) {
  var snackBar = SnackBar(
    content: Text(msg),
    backgroundColor: color,
    duration: Duration(seconds: 2),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

class CustomField extends StatelessWidget {
  final Function(String? val)? onChanged;
  final String? hint;
  final String? prefix;
  final int? maxLength;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final FocusNode? focus;
  const CustomField({
    Key? key,
    this.onChanged,
    this.hint,
    this.prefix,
    this.maxLength,
    this.keyboardType = TextInputType.text,
    this.controller,
    this.focus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextFormField(
        minLines: 1,
        maxLines: 4,
        focusNode: focus,
        controller: controller,
        maxLength: maxLength,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: Colors.black26,
          ),
          counterText: '',
          border: InputBorder.none,
          prefixText: prefix,
        ),
        onChanged: onChanged,
      ),
    );
  }
}

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: SpinKitFadingCircle(
          color: Colors.black54,
          size: 20,
        ),
      ),
    );
  }
}
