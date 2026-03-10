import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/common/widgets/shimmers/shimmer.dart';
import 'package:flutter_application_1/utils/constants/colors.dart';
import 'package:flutter_application_1/utils/constants/sizes.dart';
import 'package:flutter_application_1/utils/helpers/helpers_functions.dart';

class TCircularImage extends StatelessWidget {
  const TCircularImage({
    super.key,
    this.fit = BoxFit.cover,
    required this.image,
    this.isNetworkImage = false,
    this.overlayColor,
    this.backgroundColor,
    this.width = 56,
    this.height = 56,
    this.padding = TSizes.sm,
  });

  final BoxFit? fit;
  final String image;
  final bool isNetworkImage;
  final Color? overlayColor;
  final Color? backgroundColor;
  final double width, height, padding;

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    
    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: backgroundColor ?? (isDark ? TColors.black : TColors.white),
        borderRadius: BorderRadius.circular(100),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: Center( // Agregamos un Center por si el placeholder es pequeño
          child: _buildImageWidget(),
        ),
      ),
    );
  }

  // --- Lógica de renderizado con escudo de seguridad ---
  Widget _buildImageWidget() {
    // 1. ESCUDO: Si el string de la imagen está vacío, no disparamos el error
    if (image.isEmpty) {
      return const Icon(Icons.storefront, size: 20); // O cualquier placeholder
    }

    // 2. Si hay datos, procedemos normalmente
    if (isNetworkImage) {
      return CachedNetworkImage(
        fit: fit ?? BoxFit.cover,
        color: overlayColor,
        imageUrl: image,
        progressIndicatorBuilder: (context, url, downloadProgress) =>
            const TShimmerEffect(width: 55, height: 55),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      );
    } else {
      return Image(
        fit: fit,
        image: AssetImage(image),
        color: overlayColor,
      );
    }
  }
}