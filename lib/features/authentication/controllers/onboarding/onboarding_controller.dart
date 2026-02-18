import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:flutter_application_1/features/authentication/screens/login/login.dart';
import 'package:get_storage/get_storage.dart';

class OnBoardingController extends GetxController {
  static OnBoardingController get instance => Get.find();

  //Variables
  final pageController = PageController();
  Rx<int> currentPageIndex = 0
      .obs; //esto es para poder detectar cambios en la pagina sin usar statefull (es una variable reactiva)

  //Update current Index when page scroll
  void updatePageIndicator(index) => currentPageIndex.value =
      index; //esto actualiza el indice al cambiar de pagina (en el onboarding)

  //Jump to the specific dot selected page.
  void doNavigationClick(index) {
    currentPageIndex.value = index;
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300), // 300ms es el estándar ideal
      curve: Curves.decelerate, // Empieza rápido y frena suavemente
    );
  }

  //Update current Index and jump to next page
  void nextPage() {
    if (currentPageIndex.value == 2) {
      final storage = GetStorage();

      if(kDebugMode){
      print('========================== GET STORAGE Next Button ==============================');
      print(storage.read('IsFirstTime'));
    }
      storage.write('IsFirstTime', false);
      Get.offAll(const LoginScreen());
    } else {
      int page = currentPageIndex.value + 1;
      pageController.animateToPage(
        page,
        duration: const Duration(
          milliseconds: 400,
        ), // Duración ideal (ni muy lenta ni muy rápida)
        curve: Curves.easeInOut, // Movimiento suave al inicio y al final
      );
    }
  }

  //Update current Index and jump to the last page
  void skipPage() {
    currentPageIndex.value = 2;
    pageController.jumpToPage(
      2,
    ); //nos lleva directo a la ultima página del onboarding
  }
}