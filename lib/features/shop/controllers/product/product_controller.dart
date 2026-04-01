import 'package:flutter_application_1/data/repositories/product/product_repository.dart';
import 'package:flutter_application_1/features/shop/models/dummy_data.dart';
import 'package:flutter_application_1/features/shop/models/product_model.dart';
import 'package:flutter_application_1/utils/constants/enums.dart';
import 'package:flutter_application_1/utils/popus/loaders.dart';
import 'package:get/get.dart';

/// Gestiona el estado de los productos: carga, almacenamiento y manejo de errores.
class ProductController extends GetxController {
  static ProductController get instance => Get.find();
  final isLoading = false.obs;
  final productRepository = Get.put(ProductRepository());
  RxList<ProductModel> featuredProducts = <ProductModel>[].obs;

  @override
  void onInit() async {
    super.onInit();

    try {
      //await productRepository.uploadDummyData(TDummyData.products);
      fetchFeaturedProducts();
    } catch (e) {
      print('Error en onInit: $e');
    }
  }

  // Llama al repositorio y actualiza el estado de la UI según el resultado.
  void fetchFeaturedProducts() async {
    try {
      isLoading.value = true;

      final products = await productRepository.getFeaturedProducts();
      // Actualiza la lista reactiva para que la UI se renderice automáticamente
      featuredProducts.assignAll(products);
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<List<ProductModel>> fetchAllFeaturedProducts() async {
    try {
      final products = await productRepository.getFeaturedProducts();
      return products;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
      return [];
    }
  }

  String getProductPrice(ProductModel product) {
    double smallestPrice = double.infinity;
    double largestPrice = 0.0;

    if (product.productType == ProductType.single.toString()) {
      // PROTECCIÓN: Si salePrice es nulo, usa price
      return ((product.salePrice ?? 0.0) > 0.0
              ? product.salePrice
              : product.price)
          .toString();
    } else {
      // PROTECCIÓN: Si productVariations es nulo, devolvemos un precio por defecto o '0'
      final variations = product.productVariations;
      if (variations == null || variations.isEmpty) return '0.0';

      for (var variation in variations) {
        double priceToConsider =
            variation.salePrice > 0.0 ? variation.salePrice : variation.price;

        if (priceToConsider < smallestPrice) {
          smallestPrice = priceToConsider;
        }

        if (priceToConsider > largestPrice) {
          largestPrice = priceToConsider;
        }
      }

      // Si no se encontró ningún precio, manejamos ese caso
      if (largestPrice == 0.0) return '0.0';

      if (smallestPrice.isEqual(largestPrice)) {
        return largestPrice.toString();
      } else {
        return '$smallestPrice - $largestPrice';
      }
    }
  }

  String? calculateSalePercentage(double originalPrice, double? salePrice) {
    if (salePrice == null || salePrice <= 0.0) return null;
    if (originalPrice <= 0) return null;

    double percentage = ((originalPrice - salePrice) / originalPrice) * 100;
    return percentage.toStringAsFixed(0);
  }

  String getProductStockStatus(int stock) {
    return stock > 0 ? 'In Stock' : 'Out of Stock';
  }
}
