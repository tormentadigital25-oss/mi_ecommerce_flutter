

import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/repositories/authentitation/authentication_repository.dart';
import 'package:flutter_application_1/features/authentication/screens/password_configuration/reset_password.dart';
import 'package:flutter_application_1/utils/constants/image_strings.dart';
import 'package:flutter_application_1/utils/helpers/network_manager.dart';
import 'package:flutter_application_1/utils/popus/full_screen_loader.dart';
import 'package:flutter_application_1/utils/popus/loaders.dart';
import 'package:get/get.dart';

class ForgetPasswordController extends GetxController{
  static ForgetPasswordController get instance => Get.find();
  /// [ELEMENTO NUEVO]: Controlador de texto para capturar el email en la pantalla de "Olvide mi contraseña".
  final email = TextEditingController();
  /// [ELEMENTO NUEVO]: Llave global para validar el formulario de recuperación.
  GlobalKey<FormState> forgetPasswordFormKey = GlobalKey<FormState>();

   /// [NUEVA FUNCIÓN - FLUJO INICIAL]: Valida, envía el correo y redirige a la pantalla de éxito.
  sendPasswordResetEmail()async{
    try{
       // Muestra el loader mientras se procesa la solicitud con Firebase.
      TFullScreenLoader.openLoadingDialog('Processing your request...', TImages.docerAnimation);
      final isConnected = await NetworkManager.instance.isConnected();
      if(!isConnected){
        TFullScreenLoader.stopLoading();
        return;
      }
      // Validación del campo de email antes de proceder.
      if(!forgetPasswordFormKey.currentState!.validate()){
        TFullScreenLoader.stopLoading();
        return;
      }
      // Llama a la lógica del repositorio enviando el email limpio (sin espacios).
      await AuthenticationRepository.instance.sendPasswordResetEmail(email.text.trim());

      TFullScreenLoader.stopLoading();
      // Muestra notificación de éxito al usuario.
      TLoaders.successSnackBar(title: 'Email sent',message: 'Email link sento to reset your Password'.tr);
      // Redirige a la pantalla de confirmación/espera de reseteo.
      Get.to(()=> ResetPasswordScreen(email: email.text.trim()));
    } catch(e){
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh Snap',message: e.toString());
    }
  }
  /// [NUEVA FUNCIÓN - REINTENTO]: Permite reenviar el correo si el usuario no lo recibió.
  resendPaswordResetEmail(String email)async{
    try{
      TFullScreenLoader.openLoadingDialog('Processing your request...', TImages.docerAnimation);
      final isConnected = await NetworkManager.instance.isConnected();
      if(!isConnected){
        TFullScreenLoader.stopLoading();
        return;
      }
      
      // Reintento directo usando el email que ya teníamos.
      await AuthenticationRepository.instance.sendPasswordResetEmail(email);

      TFullScreenLoader.stopLoading();

      TLoaders.successSnackBar(title: 'Email sent',message: 'Email link sento to reset your Password'.tr);

    } catch(e){
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh Snap',message: e.toString());
    }
  }


}