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
  /// Almacenamiento local (para saber si es la primera vez que abre la app) y conexión con Firebase Auth.
  final deviceStorage = GetStorage();
  final _auth = FirebaseAuth.instance;

  /// Se ejecuta al iniciar la app: quita la pantalla de carga (Splash) y decide a dónde enviar al usuario.(Boton de encendido del coche)
  @override
  void onReady(){  
    //AuthenticationRepository.instance.logout();  
    FlutterNativeSplash.remove();
    screenRedirect();
  }
  
  /// EL CEREBRO DE LA NAVEGACIÓN: Evalúa si el usuario está logueado, verificado o si es nuevo para mostrar la pantalla correcta.
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

  Future<UserCredential> loginWithEmailAndPassword(String email,String password) async{
    try {
    return await _auth.signInWithEmailAndPassword(email: email, password: password);
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

  /// Crea una nueva cuenta en Firebase Authentication usando correo y contraseña.
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

  /// Envía el correo electrónico de validación al usuario que acaba de registrarse.
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

  /// Cierra la sesión activa y redirige al usuario a la pantalla de Login.
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

