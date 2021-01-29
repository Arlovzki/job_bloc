import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jobs_bloc/constants/style.dart';
import 'package:reactive_forms/reactive_forms.dart';

class ReactiveInputField extends StatelessWidget {
  const ReactiveInputField({
    Key key,
    this.padding = const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 26.0),
    @required this.formControlName,
    this.maxLines = 1,
    this.textInputAction = TextInputAction.next,
    this.title,
    this.helperText,
    this.suffixIcon,
    this.prefixIcon,
    this.readOnly = false,
    this.validationMessages,
    this.withBorder = false,
    this.keyboardType,
    this.inputFormatters,
    this.onSubmitted,
    this.labelText,
    this.prefixText,
    this.floatingLabelBehavior = FloatingLabelBehavior.never,
    this.requiredField = false,
    this.valueAccessor,
    this.hintText,
    this.inputBorder,
    this.maxLength,
    this.isFilled = false,
  }) : super(key: key);

  final EdgeInsetsGeometry padding;
  final String formControlName;
  final int maxLines;
  final TextInputAction textInputAction;
  final String title;
  final String helperText;
  final Widget suffixIcon;
  final Widget prefixIcon;
  final String hintText;
  final bool readOnly;
  final Function validationMessages;
  final bool withBorder;
  final TextInputType keyboardType;
  final List<TextInputFormatter> inputFormatters;
  final Function onSubmitted;
  final String labelText;
  final String prefixText;
  final FloatingLabelBehavior floatingLabelBehavior;
  final bool requiredField;
  final ControlValueAccessor<dynamic, dynamic> valueAccessor;
  final InputBorder inputBorder;
  final int maxLength;
  final bool isFilled;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        title != null
            ? Container(
                alignment: Alignment.centerLeft,
                padding: padding == null
                    ? null
                    : EdgeInsets.only(left: 20.w, right: 15.h, top: 20.w),
                child: withBorder
                    ? Row(
                        children: [
                          Text(
                            title,
                            style: kTextBody.copyWith(color: kColorBlack),
                          ),
                          if (requiredField)
                            Text(' *', style: TextStyle(color: kColorRed))
                        ],
                      )
                    : Row(
                        children: [
                          Text(title, style: kTextFieldTitle),
                          requiredField
                              ? Text(
                                  ' *',
                                  style: TextStyle(color: kColorRed),
                                )
                              : SizedBox.shrink()
                        ],
                      ),
              )
            : SizedBox.shrink(),
        title != null ? SizedBox(height: 5.h) : SizedBox.shrink(),
        Container(
          padding: padding,
          child: ReactiveTextField(
            style: kTextBody,
            formControlName: formControlName,
            maxLines: maxLines,
            validationMessages: validationMessages,
            textInputAction: textInputAction,
            onSubmitted: onSubmitted,
            maxLength: maxLength,
            decoration: InputDecoration(
              fillColor: isFilled ? kColorLightGrey1 : kColorWhite,
              filled: isFilled,
              border: withBorder
                  ? OutlineInputBorder()
                  : inputBorder == InputBorder.none
                      ? InputBorder.none
                      : null,
              labelText: labelText,
              helperText: helperText,
              helperStyle: kTextBody.copyWith(
                fontSize: 14.ssp,
                fontWeight: FontWeight.w500,
              ),
              helperMaxLines: 2,
              suffixIcon: suffixIcon,
              prefixIcon: prefixIcon,
              prefixText: prefixText,
              floatingLabelBehavior: floatingLabelBehavior,
              hintText: hintText,
              hintStyle: kTextBody.copyWith(color: kColorLightGrey2),
              errorStyle: kTextBody.copyWith(
                color: kColorRed,
                fontSize: 14.ssp,
              ),
            ),
            readOnly: readOnly,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            valueAccessor: valueAccessor,
          ),
        ),
      ],
    );
  }
}
