import 'package:flutter_application_1/data/repositories/authentitation/authentication_repository.dart';
import 'package:flutter_application_1/data/repositories/brand/brand_repository.dart';
import 'package:flutter_application_1/data/repositories/categories/category_repository.dart';
import 'package:flutter_application_1/data/repositories/user/user_repository.dart';
import 'package:flutter_application_1/features/personalization/controllers/user_controller.dart';
import 'package:flutter_application_1/features/shop/controllers/category_controller.dart';
import 'package:flutter_application_1/features/shop/controllers/product/brand_controller.dart';
import 'package:flutter_application_1/utils/helpers/network_manager.dart';
import 'package:get/get.dart';


class GeneralBindings extends Bindings {
  @override
  void dependencies() {
    // 1. Primero inyectamos las herramientas (Repositorios)
    Get.put(NetworkManager());
    Get.put(BrandRepository()); // <--- ¡Esto es lo que te falta!
    Get.put(CategoryRepository());
    
    // 2. Luego inyectamos los controladores que usan esas herramientas
    Get.put(BrandController()); 
    Get.put(CategoryController());
    Get.put(UserController());
  }
}