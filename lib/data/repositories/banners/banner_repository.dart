import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/features/shop/models/banner_model.dart';
import 'package:flutter_application_1/utils/exceptions/format_exceptions.dart';
import 'package:get/get.dart';

class BannerRepository extends GetxController {
  static BannerRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;
  // Obtiene la lista de banners desde la colección de Firestore
  Future<List<BannerModel>> fetchBanners() async {
    try {
      final result = await _db
          .collection('Banners')
          .where('Active',// Filtro de servidor: solo trae lo que está activo
              isEqualTo:
                  true) 
          .get();
      // Convertimos cada documento de Firebase en un objeto BannerModel
      return result.docs
          .map((documentSnapshot) => BannerModel.fromSnapShot(documentSnapshot))
          .toList();
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
