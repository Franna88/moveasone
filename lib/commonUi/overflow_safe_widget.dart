import 'package:flutter/material.dart';

/// A widget that prevents RenderFlex overflow errors by providing safe constraints
class OverflowSafeWidget extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final bool useScrollView;
  final Axis scrollDirection;

  const OverflowSafeWidget({
    Key? key,
    required this.child,
    this.padding,
    this.useScrollView = false,
    this.scrollDirection = Axis.vertical,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget safeChild = child;

    // Add padding if specified
    if (padding != null) {
      safeChild = Padding(
        padding: padding!,
        child: safeChild,
      );
    }

    // Wrap in scroll view if needed
    if (useScrollView) {
      safeChild = SingleChildScrollView(
        scrollDirection: scrollDirection,
        physics: const BouncingScrollPhysics(),
        child: safeChild,
      );
    }

    // Provide flexible constraints
    return LayoutBuilder(
      builder: (context, constraints) {
        return ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: constraints.maxWidth.isFinite
                ? constraints.maxWidth
                : MediaQuery.of(context).size.width,
            maxHeight: constraints.maxHeight.isFinite
                ? constraints.maxHeight
                : MediaQuery.of(context).size.height,
          ),
          child: safeChild,
        );
      },
    );
  }
}

/// A Row widget that automatically handles overflow by making children flexible
class SafeRow extends StatelessWidget {
  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;

  const SafeRow({
    Key? key,
    required this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.max,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      children: children.map((child) {
        // Wrap non-flexible widgets in Flexible
        if (child is Flexible || child is Expanded) {
          return child;
        }
        return Flexible(child: child);
      }).toList(),
    );
  }
}

/// A Column widget that automatically handles overflow by making children flexible
class SafeColumn extends StatelessWidget {
  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;

  const SafeColumn({
    Key? key,
    required this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.max,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      children: children.map((child) {
        // Wrap non-flexible widgets in Flexible
        if (child is Flexible || child is Expanded) {
          return child;
        }
        return Flexible(child: child);
      }).toList(),
    );
  }
}
