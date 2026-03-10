import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/shop/models/product_model.dart';
import 'package:flutter_application_1/utils/constants/sizes.dart';
import 'package:get/get.dart';

class ImagesController extends GetxController {
  static ImagesController get instance => Get.find();
  RxString selectedProductImage = ''.obs;

  // Obtiene todas las imagenes de products y variations
  List<String> getAllproductImages(ProductModel product) {
    Set<String> images = {};

    // 1. Check del Thumbnail

    if (product.thumbnail.isNotEmpty) {
      images.add(product.thumbnail);
      selectedProductImage.value = product.thumbnail;
    } else {}

    // 2. Check de Imágenes adicionales
    if (product.images != null) {
      images.addAll(product.images!);
    }

    // 3. Check de Variaciones
    // Nota: Cambié el || por && para evitar errores si es null
    if (product.productVariations != null &&
        product.productVariations!.isNotEmpty) {
      final variationImages = product.productVariations!
          .map((variation) => variation.image)
          .toList();

      // Filtrar por si acaso hay variaciones sin imagen
      images.addAll(variationImages.where((image) => image.isNotEmpty));
    }

    return images.toList();
  }

// Muestra una Imagen Popup
  void showEnlargedImage(String image) {
    Get.to(
        fullscreenDialog: true,
        () => Dialog.fullscreen(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: TSizes.defaultSpace,
                        vertical: TSizes.defaultSpace * 2),
                    child: CachedNetworkImage(imageUrl: image),
                  ),
                  const SizedBox(
                    height: TSizes.spaceBtwSections,
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      width: 150,
                      child: OutlinedButton(
                          onPressed: () => Get.back(),
                          child: const Text('Close')),
                    ),
                  ),
                ])));
  }
}
