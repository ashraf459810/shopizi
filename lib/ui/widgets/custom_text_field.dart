import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/get_utils/get_utils.dart';
import 'package:shopizy/main.dart';

class CustomTextField extends StatefulWidget {
  final bool showBorder;
  final Widget prefixIcon;
  final String prefixText;
  final bool isRequired;
  final TextInputType keyboardType;
  final String hint;
  final TextAlign textAlign;
  final Color borderColor;
  final FocusNode focusNode;
  final TextInputAction textInputAction;
  final FocusNode nextFocusNode;
  final RegExp regex;
  final List<TextInputFormatter> textInputFormatters;
  final TextStyle textStyle;
  final TextStyle prefixTextStyle;
  final bool isLTR;
  final EdgeInsets padding;
  final List<String> errors;
  final TextEditingController controller;
  final Function onChanged;
  final bool changeKey;
  final Key changedFieldKey;
  final int lines;
  final bool isDense;
  final bool showClearAction;
  final bool autoFocus;
  final Function onSubmitted;
  final Function(String) onSave;
  final Function(bool) onFocusChanged;
  final BorderRadius borderRadius;
  final AutovalidateMode autoValidateMode;
  final String initialValue;
  final bool enabled;

  CustomTextField({
    this.changedFieldKey,
    this.showBorder = false,
    this.prefixIcon,
    this.prefixText,
    this.isRequired = false,
    this.keyboardType = TextInputType.text,
    this.hint = '',
    this.textAlign = TextAlign.start,
    this.borderColor,
    this.focusNode,
    this.textInputAction,
    this.nextFocusNode,
    this.regex,
    this.textStyle,
    this.prefixTextStyle,
    this.isLTR = false,
    this.textInputFormatters,
    this.padding,
    this.errors,
    this.controller,
    this.changeKey = true,
    this.onChanged,
    this.lines,
    this.autoFocus = false,
    this.showClearAction = false,
    this.isDense = false,
    this.onSubmitted,
    this.onFocusChanged,
    this.onSave,
    this.autoValidateMode = AutovalidateMode.always,
    this.borderRadius = const BorderRadius.all(Radius.circular(5)),
    this.initialValue,
    this.enabled,
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  Key fieldKey;
  Widget prefixIcon;
  String text;
  bool changeKey;
  FocusNode _focusNode;

  @override
  void initState() {
    fieldKey = UniqueKey();
    prefixIcon = widget.prefixIcon;
    changeKey = widget.changeKey;
    if (widget.onFocusChanged != null && widget.focusNode == null) _focusNode = FocusNode();
    if (_focusNode != null)
      _focusNode.addListener(() {
        widget.onFocusChanged(_focusNode.hasFocus);
      });
    super.initState();
  }

  @override
  void dispose() {
    if (widget.focusNode != null) widget.focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    fieldKey = widget.changedFieldKey.hashCode == fieldKey.hashCode || !changeKey || text != null ? fieldKey : UniqueKey();
    return TextFormField(
      enabled: widget.enabled,
      initialValue: widget.initialValue,
      controller: widget.controller,
      validator: (value) {
        if (widget.isRequired && value.isEmpty)
          return 'this_field_is_required'.tr;
        else if (widget.regex != null && !widget.regex.hasMatch(value.replaceAll(' ', '')))
          return 'msg_invalid_value';
        else if (widget.keyboardType == TextInputType.emailAddress && value.isNotEmpty && !GetUtils.isEmail(value))
          return 'invalid_email'.tr;
        return null;
      },
      onChanged: (value) {
        setState(() => text = value);
        if (widget.onChanged != null) widget.onChanged(fieldKey, value);
      },
      focusNode: _focusNode,
      inputFormatters: widget.textInputFormatters != null ? widget.textInputFormatters : [],
      textInputAction: widget.textInputAction,
      onFieldSubmitted: (value) {
        if (widget.onSubmitted != null) widget.onSubmitted();
        widget.focusNode.unfocus();
        FocusScope.of(context).requestFocus(widget.nextFocusNode);
      },
      onSaved: widget.onSave,
      maxLines: widget.lines,
      textAlign: widget.textAlign,
      textDirection: widget.isLTR ? TextDirection.ltr : null,
      keyboardType: widget.keyboardType,
      autofocus: widget.autoFocus,
      autovalidateMode: widget.autoValidateMode,
      style: widget.textStyle != null ? widget.textStyle : appTheme.textStyles.subtitle1,
      decoration: InputDecoration(
          isDense: widget.isDense,
          border: widget.showBorder
              ? OutlineInputBorder(
                  borderSide: BorderSide(color: widget.borderColor ?? Colors.grey[400], width: 1), borderRadius: widget.borderRadius)
              : OutlineInputBorder(borderSide: BorderSide.none),
          enabledBorder: widget.showBorder
              ? OutlineInputBorder(
                  borderSide: BorderSide(color: widget.borderColor ?? Colors.grey[400], width: 1), borderRadius: widget.borderRadius)
              : OutlineInputBorder(borderSide: BorderSide.none),
          errorBorder: widget.showBorder
              ? OutlineInputBorder(borderSide: BorderSide(color: Colors.red, width: 1), borderRadius: widget.borderRadius)
              : OutlineInputBorder(borderSide: BorderSide.none),
          filled: true,
          fillColor: Colors.white,
          contentPadding: widget.padding == null ? EdgeInsets.symmetric(horizontal: 8) : widget.padding,
          hintText: widget.hint,
          errorText: widget.errors != null && widget.errors.length > 0 ? widget.errors[0] : null,
          prefixIcon: widget.showClearAction && (text?.isNotEmpty ?? false)
              ? GestureDetector(
                  onTap: () {
                    // To Clear Field Text
                    widget.onChanged(fieldKey, null);
                    setState(() {
                      changeKey = true;
                      text = null;
                    });
                  },
                  child: Icon(Icons.cancel, size: 20, color: Colors.grey[400].withOpacity(0.5)),
                )
              : widget.prefixIcon,
          prefixText: widget.prefixText,
          prefixStyle: widget.prefixTextStyle != null
              ? widget.prefixTextStyle
              : Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.black),
          hoverColor: Colors.transparent,
          hintStyle: Theme.of(context).textTheme.subtitle1.copyWith(color: appTheme.colors.hint),
          errorStyle: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 11, color: appTheme.colors.errorColor)),
    );
  }
}
