import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/repositories/user/user_repository.dart';
import 'package:flutter_application_1/features/personalization/controllers/user_controller.dart';
import 'package:flutter_application_1/features/personalization/screens/profile/profile.dart';
import 'package:flutter_application_1/utils/constants/image_strings.dart';
import 'package:flutter_application_1/utils/helpers/network_manager.dart';
import 'package:flutter_application_1/utils/popus/full_screen_loader.dart';
import 'package:flutter_application_1/utils/popus/loaders.dart';
import 'package:get/get.dart';

class UpdateNameController extends GetxController {
  static UpdateNameController get instance => Get.find();

  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final userController = UserController.instance;
  final userRepository = Get.put(UserRepository());
  GlobalKey<FormState> updateUserNameFormkey = GlobalKey<FormState>();

  @override
  void onInit() {
    initializeNames();
    super.onInit();
  }

  /// [NUEVO]: Carga los nombres actuales del UserController a los campos de texto al abrir la pantalla.
  Future<void> initializeNames() async {
    firstName.text = userController.user.value.firstName;
    lastName.text = userController.user.value.lastName;
  }
  /// [NUEVO]: Proceso para guardar el nuevo nombre en Firestore y actualizar la UI localmente.
  Future<void> updateUserName() async {
    try {
      TFullScreenLoader.openLoadingDialog(
          'We are updating your information...', TImages.docerAnimation);
      // ... validaciones de conexión y formulario
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }
      if (!updateUserNameFormkey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }
      // 1. Prepara los datos para Firestore (usando las mismas llaves del modelo).
      Map<String, dynamic> name = {
        'FirstName': firstName.text.trim(),
        'LastName': lastName.text.trim()
      };
      // 2. Actualiza solo esos campos en la base de datos.
      await userRepository.updateSingleField(name);
      // 3. Actualiza los datos en memoria para que el cambio sea instantáneo en toda la app.
      userController.user.value.firstName = firstName.text.trim();
      userController.user.value.lastName = lastName.text.trim();

      TFullScreenLoader.stopLoading();

      TLoaders.successSnackBar(
          title: 'Congratulations', message: 'Your name has been updated');
      // Regresa a la pantalla de perfil para ver los cambios.
      Get.off(() => const ProfileScreen());
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }
}
