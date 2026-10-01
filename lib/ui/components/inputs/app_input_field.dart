import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/color_schemes.dart';
import '../../../core/theme/radius.dart';

/// Input Field Form Component
///
/// Figma component: Input Field Form (118:6623)
/// States: Default, Active, Typing, Filled, Error, Dropdown
/// Material 3 OutlinedTextField with floating label
/// 
/// WCAG 2.2 Compliance:
/// - Labels sind programmatisch mit Eingabefeldern verknüpft
/// - textInputAction für Formular-Navigation
/// - Fehlermeldungen sind für Screenreader zugänglich
/// - Minimum Touch-Target von 56dp Höhe
enum InputFieldState {
  defaultValue,
  active,
  typing,
  filled,
  error,
  dropdown,
}

class AppInputField extends StatefulWidget {
  final String label;
  final String? hintText;
  final String? value;
  final TextEditingController? controller;
  final InputFieldState state;
  final bool isDropdown;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final String? errorText;
  final bool isDark;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final bool showFloatingLabel; // If false, no floating label (for static labels above field)
  final IconData? trailingIcon;
  final Color? trailingIconColor;
  final Color? labelColorOverride;
  final ValueChanged<bool>? onFocusChanged;
  final int? maxLines;
  
  /// WCAG 2.2: textInputAction für Formular-Navigation
  /// Ermöglicht "Weiter" / "Fertig" Aktionen auf der Tastatur
  final TextInputAction? textInputAction;
  
  /// WCAG 2.2: Callback wenn "Weiter" / "Fertig" gedrückt wird
  final VoidCallback? onEditingComplete;
  
  /// WCAG 2.2: Callback für Form Submit
  final ValueChanged<String>? onSubmitted;
  
  /// WCAG 2.2: Autofill Hints für bessere Accessibility
  final Iterable<String>? autofillHints;
  
  const AppInputField({
    super.key,
    required this.label,
    this.hintText,
    this.value,
    this.controller,
    this.state = InputFieldState.defaultValue,
    this.isDropdown = false,
    this.onTap,
    this.onChanged,
    this.errorText,
    required this.isDark,
    this.keyboardType,
    this.inputFormatters,
    this.showFloatingLabel = true, // Default to true for backward compatibility
    this.trailingIcon,
    this.trailingIconColor,
    this.labelColorOverride,
    this.onFocusChanged,
    this.maxLines,
    this.textInputAction,
    this.onEditingComplete,
    this.onSubmitted,
    this.autofillHints,
  });

  @override
  State<AppInputField> createState() => _AppInputFieldState();
}

