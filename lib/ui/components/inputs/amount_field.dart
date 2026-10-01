import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/currency/currency_scope.dart';
import 'app_input_field.dart';

/// Custom TextInputFormatter for Swiss number formatting (1'000.00)
class SwissNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Get cursor position in the original text
    final originalCursorPosition = newValue.selection.baseOffset;
    final originalText = newValue.text;
    
    // Remove all non-digit characters except comma, apostrophe, and dot
    // ignore: deprecated_member_use
    String text = originalText.replaceAll(RegExp('[^\\d\\\'\\.,]'), '');

    int decimalSeparatorIndex = -1;
    String decimalSeparator = '.';
    String integerPart = '';
    String decimalPart = '';
    
    // Strategy: Find the separator that makes the most sense
    // Priority 1: Separator with 1-2 digits after it (definitely decimal)
    // Priority 2: Separator at cursor position or just before (user is typing it)
    // Priority 3: First separator in text
    
    // Map cursor position from original text to filtered text
    int filteredCursorPosition = 0;
    for (int i = 0; i < originalCursorPosition && i < originalText.length; i++) {
      final char = originalText[i];
      // ignore: deprecated_member_use
      if (RegExp('[\\d\\\'\\.,]').hasMatch(char)) {
        filteredCursorPosition++;
      }
    }
    
    // Find all separators and analyze them
    final separators = <Map<String, dynamic>>[];
    for (int i = 0; i < text.length; i++) {
      if (text[i] == '.' || text[i] == ',') {
        // ignore: deprecated_member_use
        final afterSeparator = text.substring(i + 1).replaceAll(RegExp('[^\\d]'), '');
        separators.add({
          'index': i,
          'char': text[i],
          'digitsAfter': afterSeparator.length,
          'distanceFromCursor': (filteredCursorPosition - i).abs(),
        });
      }
    }
    
    if (separators.isNotEmpty) {
      // Priority 1: Separator with 1-2 digits after it
      var bestSeparator = separators.firstWhere(
        (s) => s['digitsAfter'] <= 2 && s['digitsAfter'] > 0,
        orElse: () => separators.first,
      );
      
      // If no separator with digits after, use the one closest to cursor
      if (bestSeparator['digitsAfter'] == 0) {
        separators.sort((a, b) => (a['distanceFromCursor'] as int).compareTo(b['distanceFromCursor'] as int));
        bestSeparator = separators.first;
      }
      
      decimalSeparatorIndex = bestSeparator['index'] as int;
      decimalSeparator = bestSeparator['char'] as String;
    }
    
    // Split at the determined separator
    if (decimalSeparatorIndex >= 0) {
      // Get integer part (everything BEFORE the separator)
      integerPart = text.substring(0, decimalSeparatorIndex);
      
      // Get decimal part (everything AFTER the separator)
      if (decimalSeparatorIndex < text.length - 1) {
        String afterSeparator = text.substring(decimalSeparatorIndex + 1);
        // Remove any non-digits
        // ignore: deprecated_member_use
        decimalPart = afterSeparator.replaceAll(RegExp('[^\\d]'), '');
        // Limit to 2 decimal places
        if (decimalPart.length > 2) {
          decimalPart = decimalPart.substring(0, 2);
        }
      }
    } else {
      // No separator, entire text is integer part
      integerPart = text;
    }

    // Clean integer part: remove apostrophes
    integerPart = integerPart.replaceAll("'", '');

    // Format integer part with apostrophes (thousands separator)
    String formattedInteger = _formatWithApostrophes(integerPart);

    // Combine: integer + separator + decimal
    String formattedText = formattedInteger;
    if (decimalSeparatorIndex >= 0) {
      formattedText += decimalSeparator;
      if (decimalPart.isNotEmpty) {
        formattedText += decimalPart;
      }
    }

    // Calculate cursor position - use relative position from end to maintain cursor correctly
    int cursorPosition = _calculateCursorPosition(
      oldValue,
      newValue,
      formattedText,
      text,
      decimalSeparatorIndex,
    );

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: cursorPosition),
    );
  }

  /// Format number with apostrophes as thousands separator
  String _formatWithApostrophes(String digits) {
    if (digits.isEmpty) return '';
    
    // Remove any existing apostrophes
    digits = digits.replaceAll("'", '');
    
    // Add apostrophes every 3 digits from right to left
    String result = '';
    int digitCount = 0;
    
    for (int i = digits.length - 1; i >= 0; i--) {
      if (digitCount > 0 && digitCount % 3 == 0) {
        result = "'$result";
      }
      result = digits[i] + result;
      digitCount++;
    }
    
    return result;
  }

  /// Calculate cursor position after formatting
  /// Uses relative position from end to maintain cursor correctly during formatting
  int _calculateCursorPosition(
    TextEditingValue oldValue,
    TextEditingValue newValue,
    String formattedText,
    String filteredText,
    int decimalSeparatorIndex,
  ) {
    if (newValue.selection.baseOffset > newValue.text.length) {
      return formattedText.length;
    }

    // Get original cursor position
    final originalCursorOffset = newValue.selection.baseOffset;
    
    // Count how many allowed characters (digits, comma, dot, apostrophe) were before cursor
    final textBeforeCursor = newValue.text.substring(0, originalCursorOffset);
    int allowedCharsBeforeCursor = 0;
    for (int i = 0; i < textBeforeCursor.length; i++) {
      // ignore: deprecated_member_use
      if (RegExp('[\\d\\\'\\.,]').hasMatch(textBeforeCursor[i])) {
        allowedCharsBeforeCursor++;
      }
    }

    // This is the position in the filtered text where cursor should be
    int filteredTextPosition = allowedCharsBeforeCursor.clamp(0, filteredText.length);
    
    // Now map this to formatted text position
    if (decimalSeparatorIndex >= 0 && filteredTextPosition > decimalSeparatorIndex) {
      // Cursor is in or after the decimal part
      final integerPartRaw = filteredText.substring(0, decimalSeparatorIndex).replaceAll("'", '');
      final formattedInteger = _formatWithApostrophes(integerPartRaw);
      
      // Position in decimal part (0-based)
      final positionInDecimalPart = (filteredTextPosition - decimalSeparatorIndex - 1).clamp(0, 2);
      
      // Cursor position = formattedInteger + separator + position in decimal
      return (formattedInteger.length + 1 + positionInDecimalPart).clamp(0, formattedText.length);
    } else {
      // Cursor is in the integer part
      // Count how many digits were before cursor in the filtered text
      final textBeforeCursorInFiltered = filteredText.substring(0, filteredTextPosition);
      // ignore: deprecated_member_use
      final digitsBeforeCursor = textBeforeCursorInFiltered.replaceAll(RegExp('[^\\d]'), '').length;
      
      // Get the integer part that will be formatted
      final integerPartRaw = decimalSeparatorIndex >= 0 
          ? filteredText.substring(0, decimalSeparatorIndex).replaceAll("'", '')
          : filteredText.replaceAll("'", '');
      
      // Find position in formatted integer where we have the same number of digits before
      final formattedInteger = _formatWithApostrophes(integerPartRaw);
      
      int digitCount = 0;
      for (int i = 0; i < formattedInteger.length; i++) {
        // ignore: deprecated_member_use
        if (RegExp(r'\d').hasMatch(formattedInteger[i])) {
          digitCount++;
          if (digitCount == digitsBeforeCursor) {
            // Found the position - cursor should be right after this digit
            return (i + 1).clamp(0, formattedText.length);
          }
        }
      }
      
      // If cursor is at the end of integer part and separator exists
      if (decimalSeparatorIndex >= 0 && digitsBeforeCursor >= integerPartRaw.length) {
        return formattedInteger.length + 1; // Right after separator
      }
      
      // Default: end of formatted integer
      return formattedInteger.length.clamp(0, formattedText.length);
    }
  }
}

/// Amount Field Widget
/// 
/// A specialized input field for entering monetary amounts with Swiss formatting:
/// - Thousands separator: apostrophe (')
/// - Decimal separator: comma (,) or dot (.)
/// - Automatic formatting while typing
/// - Cursor position maintained correctly
class AmountField extends StatelessWidget {
  final String label;
  final String? hintText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final bool isDark;

  const AmountField({
    super.key,
    required this.label,
    this.hintText,
    this.controller,
    this.onChanged,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final displayLabel =
        (label == 'CHF' || label == 'EUR') ? context.appCurrency : label;
    return AppInputField(
      label: displayLabel,
      hintText: hintText ?? displayLabel,
      controller: controller,
      state: InputFieldState.defaultValue,
      isDark: isDark,
      showFloatingLabel: false,
      keyboardType: const TextInputType.numberWithOptions(
        decimal: true,
        signed: false,
      ),
      inputFormatters: [
        SwissNumberFormatter(), // Formats: 1'000.00 (thousands with ', decimals with . or ,)
      ],
      onChanged: onChanged,
    );
  }
}

