import 'package:flutter/material.dart';

enum ButtonVariant { filled, outlined, text }

class CustomButton extends StatelessWidget {

  const CustomButton({
    super.key,
    this.text = '',
    this.icon,
    this.child,
    this.onPressed,
    this.isLoading = false,
    this.variant = ButtonVariant.filled,
    this.width,
    this.height,
  });
  /// Text to display (default empty)
  final String text;

  /// Optional icon widget
  final Widget? icon;

  /// Optional custom child (replaces text)
  final Widget? child;

  /// Async callback
  final Future<void> Function()? onPressed;

  /// Loading spinner
  final bool isLoading;

  final ButtonVariant variant;

  /// Optional sizing
  final double? width;
  final double? height;

  bool get _disabled => onPressed == null || isLoading;

  @override
  Widget build(BuildContext context) {
    Widget content;

    if (isLoading) {
      content = const SizedBox(
        height: 18,
        width: 18,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    } else {
      content = child ?? Text(text);
    }

    // Use .icon constructor if icon exists
    Widget button;
    switch (variant) {
      case ButtonVariant.filled:
        button = icon != null
            ? FilledButton.icon(
                onPressed: _disabled ? null : () => onPressed?.call(),
                icon: icon,
                label: content,
              )
            : FilledButton(
                onPressed: _disabled ? null : () => onPressed?.call(),
                child: content,
              );

      case ButtonVariant.outlined:
        button = icon != null
            ? OutlinedButton.icon(
                onPressed: _disabled ? null : () => onPressed?.call(),
                icon: icon,
                label: content,
              )
            : OutlinedButton(
                onPressed: _disabled ? null : () => onPressed?.call(),
                child: content,
              );

      case ButtonVariant.text:
        button = icon != null
            ? TextButton.icon(
                onPressed: _disabled ? null : () => onPressed?.call(),
                icon: icon,
                label: content,
              )
            : TextButton(
                onPressed: _disabled ? null : () => onPressed?.call(),
                child: content,
              );
    }

    if(width == null && height == null){
      return button;
    }

    return SizedBox(width: width, height: height, child: button);
  }
}
