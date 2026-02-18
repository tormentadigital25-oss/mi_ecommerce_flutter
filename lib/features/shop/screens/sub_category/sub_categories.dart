import 'package:flutter/material.dart';
import 'package:flutter_application_1/common/widgets/appbar/appbar.dart';
import 'package:flutter_application_1/common/widgets/images/t_rounded_image.dart';
import 'package:flutter_application_1/common/widgets/products/product_cards/product_card_horizontal.dart';
import 'package:flutter_application_1/common/widgets/texts/section_heading.dart';
import 'package:flutter_application_1/utils/constants/image_strings.dart';
import 'package:flutter_application_1/utils/constants/sizes.dart';


class SubCategoriesScreen extends StatelessWidget {
  const SubCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TAppBar(title: Text('Sports'), showBackArrow: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              const TRoundedImage(
                imageUrl: TImages.promoBanner1,
                width: double.infinity,
                applyImageRadius: true,
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              Column(
                children: [
                  TSectionHeading(title: 'Sports shirts', onPressed: () {}),
                  const SizedBox(height: TSizes.spaceBtwItems / 2),

                  SizedBox(
                    height: 120,
                    child: ListView.separated(
                      itemCount: 4,
                      scrollDirection: Axis.horizontal,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: TSizes.spaceBtwItems),
                      itemBuilder: (context, index) =>
                          const TProductCardHorizontal(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
