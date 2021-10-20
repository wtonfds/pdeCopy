import 'package:flutter/material.dart';

class CustomLoadButton extends StatefulWidget {
  final bool loading;
  final Function onPressed;
  final String title;
  final double? width;
  final TextStyle? textStyle;
  final ButtonStyle? style;


  const CustomLoadButton({
    Key? key,
    required this.loading,
    required this.onPressed,
    required this.title,
    this.width,
    this.textStyle,
    this.style,
  }) : super(key: key);
  @override
  _CustomLoadButtonState createState() => _CustomLoadButtonState();
}

class _CustomLoadButtonState extends State<CustomLoadButton> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Container(
      height: 54,
      width: width > 600 ? width * .3 : width,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ElevatedButton(
        style: widget.style,
        onPressed: widget.loading
            ? () {}
            : () {
                setState(() {
                  FocusScopeNode currentFocus = FocusScope.of(context);
                  currentFocus.unfocus();
                  widget.onPressed();
                });
              },
        child: widget.loading
            ? const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white))
            : Text(
                widget.title.toUpperCase(),
                style: widget.textStyle ??
                    const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
              ),
      ),
    );
  }
}
