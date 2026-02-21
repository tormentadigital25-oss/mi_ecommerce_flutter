import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/common/widgets/success_screen/success_screen.dart';
import 'package:flutter_application_1/data/repositories/authentitation/authentication_repository.dart';
import 'package:flutter_application_1/utils/constants/image_strings.dart';
import 'package:flutter_application_1/utils/constants/text_strings.dart';
import 'package:flutter_application_1/utils/popus/loaders.dart';
import 'package:get/get.dart';

class VerifyEmailController extends GetxController{
  static VerifyEmailController get instance => Get.find();

  @override
  void onInit(){
    sendEmailVerification();
    setTimerForAutoRedirect();
    super.onInit();
  }

  // Send email verification link
  sendEmailVerification() async {
    try{
      await AuthenticationRepository.instance.sendEmailVerification();
      TLoaders.successSnackBar(title: 'Email Sent',message: 'Please Check your inbox and verify your email');
    }catch (e){
      TLoaders.errorSnackBar(title: 'Oh Snap!',message: e.toString());
    }
  }

  setTimerForAutoRedirect() {
  Timer.periodic(const Duration(seconds: 3), (timer) async {
    try {
      // Refrescamos los datos del servidor
      await FirebaseAuth.instance.currentUser?.reload();
      final user = FirebaseAuth.instance.currentUser;

      print("DEBUG: Revisando estado... ¿Verificado?: ${user?.emailVerified}");

      if (user != null && user.emailVerified) {
        timer.cancel();
        Get.off(() => SuccessScreen(
          image: TImages.successfullyRegisterAnimation,
          title: TTexts.yourAccountCreatedTitle,
          subTitle: TTexts.yourAccountCreatedSubTitle,
          onPressed: () => AuthenticationRepository.instance.screenRedirect(),
        ));
      }
    } catch (e) {
      print("DEBUG: Error en Timer: $e");
      // No lo canceles todavía para que siga intentando a menos que sea un error fatal
    }
  });
}

  checkEmailVerificationStatus() async{
    await FirebaseAuth.instance.currentUser?.reload();
    final currentUser = FirebaseAuth.instance.currentUser;
    if(currentUser != null && currentUser.emailVerified){
      Get.off(()=> SuccessScreen(
        image: TImages.successfullyRegisterAnimation, 
        title: TTexts.yourAccountCreatedTitle, 
        subTitle: TTexts.yourAccountCreatedSubTitle,
        onPressed: ()=> AuthenticationRepository.instance.screenRedirect()));
    } else {
    // Tip: Si no está verificado, muestra un mensaje para saber que el botón sí funciona
    TLoaders.warningSnackBar(title: 'Aún no verificado', message: 'Por favor, verifica tu correo y espera unos segundos.');
  }
  }
}