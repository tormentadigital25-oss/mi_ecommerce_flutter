import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/repositories/authentitation/authentication_repository.dart';
import 'package:flutter_application_1/data/repositories/user/user_repository.dart';
import 'package:flutter_application_1/features/authentication/screens/login/login.dart';
import 'package:flutter_application_1/features/personalization/screens/profile/widgets/re_authenticate_user_login_form.dart';
import 'package:flutter_application_1/personalization/models/user_model.dart';
import 'package:flutter_application_1/utils/constants/image_strings.dart';
import 'package:flutter_application_1/utils/constants/sizes.dart';
import 'package:flutter_application_1/utils/helpers/network_manager.dart';
import 'package:flutter_application_1/utils/popus/full_screen_loader.dart';
import 'package:flutter_application_1/utils/popus/loaders.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class UserController extends GetxController {
  static UserController get instance => Get.find();
  final profileLoading = false.obs;
  Rx<UserModel> user = UserModel.empty().obs;
  final hidePassword = false.obs;
  final verifyEmail = TextEditingController();
  final verifyPassword = TextEditingController();
  final userRepository = Get.put(UserRepository());
  GlobalKey<FormState> reAuthFormkey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    fetchUserRecord();
  }

  Future<void> fetchUserRecord() async {
    try {
      profileLoading.value = true;
      final user = await userRepository.fetchUserDetails();
      this.user(user);
    } catch (e) {
      user(UserModel.empty());
    } finally {
      profileLoading.value = false;
    }
  }

  /// [NUEVO - REGISTRO EN DB]: Extrae la información del perfil de Google (Nombre, Foto, Email) y la guarda en Firestore.
  Future<void> saveUserRecord(UserCredential? userCredentials) async {
    try {
      // para refrescar user record
      await fetchUserRecord();
      if (user.value.id.isEmpty) {
        if (userCredentials != null) {
          // 1. Procesa el nombre completo para dividirlo en nombre y apellido.
          final nameParts =
              UserModel.nameParts(userCredentials.user!.displayName ?? '');
          // 2. Genera un nombre de usuario automático basado en su nombre.
          final username = UserModel.generateUsername(
              userCredentials.user!.displayName ?? '');
          // 3. Mapea los datos de Google a nuestro modelo de usuario de la App.
          final user = UserModel(
              id: userCredentials.user!.uid,
              firstName: nameParts[0],
              lastName:
                  nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '',
              username: username,
              email: userCredentials.user!.email ?? '',
              phoneNumber: userCredentials.user!.phoneNumber ?? '',
              profilePicture: userCredentials.user!.photoURL ?? '');
          // 4. Guarda físicamente el registro en la colección "Users" de Firestore.
          print("ID: ${userCredentials.user!.uid}");
          print("USERNAME GENERADO: $username");
          await userRepository.saveUserRecord(user);
        }
      }
    } catch (e) {
      TLoaders.warningSnackBar(
          title: 'Data not saved',
          message:
              'Something went wrong while saving your information. You can re-save your data in your Profile');
    }
  }

  void deleteAccountWarningPopup() {
    Get.defaultDialog(
        contentPadding: const EdgeInsets.all(TSizes.md),
        title: 'Delete Account',
        middleText:
            'Are you sure you want to delete your account permanently? This action is not reversible and all your data will be removed permanently',
        confirm: ElevatedButton(
            onPressed: () async => deleteUserAccount(),
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                side: const BorderSide(color: Colors.red)),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: TSizes.lg),
              child: Text('Delete'),
            )),
        cancel: OutlinedButton(
            onPressed: () => Navigator.of(Get.overlayContext!).pop(),
            child: const Text('Cancel')));
  }

  /// [NUEVO]: Lógica para eliminar la cuenta. Identifica si el usuario entró con Google o Email.
  void deleteUserAccount() async {
    try {
      TFullScreenLoader.openLoadingDialog('Processing', TImages.docerAnimation);
      final auth = AuthenticationRepository.instance;
      final provider =
          auth.authUser!.providerData.map((e) => e.providerId).first;
      if (provider.isNotEmpty) {
        // Si entró con Google, pedimos que se vuelva a loguear con Google para confirmar identidad.
        if (provider == 'google.com') {
          await auth.signInWithGoogle();
          await auth.deleteAccount();
          TFullScreenLoader.stopLoading();
          Get.offAll(() => const LoginScreen());
          // Si entró con Email, lo enviamos al formulario de re-autenticación (password).
        } else if (provider == 'password') {
          TFullScreenLoader.stopLoading();
          Get.to(() => const ReAuthLoginForm());
        }
      }
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.warningSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }

  /// [NUEVO]: Finaliza el borrado para usuarios de Email y Password tras confirmar su clave.
  Future<void> reAuthenticateEmailAndPasswordUser() async {
    try {
      TFullScreenLoader.openLoadingDialog('Processing', TImages.docerAnimation);

      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      if (!reAuthFormkey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }
      // 1. Confirma que la clave ingresada sea correcta.
      await AuthenticationRepository.instance
          .reAuthenticateWithEmailAndPassword(
              verifyEmail.text.trim(), verifyPassword.text.trim());
      // 2. Borra los datos de Firestore y luego la cuenta de Authentication.
      await AuthenticationRepository.instance.deleteAccount();
      TFullScreenLoader.stopLoading();
      Get.offAll(() => const LoginScreen());
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.warningSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }

  uploadUserProfilePicture() async {
    try {
      // 1. Abrir la galería para seleccionar la imagen
      final image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
        maxHeight: 512,
        maxWidth: 512,
      );

      if (image != null) {
        // 2. Subir la imagen a ImgBB usando el repositorio
        // (Asumo que tienes: final userRepository = Get.put(UserRepository());)
        final imageUrl = await userRepository.uploadImage(image);

        // 3. Guardar la nueva URL en Firebase
        Map<String, dynamic> json = {'ProfilePicture': imageUrl};
        await userRepository.updateSingleField(json);

        // 4. Actualizar el modelo local para que la UI cambie al instante
        user.value.profilePicture = imageUrl;
        user.refresh(); // Muy importante para que el Obx de la pantalla reaccione

        // 5. Mostrar mensaje de éxito
        TLoaders.successSnackBar(
            title: '¡Logrado!',
            message: 'Tu foto de perfil se ha actualizado.');
      }
    } catch (e) {
      // Si algo falla, mostramos el error
      TLoaders.errorSnackBar(title: 'Algo salió mal', message: e.toString());
    }
  }
}
