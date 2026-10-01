import 'package:flutter/material.dart';

/// WCAG 2.2 Accessibility Helpers
/// 
/// Diese Datei enthält Helper-Widgets und Extensions für WCAG 2.2 Konformität:
/// - Semantics-Labels für Icons, Buttons, Images
/// - Minimum Touch-Target Größen (48x48dp)
/// - Text-Skalierung Support

/// Minimum Touch-Target Size nach WCAG 2.5.5 (Level AAA: 44x44, Level AA: 24x24)
/// Wir verwenden 48x48 als Best Practice
const double kMinTouchTargetSize = 48.0;

/// Icon mit Semantics-Label
/// 
/// Verwendet anstelle von `Icon(...)` für bessere Accessibility
class AccessibleIcon extends StatelessWidget {
  final IconData icon;
  final String semanticLabel;
  final double? size;
  final Color? color;

  const AccessibleIcon({
    super.key,
    required this.icon,
    required this.semanticLabel,
    this.size,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      child: Icon(
        icon,
        size: size,
        color: color,
        semanticLabel: semanticLabel,
      ),
    );
  }
}

/// IconButton mit garantiertem Tooltip und Minimum Touch-Target
/// 
/// Verwendet anstelle von `IconButton(...)` für bessere Accessibility
class AccessibleIconButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;
  final double? iconSize;
  final Color? color;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;

  const AccessibleIconButton({
    super.key,
    required this.icon,
    required this.tooltip,
    this.onPressed,
    this.iconSize = 24,
    this.color,
    this.backgroundColor,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: tooltip,
      child: Tooltip(
        message: tooltip,
        child: Material(
          color: backgroundColor ?? Colors.transparent,
          borderRadius: BorderRadius.circular(kMinTouchTargetSize / 2),
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(kMinTouchTargetSize / 2),
            child: Container(
              width: kMinTouchTargetSize,
              height: kMinTouchTargetSize,
              padding: padding ?? EdgeInsets.zero,
              alignment: Alignment.center,
              child: Icon(
                icon,
                size: iconSize,
                color: color,
                semanticLabel: tooltip,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Image mit garantiertem Semantics-Label
/// 
/// Verwendet anstelle von `Image.asset(...)` für bessere Accessibility
class AccessibleImage extends StatelessWidget {
  final String assetPath;
  final String semanticLabel;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Color? color;

  const AccessibleImage({
    super.key,
    required this.assetPath,
    required this.semanticLabel,
    this.width,
    this.height,
    this.fit,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      image: true,
      child: Image.asset(
        assetPath,
        width: width,
        height: height,
        fit: fit,
        color: color,
        semanticLabel: semanticLabel,
      ),
    );
  }
}

/// Tappable Container mit Minimum Touch-Target
/// 
/// Verwendet für custom tappable Widgets um 48x48dp Minimum zu garantieren
class AccessibleTapTarget extends StatelessWidget {
  final Widget child;
  final String semanticLabel;
  final VoidCallback? onTap;
  final bool isButton;
  final double minWidth;
  final double minHeight;

  const AccessibleTapTarget({
    super.key,
    required this.child,
    required this.semanticLabel,
    this.onTap,
    this.isButton = true,
    this.minWidth = kMinTouchTargetSize,
    this.minHeight = kMinTouchTargetSize,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: isButton,
      label: semanticLabel,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: minWidth,
            minHeight: minHeight,
          ),
          child: child,
        ),
      ),
    );
  }
}

/// Extension für BuildContext um Text-Skalierung zu erhalten
extension AccessibilityExtensions on BuildContext {
  /// Gibt den aktuellen Text Scale Factor zurück
  double get textScaleFactor => MediaQuery.textScalerOf(this).scale(1);
  
  /// Skaliert einen Wert basierend auf der Text-Skalierung
  /// Nützlich für Icon-Größen die mit Text skalieren sollen
  double scaleWithText(double value) => value * textScaleFactor;
  
  /// Prüft ob große Text-Skalierung aktiv ist (≥1.3)
  bool get isLargeTextScale => textScaleFactor >= 1.3;
  
  /// Prüft ob sehr große Text-Skalierung aktiv ist (≥2.0)
  bool get isVeryLargeTextScale => textScaleFactor >= 2.0;
}

/// Semantics-Wrapper für interaktive Karten
class AccessibleCard extends StatelessWidget {
  final Widget child;
  final String semanticLabel;
  final VoidCallback? onTap;
  final String? hint;

  const AccessibleCard({
    super.key,
    required this.child,
    required this.semanticLabel,
    this.onTap,
    this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: onTap != null,
      label: semanticLabel,
      hint: hint,
      child: onTap != null
          ? InkWell(
              onTap: onTap,
              child: child,
            )
          : child,
    );
  }
}

/// Header Icon Button mit Accessibility Support
/// 
/// Ersetzt die vielen _HeaderIconButton Implementierungen in der App
class AccessibleHeaderIconButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback? onTap;
  final Color? iconColor;
  final double iconSize;

  const AccessibleHeaderIconButton({
    super.key,
    required this.icon,
    required this.tooltip,
    this.onTap,
    this.iconColor,
    this.iconSize = 24,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: tooltip,
      child: Tooltip(
        message: tooltip,
        child: InkResponse(
          onTap: onTap,
          radius: kMinTouchTargetSize / 2,
          child: SizedBox(
            width: kMinTouchTargetSize,
            height: kMinTouchTargetSize,
            child: Center(
              child: Icon(
                icon,
                size: iconSize,
                color: iconColor,
                semanticLabel: tooltip,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Focus Traversal Group für logische Fokus-Reihenfolge in Formularen
class AccessibleFormGroup extends StatelessWidget {
  final List<Widget> children;
  final String? semanticLabel;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;
  final double spacing;

  const AccessibleFormGroup({
    super.key,
    required this.children,
    this.semanticLabel,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.spacing = 16,
  });

  @override
  Widget build(BuildContext context) {
    final spacedChildren = <Widget>[];
    for (int i = 0; i < children.length; i++) {
      spacedChildren.add(children[i]);
      if (i < children.length - 1) {
        spacedChildren.add(SizedBox(height: spacing));
      }
    }

    Widget content = Column(
      crossAxisAlignment: crossAxisAlignment,
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: MainAxisSize.min,
      children: spacedChildren,
    );

    if (semanticLabel != null) {
      content = Semantics(
        label: semanticLabel,
        container: true,
        child: content,
      );
    }

    return FocusTraversalGroup(
      policy: OrderedTraversalPolicy(),
      child: content,
    );
  }
}
