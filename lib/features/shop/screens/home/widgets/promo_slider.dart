import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/common/widgets/custom_shapes/containers/circular_container.dart';
import 'package:flutter_application_1/common/widgets/images/t_rounded_image.dart';
import 'package:flutter_application_1/features/shop/controllers/home_controller.dart';
import 'package:flutter_application_1/utils/constants/colors.dart';
import 'package:flutter_application_1/utils/constants/sizes.dart';
import 'package:get/get.dart';


class TPromoSlider extends StatelessWidget {
  const TPromoSlider({super.key, required this.banners});

  final List<String> banners;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());
    return Column(
      children: [
        CarouselSlider(
          items: banners.map((url) => TRoundedImage(imageUrl: url)).toList(),
          options: CarouselOptions(
            viewportFraction: 1.0,
            onPageChanged: (index, _) => controller.updatePageIndicator(index),
          ),
        ),
        const SizedBox(height: TSizes.spaceBtwItems),
        Center(
          child: Obx(
            () => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (int i = 0; i < banners.length; i++)
                  TCircularContainer(
                    width: 20,
                    margin:const EdgeInsets.only(right: 10),
                    height: 4,
                    backgroundColor: controller.carouselCurrentIndex.value == i
                        ? TColors.primary
                        : TColors.grey,
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}