import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../personalization/models/user_model.dart';
import '../../../utils/exceptions/firebase_exceptions.dart';
import '../../../utils/exceptions/format_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';


class UserRepository extends GetxController {
  // Permite acceder a las funciones del repositorio desde cualquier parte de la app sin crear nuevas instancias
  static UserRepository get instance => Get.find();

  // Instancias para conectar con la base de datos (Firestore) y el almacenamiento de archivos (Storage)
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final _firebaseStorage = FirebaseStorage.instance;

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

 
}