class _AppInputFieldState extends State<AppInputField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _isFocused = false;
  bool _isInternalController = false;

  @override
  void initState() {
    super.initState();
    _isInternalController = widget.controller == null;
    _controller =
        widget.controller ?? TextEditingController(text: widget.value);
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      if (_isFocused != _focusNode.hasFocus) {
        setState(() {
          _isFocused = _focusNode.hasFocus;
        });
        widget.onFocusChanged?.call(_focusNode.hasFocus);
      }
    });
  }

  @override
  void didUpdateWidget(AppInputField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value && widget.controller == null) {
      _controller.text = widget.value ?? '';
    }
  }

  @override
  void dispose() {
    if (_isInternalController) {
      _controller.dispose();
    }
    _focusNode.dispose();
    super.dispose();
  }

  bool get _hasText => _controller.text.isNotEmpty;
  bool get _shouldShowLabelFloating => _isFocused || _hasText;
  bool get _isFilledState => _hasText && !_isFocused; // Filled but not focused

  /// Standard label color for static / filled labels (Figma: mid grey #888888).
  Color get _staticLabelColor =>
      widget.labelColorOverride ?? AppColorSchemes.greysMidGrey;

  TextStyle _staticLabelStyle({Color? color}) {
    return GoogleFonts.openSans(
      fontSize: 12,
      fontWeight: FontWeight.bold,
      color: color ?? _staticLabelColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bgColor =
        widget.isDark ? AppColorSchemes.darkCardBackground : Colors.white;
    final borderColor = _getBorderColor();
    final labelColor = _getLabelColor();
    final textColor = AppColorSchemes.getTextColor(widget.isDark);

    if (widget.isDropdown) {
      return _buildDropdownField(bgColor, borderColor, labelColor, textColor);
    }

    // If showFloatingLabel is false, use simple input without floating label
    if (!widget.showFloatingLabel) {
      return _buildSimpleInputField(bgColor, borderColor, textColor);
    }

    // Material 3 OutlinedTextField behavior with floating label
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 343),
          child: Container(
            height: 56,
            width: double.infinity,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(AppRadius.sm),
              border: Border.all(
                color: borderColor,
                width: 1,
              ),
            ),
            child: Stack(
              children: [
                // Filled State Display (when not focused and has text) - NO LABEL HERE
                if (_isFilledState) _buildFilledState(bgColor, textColor),
                // Placeholder (when not focused and empty)
                if (!_isFocused && !_hasText)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.hintText ?? widget.label,
                        style: GoogleFonts.openSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: AppColorSchemes.greysMidGrey,
                        ),
                      ),
                    ),
                  ),
                // TextField (always present, visible when focused or has text)
                // WCAG 2.2: Semantics wrapper für Screenreader-Support
                Positioned.fill(
                  child: Semantics(
                    label: widget.label,
                    textField: true,
                    enabled: true,
                    focused: _isFocused,
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        if (!_focusNode.hasFocus) {
                          _focusNode.requestFocus();
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: TextField(
                          controller: _controller,
                          focusNode: _focusNode,
                          keyboardType: widget.keyboardType,
                          inputFormatters: widget.inputFormatters,
                          textInputAction: widget.textInputAction ?? TextInputAction.next,
                          onEditingComplete: widget.onEditingComplete,
                          onSubmitted: widget.onSubmitted,
                          autofillHints: widget.autofillHints,
                          onChanged: (value) {
                            widget.onChanged?.call(value);
                            if (mounted) {
                              setState(() {});
                            }
                          },
                          style: GoogleFonts.openSans(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: _isFilledState && !_isFocused
                                ? Colors
                                    .transparent // Invisible when showing filled state display
                                : widget.state == InputFieldState.error
                                    ? Colors.red
                                    : textColor,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            isDense: true,
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            contentPadding: _shouldShowLabelFloating && !_isFilledState
                                ? const EdgeInsets.only(
                                    top:
                                        8) // Consistent position: Label top(7) + label height(12) + spacing(5 when typing) = 24, minus padding(16) = 8
                                : EdgeInsets.zero,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Floating Label (only show when focused OR when typing, NOT in filled state)
                if (_shouldShowLabelFloating && !_isFilledState)
                  Positioned(
                    left: 16,
                    top: 7,
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      style: GoogleFonts.openSans(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: labelColor,
                      ),
                      child: Text(
                        widget.label,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        // Error Text - WCAG 2.2: Mit Semantics für Screenreader
        if (widget.state == InputFieldState.error && widget.errorText != null)
          Semantics(
            liveRegion: true, // Screenreader liest Änderungen automatisch vor
            child: Padding(
              padding: const EdgeInsets.only(left: 16, top: 4),
              child: Text(
                widget.errorText!,
                style: GoogleFonts.openSans(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                  color: Colors.red,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildDropdownField(
    Color bgColor,
    Color borderColor,
    Color labelColor,
    Color textColor,
  ) {
    final hasValue = widget.value != null && widget.value!.isNotEmpty;
    final displayValue = hasValue ? widget.value! : (widget.hintText ?? '');
    final isMultilineValue = displayValue.contains('\n');
    final bool isDisabled = widget.onTap == null;
    final Color effectiveBackground =
        isDisabled ? AppColorSchemes.greysLightGrey : bgColor;
    final Color effectiveTextColor =
        isDisabled ? AppColorSchemes.greysMidGrey : textColor;
    final IconData trailingIcon = widget.trailingIcon ??
        (isDisabled ? Icons.calendar_today : Icons.expand_more);
    final Color trailingColor = widget.trailingIconColor ??
        (isDisabled ? AppColorSchemes.greysMidGrey : effectiveTextColor);

    // WCAG 2.2: Semantics für Dropdown
    return Semantics(
      button: true,
      enabled: !isDisabled,
      label: '${widget.label}: $displayValue',
      hint: isDisabled ? 'Deaktiviert' : 'Doppeltippen zum Öffnen',
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        child: Container(
        constraints: const BoxConstraints(minHeight: 56),
        decoration: BoxDecoration(
          color: effectiveBackground,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: Border.all(
            color: borderColor,
            width: 1,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: isMultilineValue
                    ? MainAxisAlignment.start
                    : MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Label (only show if has value or not in default state)
                  if (hasValue || widget.state != InputFieldState.defaultValue)
                    Text(
                      widget.label,
                      style: GoogleFonts.openSans(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: widget.labelColorOverride ?? labelColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  // Value
                  Text(
                    displayValue,
                    style: GoogleFonts.openSans(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: hasValue
                          ? effectiveTextColor
                          : AppColorSchemes.greysMidGrey,
                      height: isMultilineValue ? 1.4 : 1.0,
                    ),
                    softWrap: true,
                    overflow: isMultilineValue
                        ? TextOverflow.visible
                        : TextOverflow.ellipsis,
                    maxLines: isMultilineValue ? null : 1,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              trailingIcon,
              size: 24,
              color: trailingColor,
              semanticLabel: isDisabled ? 'Kalender' : 'Dropdown öffnen',
            ),
          ],
        ),
      ),
      ),
    );
  }

  Widget _buildSimpleInputField(Color bgColor, Color borderColor, Color textColor) {
    // Update border color based on focus state
    final currentBorderColor = _isFocused
        ? AppColorSchemes.primaryDarkYellow
        : (widget.state == InputFieldState.error
            ? Colors.red
            : Colors.transparent);
    
    // Calculate height based on maxLines
    final hasMultipleLines = widget.maxLines != null && widget.maxLines! > 1;
    final containerHeight = hasMultipleLines ? 104.0 : 56.0;

    final labelTextStyle = _staticLabelStyle(
      color: widget.state == InputFieldState.error
          ? Colors.red
          : _staticLabelColor,
    );

    // WCAG 2.2: Semantics wrapper für Screenreader
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Semantics(
          label: widget.label,
          textField: true,
          enabled: true,
          focused: _isFocused,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 343),
            child: Container(
              height: containerHeight,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(AppRadius.sm),
                border: Border.all(
                  color: currentBorderColor,
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Static label inside field (same as Country dropdown)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 7, 16, 0),
                    child: Text(
                      widget.label,
                      style: labelTextStyle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      keyboardType: widget.keyboardType,
                      inputFormatters: widget.inputFormatters,
                      textInputAction:
                          widget.textInputAction ?? TextInputAction.next,
                      onEditingComplete: widget.onEditingComplete,
                      onSubmitted: widget.onSubmitted,
                      autofillHints: widget.autofillHints,
                      onChanged: (value) {
                        widget.onChanged?.call(value);
                        if (mounted) {
                          setState(() {});
                        }
                      },
                      maxLines: widget.maxLines ??
                          (widget.hintText
                                      ?.toLowerCase()
                                      .contains('additional') ??
                                  false
                              ? null
                              : 1),
                      textAlignVertical:
                          widget.maxLines != null && widget.maxLines! > 1
                              ? TextAlignVertical.top
                              : TextAlignVertical.center,
                      style: GoogleFonts.openSans(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: widget.state == InputFieldState.error
                            ? Colors.red
                            : textColor,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.fromLTRB(16, 0, 16, 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (widget.state == InputFieldState.error && widget.errorText != null)
          Semantics(
            liveRegion: true,
            child: Padding(
              padding: const EdgeInsets.only(left: 16, top: 4),
              child: Text(
                widget.errorText!,
                style: GoogleFonts.openSans(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                  color: Colors.red,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildFilledState(Color bgColor, Color textColor) {
    return IgnorePointer(
      // Allow taps to pass through to TextField
      child: Stack(
        children: [
          // Label - positioned at top: 7 (same as Positioned label when typing)
          Positioned(
            left: 16,
            top: 7,
            child: Text(
              widget.label,
              style: _staticLabelStyle(
                color: widget.state == InputFieldState.error
                    ? Colors.red
                    : _staticLabelColor,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Value - positioned to match TextField contentPadding.top: 8
          // Label is at top: 7, height ~12px, spacing 5px = top: 24 for text
          // Container padding is 16, so text needs top: 8 (24 - 16 = 8)
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Padding(
                padding: const EdgeInsets.only(top: 8), // Match TextField contentPadding
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    _controller.text,
                    style: GoogleFonts.openSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: widget.state == InputFieldState.error
                          ? Colors.red
                          : textColor,
                    ),
                    overflow: TextOverflow.visible,
                    maxLines: 1,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getBorderColor() {
    if (widget.state == InputFieldState.error) {
      return Colors.red;
    }
    if (_isFocused ||
        widget.state == InputFieldState.active ||
        widget.state == InputFieldState.typing) {
      // Material 3 uses primary color for active/typing states
      // Using purple/brand color as shown in Figma
      return AppColorSchemes.primaryDarkYellow;
    }
    return Colors.transparent;
  }

  Color _getLabelColor() {
    if (widget.state == InputFieldState.error) {
      return Colors.red;
    }
    // Floating label: mid grey when idle, text color when focused/typing
    if (!_shouldShowLabelFloating) {
      return _staticLabelColor;
    }
    if (_isFocused ||
        widget.state == InputFieldState.active ||
        widget.state == InputFieldState.typing) {
      return AppColorSchemes.getTextColor(widget.isDark);
    }
    return _staticLabelColor;
  }
}
