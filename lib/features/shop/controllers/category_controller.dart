import 'package:flutter_application_1/data/repositories/categories/category_repository.dart';
import 'package:flutter_application_1/features/shop/models/category_model.dart';
import 'package:flutter_application_1/utils/popus/loaders.dart';
import 'package:get/get.dart';

class CategoryController extends GetxController {
  static CategoryController get instance => Get.find();

  final isLoading = false.obs;
  final _categoryRepository = Get.put(CategoryRepository());
  //redibujar la panatalla si cambia un elemento de la lista de categorias
  RxList<CategoryModel> allCategories = <CategoryModel>[].obs;
  RxList<CategoryModel> featuredCategories = <CategoryModel>[].obs;

  @override
  void onInit() {
    fetchCategories();
    super.onInit();
  }

  Future<void> fetchCategories() async {
    try {
      //mostrar el loader mientras se cargan las categorias
      isLoading.value = true;
      //trae las categorias desde la data en firebase
      final categories = await _categoryRepository.getAllCategories();
      // Actualiza la lista de categorias
      allCategories.assignAll(categories);
      //filtra featured categories
      featuredCategories.assignAll(allCategories
          .where((category) => category.isFeatured && category.parentId.isEmpty)
          .take(8)
          .toList());
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  ///Cargar Category data
}
