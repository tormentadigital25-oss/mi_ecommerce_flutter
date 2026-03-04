import 'package:flutter_application_1/data/repositories/banners/banner_repository.dart';
import 'package:flutter_application_1/features/shop/models/banner_model.dart';
import 'package:flutter_application_1/utils/popus/loaders.dart';
import 'package:get/get.dart';

class BannerController extends GetxController {
  // Variables Observables (.obs): Si cambian, la UI se redibuja sola
  final carouselCurrentIndex = 0.obs;
  final isLoading = false.obs;
  final RxList<BannerModel> banners = <BannerModel>[].obs;

  @override
  void onInit(){
    fetchBanners(); // Carga automática al iniciar el controlador
    super.onInit();
  }
  // Actualiza el puntito del carrusel cuando el usuario desliza
  void updatePageIndicator(index) {
    carouselCurrentIndex.value = index;
  }
  // Orquestador de la carga de datos
  Future<void> fetchBanners() async {
    try {
      //mostrar el loader mientras se cargan las categorias
      isLoading.value = true;
      final bannerRepo = Get.put(BannerRepository());
      final banners = await bannerRepo.fetchBanners();

      this.banners.assignAll(banners);
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
