import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/data/services/imgbb_storage_service.dart';
import 'package:flutter_application_1/features/shop/models/category_model.dart';
import 'package:flutter_application_1/utils/exceptions/firebase_exceptions.dart';
import 'package:flutter_application_1/utils/exceptions/platform_exceptions.dart';
import 'package:get/get.dart';

class CategoryRepository extends GetxController {
  // Patrón Singleton: Permite acceder a este repositorio desde cualquier parte de la app
  // usando 'CategoryRepository.instance' sin tener que crear una copia nueva.
  static CategoryRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  /// --- OBTENER TODAS LAS CATEGORÍAS ---
  /// Esta función se conecta a Firebase y descarga la lista de categorías
  Future<List<CategoryModel>> getAllCategories() async {
    try {
      // 1. Conexión: Vamos a la colección llamada 'Categories' y pedimos todos los documentos (.get)
      final snapshot = await _db.collection('Categories').get();
      // 2. Transformación:
      // - .docs: Es la lista cruda de documentos de Firebase.
      // - .map: Recorre cada documento y usa el 'factory fromSnapshot' que creamos para
      //   convertir esos datos crudos en un objeto "CategoryModel" que Flutter entiende.
      // - .toList(): Convierte ese resultado en una Lista de Dart.
      final list = snapshot.docs
          .map((document) => CategoryModel.fromSnapshot(document))
          .toList();
      return list;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }
  // Sube las categorias a Firebase
  Future<void> uploadDummyData(List<CategoryModel> categories) async {
    try {
      final storage = Get.put(TImgBBStorageService());
      //Loop por cada categoria
      for (var category in categories) {
        //Obtiene ImageData link desde el local assets        
        final Uint8List file = await storage.getImageDataFromAssets(category.image);
        //Sube la imagen y obtiene su url
        final url = await storage.uploadImageData('Categories', file, category.name);
        category.image = url;
        await _db
            .collection("Categories")
            .doc(category.id)
            .set(category.toJson());
      }
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }
}
