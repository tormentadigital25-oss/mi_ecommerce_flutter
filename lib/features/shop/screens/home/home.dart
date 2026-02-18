import 'package:flutter/material.dart';
import 'package:flutter_application_1/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:flutter_application_1/common/widgets/custom_shapes/containers/search_container.dart';
import 'package:flutter_application_1/common/widgets/layouts/grid_layout.dart';
import 'package:flutter_application_1/common/widgets/products/product_cards/product_card_vertical.dart';
import 'package:flutter_application_1/common/widgets/texts/section_heading.dart';
import 'package:flutter_application_1/features/shop/screens/all_products/all_products.dart';
import 'package:flutter_application_1/features/shop/screens/home/widgets/home_appbar.dart';
import 'package:flutter_application_1/features/shop/screens/home/widgets/home_categories.dart';
import 'package:flutter_application_1/features/shop/screens/home/widgets/promo_slider.dart';
import 'package:flutter_application_1/utils/constants/colors.dart';
import 'package:flutter_application_1/utils/constants/image_strings.dart';
import 'package:flutter_application_1/utils/constants/sizes.dart';
import 'package:get/get.dart';





class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const TPrimaryHeaderContainer(
              child: Column(
                children: [
                  //AppBar
                  THomeAppBar(),
                  SizedBox(height: TSizes.spaceBtwSections),
                  //SearchBar
                  TSearchContainer(text: 'Search in Store'),
                  SizedBox(height: TSizes.spaceBtwSections),
                  //Categories
                  Padding(
                    padding: EdgeInsets.only(left: TSizes.defaultSpace),
                    child: Column(
                      children: [
                        TSectionHeading(
                          title: 'Popular Categories',
                          showActionButton: false,
                          textColor: TColors.white,
                        ),
                        SizedBox(height: TSizes.spaceBtwItems),
                        //Categories
                        THomeCategories(),
                      ],
                    ),
                  ),
                  SizedBox(height: TSizes.spaceBtwSections),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              child: Column(
                children: [
                  const TPromoSlider(
                    banners: [
                      TImages.promoBanner1,
                      TImages.promoBanner2,
                      TImages.promoBanner3,
                    ],
                  ),
                  //Heading
                  const SizedBox(height: TSizes.spaceBtwSections),
                  TSectionHeading(
                    title: 'Popular Products',
                    onPressed: () => Get.to(() => const AllProducts()),
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  //Popular Products
                  TGridLayout(
                    itemCount: 2,
                    itemBuilder: (_, index) => const TProductCardVertical(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}