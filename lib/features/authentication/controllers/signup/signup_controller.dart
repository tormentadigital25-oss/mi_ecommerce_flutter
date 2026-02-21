import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/repositories/authentitation/authentication_repository.dart';
import 'package:flutter_application_1/data/repositories/user/user_repository.dart';
import 'package:flutter_application_1/features/authentication/screens/signup/verify_email.dart';
import 'package:flutter_application_1/personalization/models/user_model.dart';
import 'package:flutter_application_1/utils/constants/image_strings.dart';
import 'package:flutter_application_1/utils/helpers/network_manager.dart';
import 'package:flutter_application_1/utils/popus/full_screen_loader.dart';
import 'package:flutter_application_1/utils/popus/loaders.dart';
import 'package:get/get.dart';

class SignupController extends GetxController{
  static SignupController get instance => Get.find();

  final hidePassword = true.obs; // observable para mostrar u ocultar el password
  final privacyPolicy = true.obs; 
  final email = TextEditingController();
  final lastName = TextEditingController();
  final userName = TextEditingController();
  final password = TextEditingController();
  final firstName = TextEditingController();
  final phoneNumber = TextEditingController();
  GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();


   void signup() async{
    try{
    //Start loading
    TFullScreenLoader.openLoadingDialog('We are processing your information...',TImages.docerAnimation);
    //Check internet connection
    final isConnected = await NetworkManager.instance.isConnected();
    if(!isConnected){
      TFullScreenLoader.stopLoading();
      return;
    };
    
    //Form Validation
    if(!signupFormKey.currentState!.validate()){
      TFullScreenLoader.stopLoading();
      return;
    };

    //Privacy Policy
    if(!privacyPolicy.value){
      TLoaders.warningSnackBar(title: 'Accept Privacy policy',message: 'In order to create your account, You must read and accept the Privacy Policy abd Terms of use');
      return;
    }

    final userCredential = await AuthenticationRepository.instance.registerWithEmailAndPassword(email.text.trim(), password.text.trim());
    
     final newUser = UserModel(
        id: userCredential.user!.uid, 
        firstName: firstName.text.trim(), 
        lastName: lastName.text.trim(),   
        username: userName.text.trim(),    
        email: email.text.trim(),
        phoneNumber: phoneNumber.text.trim(),
        profilePicture: '',        
      );

      final userRepository = Get.put(UserRepository());
      await userRepository.saveUserRecord(newUser);

      TFullScreenLoader.stopLoading();

      TLoaders.successSnackBar(title: 'Congratulations',message: 'Your account has been created! Verify your email to continue');
      
      Get.to(()=>VerifyEmailScreen(email: email.text.trim()));

    }catch(e){
      TFullScreenLoader.stopLoading();
      // show more generic error to the user
      TLoaders.errorSnackBar(title:'Oh Snap!',message: e.toString());
    }
  }

}