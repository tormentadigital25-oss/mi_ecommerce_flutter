import 'package:flutter/material.dart';
import 'package:flutter_application_1/common/widgets/appbar/appbar.dart';
import 'package:flutter_application_1/common/widgets/custom_shapes/curved_edges/curved_edges_widget.dart';
import 'package:flutter_application_1/common/widgets/icons/t_circular_icon.dart';
import 'package:flutter_application_1/common/widgets/images/t_rounded_image.dart';
import 'package:flutter_application_1/utils/constants/colors.dart';
import 'package:flutter_application_1/utils/constants/image_strings.dart';
import 'package:flutter_application_1/utils/constants/sizes.dart';
import 'package:flutter_application_1/utils/helpers/helpers_functions.dart';
import 'package:iconsax/iconsax.dart';


class TProductImageSlider extends StatelessWidget {
  const TProductImageSlider({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return TCurvedEdgeWidget(
      child: Container(
        color: dark ? TColors.darkerGrey : TColors.light,
        child: Stack(
          children: [
            const SizedBox(
              height: 400,
              child: Padding(
                padding: EdgeInsets.all(TSizes.productImageRadius * 2),
                child: Center(
                  child: Image(image: AssetImage(TImages.productImage5)),
                ),
              ),
            ),
            //Image Slider
            Positioned(
              right: 0,
              bottom: 30,
              left: TSizes.defaultSpace,
              child: SizedBox(
                height: 80,
                child: ListView.separated(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  physics: const AlwaysScrollableScrollPhysics(),
                  separatorBuilder: (_, __) =>
                      const SizedBox(width: TSizes.spaceBtwItems),
                  itemCount: 6,
                  itemBuilder: (_, index) => TRoundedImage(
                    width: 80,
                    backgroundColor: dark ? TColors.dark : TColors.white,
                    imageUrl: TImages.productImage13,
                    padding: const EdgeInsets.all(TSizes.sm),
                    border: Border.all(color: TColors.primary),
                  ),
                ),
              ),
            ),
            //Appbar Icons
            const TAppBar(
              showBackArrow: true,
              actions: [TCircularIcon(icon: Iconsax.heart5, color: Colors.red)],
            ),
          ],
        ),
      ),
    );
  }
}
