import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/data/repositories/product/product_repository.dart';
import 'package:flutter_application_1/features/shop/models/product_model.dart';
import 'package:flutter_application_1/utils/popus/loaders.dart';
import 'package:get/get.dart';

class AllProductsController extends GetxController {
  static AllProductsController get instance => Get.find();

  final repository = ProductRepository.instance;
  final RxString selectedSortOption = 'Name'.obs;
  // Lista reactiva que la UI escucha mediante Obx
  final RxList<ProductModel> products = <ProductModel>[].obs;
  /// Obtiene productos basados en una consulta específica de Firebase
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
  /// Ordena la lista de productos basada en la opción seleccionada.
  /// Incluye validaciones de seguridad (Null Safety) para evitar cierres inesperados
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

    // Fuerza la actualización de la interfaz gráfica tras el reordenamiento
    products.refresh();
  }
  /// Asigna una nueva lista de productos y aplica un orden inicial por defecto.
  void assignProducts(List<ProductModel> products){
    this.products.assignAll(products);
    sortProducts('Name');
  }
}
