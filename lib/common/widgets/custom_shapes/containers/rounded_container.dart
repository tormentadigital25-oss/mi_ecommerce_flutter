import 'package:flutter/cupertino.dart';
import 'package:flutter_application_1/utils/constants/colors.dart';
import 'package:flutter_application_1/utils/constants/sizes.dart';


class TRoundedContainer extends StatelessWidget {
  const TRoundedContainer({
    super.key,
    this.height,
    this.width,
    this.radius = TSizes.cardRadiusLg,
    this.child,
    this.padding,
    this.margin,
    this.borderColor = TColors.borderPrimary,
    this.backgroundColor = TColors.white,
    this.showBorder = false,
  });

  final double? height;
  final double? width;
  final double radius;
  final Widget? child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color borderColor;
  final Color backgroundColor;
  final bool showBorder;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        border: showBorder ? Border.all(color: borderColor) : null,
        color: backgroundColor,
      ),
      child: child,
    );
  }
}