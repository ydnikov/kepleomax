import 'package:flutter/material.dart';
import 'package:kepleomax/core/presentation/colors.dart';
import 'package:kepleomax/core/extensions/build_context_extensions.dart';
import 'package:kepleomax/core/scopes/user_activity_scope.dart';

class KlmTextField extends StatefulWidget {
  const KlmTextField({
    required this.controller,
    required this.onChanged,
    this.focusNode,
    this.label,
    this.hint,
    this.isPassword = false,
    this.showErrors = false,
    this.validators = const [],
    this.validator,
    this.maxLength,
    this.readOnly = false,
    this.multiline = false,
    this.textCapitalization = TextCapitalization.none,
    this.textInputType,
    this.showCounter = true,
    this.backgroundColor = Colors.white,
    this.borderColor = KlmColors.inactiveColor,
    this.hintColor = Colors.grey,
    this.onFocusLost,
    super.key,
  });

  final TextEditingController controller;
  final FocusNode? focusNode;
  final String? label;
  final String? hint;
  final bool isPassword;
  final ValueChanged<String>? onChanged;
  final bool showErrors;
  final List<String? Function(String)> validators; // for bool showError
  final FormFieldValidator<String>? validator; // for formKey validation
  final int? maxLength;
  final bool readOnly;
  final bool multiline;
  final TextCapitalization textCapitalization;
  final TextInputType? textInputType;
  final bool showCounter;
  final Color backgroundColor;
  final Color borderColor;
  final Color hintColor;
  final VoidCallback? onFocusLost;

  @override
  State<KlmTextField> createState() => _KlmTextFieldState();
}

class _KlmTextFieldState extends State<KlmTextField> {
  late final FocusNode _focusNode;
  late bool _obscureText;

  @override
  void initState() {
    _obscureText = widget.isPassword;
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(() {
      if (widget.onFocusLost != null && !_focusNode.hasFocus) {
        widget.onFocusLost!();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  String? _error() {
    if (!widget.showErrors) {
      return null;
    }

    for (final validator in widget.validators) {
      final check = validator(widget.controller.text);
      if (check != null) {
        return check;
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (newFocus) {
        setState(() {});
      },
      child: Stack(
        children: [
          TextFormField(
            controller: widget.controller,
            focusNode: _focusNode,
            obscureText: _obscureText,
            maxLines: widget.multiline ? null : 1,
            maxLength: widget.maxLength ?? 50,
            keyboardType:
                widget.textInputType ??
                (widget.multiline ? TextInputType.multiline : null),
            onChanged: (value) {
              setState(() {});
              widget.onChanged?.call(value);
              UserActivityScope.addActivity(context);
            },
            validator: widget.validator,
            readOnly: widget.readOnly,
            textCapitalization: widget.textCapitalization,
            decoration: InputDecoration(
              floatingLabelStyle: context.textTheme.bodySmall?.copyWith(
                color: Colors.grey,
                fontWeight: FontWeight.w300,
              ),
              suffix: widget.isPassword
                  ? SizedBox(
                      height: 17,
                      width: 17,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                        child: Icon(
                          _obscureText
                              ? Icons.remove_red_eye
                              : Icons.remove_red_eye_outlined,
                          color: Colors.black,
                          size: 17,
                        ),
                      ),
                    )
                  : widget.readOnly
                  ? null
                  : widget.controller.text.isNotEmpty
                  ? SizedBox(
                      height: 17,
                      width: 17,
                      child: InkWell(
                        onTap: () {
                          widget.controller.clear();
                          widget.onChanged?.call('');
                          setState(() {});
                        },
                        child: const Icon(
                          Icons.close,
                          color: Colors.black,
                          size: 17,
                        ),
                      ),
                    )
                  : null,
              counter: const SizedBox(),
              isDense: true,
              focusedBorder: _getFocusedBorder(),
              focusedErrorBorder: _getBorder(_error() != null),
              enabledBorder: _getBorder(_error() != null),
              errorBorder: _getBorder(_error() != null),
              errorText: _error(),
              //labelText: widget.label,
              label: widget.label == null
                  ? null
                  : Container(
                      color: Colors.white,
                      child: Text(
                        widget.label!,
                        style: context.textTheme.bodyMedium,
                      ),
                    ),
              hintText: widget.hint,
              hintStyle: TextStyle(color: widget.hintColor),
              labelStyle: context.textTheme.titleLarge?.copyWith(color: Colors.grey),
              fillColor: widget.backgroundColor,
              filled: true,
            ),
          ),
          if (widget.maxLength != null && widget.showCounter)
            Positioned(
              bottom: _error() != null ? 32 : 4,
              right: 10,
              child: Text(
                '${widget.controller.text.length}/${widget.maxLength}',
                style: context.textTheme.bodySmall,
              ),
            ),
        ],
      ),
    );
  }

  InputBorder? _getFocusedBorder() => widget.readOnly
      ? _getBorder(false)
      : OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(
            color: Colors.blue,
            width: 3,
            strokeAlign: BorderSide.strokeAlignOutside,
          ),
        );

  InputBorder? _getBorder(bool isError) {
    if (isError) {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(
          color: KlmColors.errorRed,
          width: 2,
          strokeAlign: BorderSide.strokeAlignOutside,
        ),
      );
    }
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide(
        color: widget.controller.text.isEmpty || widget.readOnly
            ? widget.borderColor
            : KlmColors.primaryColor,
        width: 2,
        strokeAlign: BorderSide.strokeAlignOutside,
      ),
    );
  }
}
