

import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/repositories/authentitation/authentication_repository.dart';
import 'package:flutter_application_1/features/personalization/controllers/user_controller.dart';
import 'package:flutter_application_1/utils/constants/image_strings.dart';
import 'package:flutter_application_1/utils/helpers/network_manager.dart';
import 'package:flutter_application_1/utils/popus/full_screen_loader.dart';
import 'package:flutter_application_1/utils/popus/loaders.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LoginController extends GetxController {

  final rememberMe = false.obs;
  final hidePassword = true.obs;
  final localStorage = GetStorage();
  final email= TextEditingController();
  final password = TextEditingController();
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final userController = Get.put(UserController());

/// Al iniciar: Recupera el correo y clave guardados si el usuario marcó "Recuérdame" anteriormente.
  @override
  void onInit(){
    email.text=localStorage.read('REMEMBER_ME_EMAIL')?? '';
    password.text =localStorage.read('REMEMBER_ME_PASSWORD')?? '';
    super.onInit();
  }
/// PROCESO DE LOGIN: Valida el formulario, gestiona el recordatorio de datos y autentica con Firebase.
  Future<void> emailAndPasswordSignIn() async{
    try {
      TFullScreenLoader.openLoadingDialog('Logging you in...', TImages.docerAnimation);

      final isConnected = await NetworkManager.instance.isConnected();
      if(!isConnected){
        TFullScreenLoader.stopLoading();
        return;
      }
      if(!loginFormKey.currentState!.validate()){
        TFullScreenLoader.stopLoading();
        return;
      }

      if(rememberMe.value){
        localStorage.write('REMEMBER_ME_EMAIL', email.text.trim());
        localStorage.write('REMEMBER_ME_PASSWORD', password.text.trim());
      }

      final UserCredential = await AuthenticationRepository.instance.loginWithEmailAndPassword(email.text.trim(), password.text.trim());

      TFullScreenLoader.stopLoading();

      AuthenticationRepository.instance.screenRedirect();

    } catch(e){
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title:'Oh Snap!',message: e.toString());
    }
  }
  /// [NUEVO - LOGIN GOOGLE]: Orquestador del botón de Google. Une la autenticación con el guardado de datos.
  Future<void> googleSignIn() async{
    try {
      TFullScreenLoader.openLoadingDialog('Logging you in...', TImages.docerAnimation);
      final isConnected = await NetworkManager.instance.isConnected();
      if(!isConnected){
        TFullScreenLoader.stopLoading();
        return;
      }
      // 1. Llama al repositorio para obtener las credenciales de Google.
      final userCredentials =await AuthenticationRepository.instance.signInWithGoogle();

      // 2. [CRÍTICO]: Envía las credenciales al UserController para crear el registro en la base de datos (Firestore).
      await userController.saveUserRecord(userCredentials);

      TFullScreenLoader.stopLoading();
      // 3. Redirige al usuario al Home o Menú principal.
      AuthenticationRepository.instance.screenRedirect();

    }catch(e){
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh Snap',message: e.toString());
    }
  }



}