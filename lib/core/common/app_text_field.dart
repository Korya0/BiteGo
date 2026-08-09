import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bite_go/core/utils/context_extension.dart';

enum AppTextFieldState { initial, valid, invalid, loading }

class AppTextField extends StatefulWidget {
  final String label;
  final String? hintText;
  final TextEditingController? controller;
  final bool obscureText;
  final ValueChanged<String>? onChanged;

  final bool showValidationState;
  final bool isLoading;
  final bool autofocus;
  final FormFieldValidator<String>? validator;
  final List<TextInputFormatter>? inputFormatters;

  const AppTextField({
    required this.label,
    super.key,
    this.hintText,
    this.controller,
    this.obscureText = false,
    this.onChanged,
    this.showValidationState = false,
    this.isLoading = false,
    this.autofocus = false,
    this.validator,
    this.inputFormatters,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late final ValueNotifier<AppTextFieldState> _suffixState;
  Timer? _debounce;
  bool? _lastValidationResult;

  @override
  void initState() {
    super.initState();
    _suffixState = ValueNotifier(_calculateState(isTypingLoading: false));
  }

  @override
  void didUpdateWidget(AppTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isLoading != oldWidget.isLoading ||
        widget.showValidationState != oldWidget.showValidationState) {
      _suffixState.value = _calculateState(isTypingLoading: false);
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _suffixState.dispose();
    super.dispose();
  }

  AppTextFieldState _calculateState({required bool isTypingLoading}) {
    if (widget.isLoading || isTypingLoading) {
      return AppTextFieldState.loading;
    } else if (widget.showValidationState && _lastValidationResult != null) {
      return _lastValidationResult!
          ? AppTextFieldState.valid
          : AppTextFieldState.invalid;
    }
    return AppTextFieldState.initial;
  }

  void _handleChange(String value) {
    widget.onChanged?.call(value);

    if (widget.showValidationState && widget.validator != null) {
      if (value.isEmpty) {
        _debounce?.cancel();
        _lastValidationResult = null;
        _suffixState.value = _calculateState(isTypingLoading: false);
      } else {
        _suffixState.value = _calculateState(isTypingLoading: true);

        _debounce?.cancel();
        _debounce = Timer(const Duration(milliseconds: 500), () {
          if (mounted) {
            _lastValidationResult = widget.validator!(value) == null;
            _suffixState.value = _calculateState(isTypingLoading: false);
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final baseBorder = context.color.textSecondary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.label,
          style: context.textStyle.caption.copyWith(
            fontSize: 15,
            color: context.color.textPrimary,
          ),
        ),
        Theme(
          data: Theme.of(context).copyWith(
            textSelectionTheme: TextSelectionThemeData(
              cursorColor: context.color.primary,
              selectionColor: context.color.primary.withValues(alpha: context.opacity.medium),
              selectionHandleColor: context.color.primary,
            ),
          ),
          child: TextFormField(
            autofocus: widget.autofocus,
            cursorHeight: 18,
            cursorColor: context.color.primary,
            controller: widget.controller,
            obscureText: widget.obscureText,
            onChanged: _handleChange,
            inputFormatters: widget.inputFormatters,
            textAlignVertical: TextAlignVertical.bottom,
            style: context.textStyle.body.copyWith(
              fontSize: 16,
              color: context.color.textPrimary,
            ),
            decoration: InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.only(bottom: context.space.xs),
              hintText: widget.hintText,
              hintStyle: context.textStyle.caption.copyWith(
                fontSize: 15,
                color: context.color.textSecondary,
              ),
              suffixIcon: ValueListenableBuilder<AppTextFieldState>(
                valueListenable: _suffixState,
                builder: (context, state, _) {
                  return _AppTextFieldSuffix(state: state);
                },
              ),
              suffixIconConstraints: const BoxConstraints(
                maxHeight: 20,
                minWidth: 24,
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: baseBorder),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: baseBorder),
              ),
              errorBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: baseBorder),
              ),
              focusedErrorBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: baseBorder),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _AppTextFieldSuffix extends StatelessWidget {
  final AppTextFieldState state;

  const _AppTextFieldSuffix({required this.state});

  @override
  Widget build(BuildContext context) {
    switch (state) {
      case AppTextFieldState.initial:
        return const SizedBox.shrink();
      case AppTextFieldState.valid:
        return Container(
          width: 24,
          alignment: Alignment.centerRight,
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: context.color.iconSuccess,
            ),
            alignment: Alignment.center,
            child: Icon(Icons.check, size: 14, color: context.color.textOnPrimary),
          ),
        );
      case AppTextFieldState.invalid:
        return Container(
          width: 24,
          alignment: Alignment.centerRight,
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: context.color.iconError,
            ),
            alignment: Alignment.center,
            child: Icon(Icons.close, size: 14, color: context.color.textOnPrimary),
          ),
        );
      case AppTextFieldState.loading:
        return Container(
          width: 24,
          alignment: Alignment.centerRight,
          child: SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: context.color.primary,
            ),
          ),
        );
    }
  }
}
