import 'dart:convert';
import 'package:flutter_application_1/utils/constants/api_constants.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/data/repositories/authentitation/authentication_repository.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../personalization/models/user_model.dart';
import '../../../utils/exceptions/firebase_exceptions.dart';
import '../../../utils/exceptions/format_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';

class UserRepository extends GetxController {
  // Permite acceder a las funciones del repositorio desde cualquier parte de la app sin crear nuevas instancias
  static UserRepository get instance => Get.find();

  // Instancias para conectar con la base de datos (Firestore) y el almacenamiento de archivos (Storage)
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  ///final _firebaseStorage = FirebaseStorage.instance;

  /// Función principal para guardar o actualizar los datos del usuario en la colección "Users" de Firestore.
  Future<void> saveUserRecord(UserModel user) async {
    try {
      await _db.collection("Users").doc(user.id).set(user.toJson());
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

  /// Toma los detalles del usuario basado en su id
  Future<UserModel> fetchUserDetails() async {
    try {
      final documentSnapshot = await _db
          .collection("Users")
          .doc(AuthenticationRepository.instance.authUser?.uid)
          .get();
      if (documentSnapshot.exists) {
        return UserModel.fromSnapshot(documentSnapshot);
      } else {
        return UserModel.empty();
      }
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

  //Función para actualizar data del usuario en Firestore
  Future<void> updateUserDetails(UserModel updatedUser) async {
    try {
      await _db
          .collection("Users")
          .doc(updatedUser.id)
          .update(updatedUser.toJson());
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

  /// [NUEVO]: Actualiza cualquier campo específico en la colección "Users".
  /// Se usa para cambios puntuales como el nombre sin tener que enviar todo el objeto de nuevo.
  Future<void> updateSingleField(Map<String, dynamic> json) async {
    try {
      await _db
          .collection("Users")
          .doc(AuthenticationRepository.instance.authUser?.uid)
          .update(json);
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

  /// [NUEVO]: Elimina físicamente el documento del usuario de Firestore usando su ID.
  Future<void> removeUserRecord(String userId) async {
    try {
      await _db.collection("Users").doc(userId).delete();
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

  /// Sube la imagen a ImgBB con manejo de excepciones profesional.
  Future<String> uploadImage(XFile image) async {
    try {
      // 1. Construimos la URL desde las constantes
      final url = Uri.parse(
          '${ApiConstants.imgBBBaseUrl}?key=${ApiConstants.imggBBApiKey}');

      // 2. Preparamos la petición
      var request = http.MultipartRequest('POST', url);
      var file = await http.MultipartFile.fromPath('image', image.path);
      request.files.add(file);

      // 3. Enviamos la petición
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      // 4. Verificamos el status code
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        return jsonResponse['data']['url'];
      } else {
        throw 'Error al subir la imagen: ${response.statusCode}';
      }
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      // Error genérico para cualquier otro fallo (como falta de internet)
      throw 'Something went wrong. Please try again';
    }
  }
}
