import 'package:flutter/material.dart';
import 'package:flutter_application_1/common/widgets/icons/t_circular_icon.dart';
import 'package:flutter_application_1/utils/constants/colors.dart';
import 'package:flutter_application_1/utils/constants/sizes.dart';
import 'package:flutter_application_1/utils/helpers/helpers_functions.dart';
import 'package:iconsax/iconsax.dart';



class TProductQuantityWithAddRemoveButton extends StatelessWidget {
  const TProductQuantityWithAddRemoveButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        TCircularIcon(
          icon: Iconsax.minus,
          height: 32,
          width: 32,
          size: TSizes.md,
          color: THelperFunctions.isDarkMode(context)
              ? TColors.white
              : TColors.black,
          backgroundColor: THelperFunctions.isDarkMode(context)
              ? TColors.darkerGrey
              : TColors.light,
        ),
        const SizedBox(width: TSizes.spaceBtwItems),
        Text(
          '2',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(width: TSizes.spaceBtwItems),
        const TCircularIcon(
          icon: Iconsax.add,
          height: 32,
          width: 32,
          size: TSizes.md,
          color: TColors.white,
          backgroundColor: TColors.primary,
        ),
      ],
    );
  }
}