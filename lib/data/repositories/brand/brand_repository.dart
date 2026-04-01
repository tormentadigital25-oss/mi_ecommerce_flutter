import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/features/shop/models/brand_model.dart';
import 'package:flutter_application_1/utils/exceptions/format_exceptions.dart';
import 'package:get/get.dart';

class BrandRepository extends GetxService {
  // Cambiamos de GetxController a GetxService
  static BrandRepository get instance => Get.find();
  final _db = FirebaseFirestore.instance;

  Future<List<BrandModel>> getAllBrands() async {
    try {
      final snapshot = await _db
          .collection('Brands')
          .get()
          .timeout(const Duration(seconds: 10));
      final result =
          snapshot.docs.map((e) => BrandModel.fromSnapshot(e)).toList();
      return result;
    } on FirebaseException catch (e) {
      throw e.message ?? 'Error de Firebase';
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw e.message ?? 'Error de plataforma';
    } catch (e) {
      throw 'Something went wrong while fetching banners';
    }
  }

  Future<List<BrandModel>> getBrandsForCategory(String categoryId) async {
    try {
      //Consulta para obtener todos los documentos donde la categoriaId coincide con la categoriaId provista
      QuerySnapshot brandCategoryQuery = await _db
          .collection('BrandCategory')
          .where('categoryId', isEqualTo: categoryId)
          .get();
      //Extrae brandIds desde los documentos
      List<String> brandIds = brandCategoryQuery.docs
          .map((doc) => doc['brandId'] as String)
          .toList();
      //Consulta para obtener todos los documentos donde brandId esté en la lista de brandIds
      final brandsQuery = await _db
          .collection('Brands')
          .where(FieldPath.documentId, whereIn: brandIds)
          .limit(2)
          .get();
      //Extrae nombres de marca u otra data relevante de los documentos
      List<BrandModel> brands =
          brandsQuery.docs.map((doc) => BrandModel.fromSnapshot(doc)).toList();

      return brands;
    } on FirebaseException catch (e) {
      throw e.message ?? 'Error de Firebase';
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw e.message ?? 'Error de plataforma';
    } catch (e) {
      throw 'Something went wrong while fetching banners';
    }
  }
}
  

  /*
  Future<List<BrandModel>> getAllBrands() async {
    try {
      final snapshot = await _db.collection('Brands')
          .get(const GetOptions(source: Source.server)); 
      return snapshot.docs.map((e) => BrandModel.fromSnapshot(e)).toList();
    } catch (e) {
      print("LOG CRÍTICO EN REPOSITORY: $e");
      return [];
    }
  } 
  */

