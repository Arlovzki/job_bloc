import 'package:flutter/material.dart';
import 'package:jobs_bloc/constants/style.dart';

class CustomPrimaryButton extends StatelessWidget {
  final Function onPressed;
  final EdgeInsets padding;
  final double minWidth;
  final double height;
  final Color buttonColor;
  final Widget child;

  const CustomPrimaryButton({
    Key key,
    this.onPressed,
    this.padding,
    this.minWidth,
    this.height = 52.0,
    this.buttonColor = kColorBlack,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: ButtonTheme(
        minWidth: minWidth,
        height: height,
        child: RaisedButton(
          onPressed: onPressed,
          elevation: 0,
          color: buttonColor,
          splashColor: kColorSplashWhite.withOpacity(0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: child,
        ),
      ),
    );
  }
}
