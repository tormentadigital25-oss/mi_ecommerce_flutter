import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/data/repositories/product/product_repository.dart';
import 'package:flutter_application_1/features/shop/models/product_model.dart';
import 'package:flutter_application_1/utils/popus/loaders.dart';
import 'package:get/get.dart';

class AllProductsController extends GetxController {
  static AllProductsController get instance => Get.find();

  final repository = ProductRepository.instance;
  final RxString selectedSortOption = 'Name'.obs;
  final RxList<ProductModel> products = <ProductModel>[].obs;
  Future<List<ProductModel>> fetchProductsByQuery(Query? query) async {
    try {
      if (query == null) return [];
      final products = await repository.fetchProductsByQuery(query);
      return products;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
      return [];
    }
  }

  void sortProducts(String sortOption) {
    selectedSortOption.value = sortOption;

    switch (sortOption) {
      case 'Name':
        products.sort((a, b) => a.title.compareTo(b.title));
        break;

      case 'Higher Price':
        products.sort((a, b) => b.price.compareTo(a.price));
        break;

      case 'Lower Price':
        products.sort((a, b) => a.price.compareTo(b.price));
        break;

      case 'Newest':
        products.sort((a, b) {
          // Usamos una fecha muy antigua como valor por defecto si es null
          final dateA = a.date ?? DateTime(1970);
          final dateB = b.date ?? DateTime(1970);
          return dateB.compareTo(dateA); // De más reciente a más antiguo
        });
        break;

      case 'Sale':
        products.sort((a, b) {
          // Tratamos cualquier null como 0.0 para poder comparar números
          final saleA = a.salePrice ?? 0.0;
          final saleB = b.salePrice ?? 0.0;
          return saleB.compareTo(saleA); // Ordena de mayor descuento a menor
        });
        break;

      default:
        products.sort((a, b) => a.title.compareTo(b.title));
    }

    // IMPORTANTE: Esto le dice a la UI que debe redibujarse con el nuevo orden
    products.refresh();
  }

  void assignProducts(List<ProductModel> products){
    this.products.assignAll(products);
    sortProducts('Name');
  }
}
