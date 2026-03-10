import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/common/widgets/appbar/appbar.dart';
import 'package:flutter_application_1/common/widgets/custom_shapes/curved_edges/curved_edges_widget.dart';
import 'package:flutter_application_1/common/widgets/icons/t_circular_icon.dart';
import 'package:flutter_application_1/common/widgets/images/t_rounded_image.dart';
import 'package:flutter_application_1/features/shop/controllers/product/images_controller.dart';
import 'package:flutter_application_1/features/shop/models/product_model.dart';
import 'package:flutter_application_1/utils/constants/colors.dart';
import 'package:flutter_application_1/utils/constants/sizes.dart';
import 'package:flutter_application_1/utils/helpers/helpers_functions.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class TProductImageSlider extends StatelessWidget {
  const TProductImageSlider({super.key, required this.product});

  final ProductModel product;
  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    final controller = Get.put(ImagesController());
    final images = controller.getAllproductImages(product);
    return TCurvedEdgeWidget(
      child: Container(
        color: dark ? TColors.darkerGrey : TColors.light,
        child: Stack(
          children: [
            SizedBox(
              height: 400,
              child: Padding(
                padding: const EdgeInsets.all(TSizes.productImageRadius * 2),
                child: Center(child: Obx(() {
                  final image = controller.selectedProductImage.value;
                  if (image.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return GestureDetector(
                    onTap: () => controller.showEnlargedImage(image),
                    child: CachedNetworkImage(
                      imageUrl: image, // Ahora estamos seguros de que no es ""
                      progressIndicatorBuilder: (_, __, downloadProgress) =>
                          CircularProgressIndicator(
                        value: downloadProgress.progress,
                        color: TColors.primary,
                      ),
                      // También es buena práctica agregar esto por si la URL falla después
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  );
                })),
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
                  itemCount: images.length,
                  itemBuilder: (_, index) {
                    // ESCUDO 1: Si la URL de la lista está vacía, no dibujes nada.
                    if (images[index].isEmpty) return const SizedBox();

                    return Obx(() {
                      // ESCUDO 2: Verificamos que el valor del controlador no esté vacío antes de comparar
                      final selectedImage =
                          controller.selectedProductImage.value;
                      final isSelected = selectedImage == images[index];

                      return TRoundedImage(
                        width: 80,
                        isNetworkImage: true,
                        imageUrl:
                            images[index], // Este ya es seguro por el ESCUDO 1
                        padding: const EdgeInsets.all(TSizes.sm),
                        backgroundColor: dark ? TColors.dark : TColors.white,
                        onPressed: () => controller.selectedProductImage.value =
                            images[index],
                        border: Border.all(
                            color: isSelected
                                ? TColors.primary
                                : Colors.transparent),
                      );
                    });
                  },
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
