import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/features/authentication/screens/login/login.dart';
import 'package:flutter_application_1/features/authentication/screens/onboarding/onboarding.dart';
import 'package:flutter_application_1/features/authentication/screens/signup/verify_email.dart';
import 'package:flutter_application_1/navigation_menu.dart';
import 'package:flutter_application_1/utils/exceptions/firebase_auth_exceptions.dart';
import 'package:flutter_application_1/utils/exceptions/firebase_exceptions.dart';
import 'package:flutter_application_1/utils/exceptions/format_exceptions.dart';
import 'package:flutter_application_1/utils/exceptions/platform_exceptions.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AuthenticationRepository extends GetxController{
  static AuthenticationRepository get instance => Get.find();

  final deviceStorage = GetStorage();
  final _auth = FirebaseAuth.instance;

  //Lo llama desde el main en el lanzamiento
  @override
  void onReady(){  
    //AuthenticationRepository.instance.logout();  
    FlutterNativeSplash.remove();
    screenRedirect();
  }
  
  //Funcion que define si muestra el onboarding o el Login
  screenRedirect() async{
    final user = _auth.currentUser;
    if(user != null){
      if(user.emailVerified){
        Get.offAll(()=> const NavigationMenu());
      }else{
        Get.offAll(()=> VerifyEmailScreen(email: _auth.currentUser?.email,));
      }
    }else{
    deviceStorage.writeIfNull('IsFirstTime', true);
    deviceStorage.read('IsFirstTime') != true ? Get.offAll(()=> const LoginScreen()):Get.offAll(const OnBoardingScreen());

    }
    
  }

  //Registro
  Future <UserCredential> registerWithEmailAndPassword(String email,String password) async{
        try {
    return await _auth.createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  //Email Verification
  Future<void> sendEmailVerification() async{
    try {
      await _auth.currentUser?.sendEmailVerification();      
    }on FirebaseAuthException catch(e){
      throw TFirebaseAuthException(e.code).message;
    }on FirebaseException catch(e){
      throw TFirebaseException(e.code).message;
    }on FormatException catch (_){
      throw const TFormatException();
    }on PlatformException catch(e){
      throw TPlatformException (e.code).message;
    }catch (e){
      throw 'Something went wrong. Please try again';
    }

  }

    /// [LogoutUser] - Valid for any authentication.
  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();      
      // await FacebookAuth.instance.logOut();
      // await FirebaseAuth.instance.signOut();
      Get.offAll(() => const LoginScreen());
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  

  
}

