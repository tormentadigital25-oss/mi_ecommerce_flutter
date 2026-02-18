import 'package:flutter/material.dart';
import 'package:flutter_application_1/common/widgets/image_text_widgets/vertical_image_text.dart';
import 'package:flutter_application_1/features/shop/screens/sub_category/sub_categories.dart';
import 'package:flutter_application_1/utils/constants/image_strings.dart';
import 'package:get/get.dart';



class THomeCategories extends StatelessWidget {
  const THomeCategories({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: 6,
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, index) {
          return TVerticalImageText(
            image: TImages.shoeIcon,
            title: 'Shoes',
            onTap: () => Get.to(() => const SubCategoriesScreen()),
          );
        },
      ),
    );
  }
}
