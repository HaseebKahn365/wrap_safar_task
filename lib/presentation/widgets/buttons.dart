import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/theme_provider.dart';

class CustomOutlinedButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final Color? borderColor;
  final Color? textColor;

  const CustomOutlinedButton({
    super.key,
    this.onPressed,
    this.text = 'Explore',
    this.borderColor,
    this.textColor,
  });
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<WrapSafarTheme>(context);
    final isDisabled = onPressed == null;

    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        side: BorderSide(
          color: isDisabled ? Colors.grey : (borderColor ?? theme.darkBlue),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          color: isDisabled ? Colors.grey : (textColor ?? theme.outlineLabel),
        ),
      ),
    );
  }
}

class CustomFilledButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final Color? backgroundColor;
  final Color? textColor;

  const CustomFilledButton({
    super.key,
    this.onPressed,
    this.text = 'Book Now',
    this.backgroundColor,
    this.textColor,
  });
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<WrapSafarTheme>(context);
    final isDisabled = onPressed == null;

    return FilledButton(
      style: FilledButton.styleFrom(
        backgroundColor:
            isDisabled ? Colors.grey : (backgroundColor ?? theme.vividOrange),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          color: isDisabled ? Colors.white : (textColor ?? Colors.white),
        ),
      ),
    );
  }
}

class CustomElevatedButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final Color? backgroundColor;
  final Color? textColor;

  const CustomElevatedButton({
    super.key,
    this.onPressed,
    this.text = 'Adventure',
    this.backgroundColor,
    this.textColor,
  });
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<WrapSafarTheme>(context);
    final isDisabled = onPressed == null;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor:
            isDisabled ? Colors.grey : (backgroundColor ?? theme.darkBlue),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          color: isDisabled ? Colors.white : (textColor ?? theme.onDarkBlue),
        ),
      ),
    );
  }
}
