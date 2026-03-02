import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../../../utils/constants/api_constants.dart';

class TImgBBStorageService extends GetxController {
  static TImgBBStorageService get instance => Get.find();

  // Cambiamos la instancia de Firebase por nuestra API Key
  final String _apiKey = ApiConstants.imggBBApiKey;

  /// --- FUNCIÓN 1: OBTENER DATOS DESDE ASSETS (IDÉNTICA AL CURSO) ---
  Future<Uint8List> getImageDataFromAssets(String path) async {
    try {
      final byteData = await rootBundle.load(path);
      // Corregido el typo de 'lengthInBYtes' a 'lengthInBytes'
      final imageData = byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes);
      return imageData;
    } catch (e) {
      throw 'Error loading image data: $e';
    }
  }

  /// --- FUNCIÓN 2: SUBIR DATOS (BYTES) A IMGBB (EQUIVALENTE A PUTDATA) ---
  /// Mantenemos 'path' para que el código del curso no de error, aunque ImgBB no use carpetas.
  Future<String> uploadImageData(String path, Uint8List image, String name) async {
    try {
      // Convertimos los bytes a Base64 para la API de ImgBB
      String base64Image = base64Encode(image);

      final response = await http.post(
        Uri.parse('https://api.imgbb.com/1/upload?key=$_apiKey'),
        body: {
          'image': base64Image,
          'name': name,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['data']['url']; // Retornamos la URL igual que 'getDownloadURL'
      } else {
        throw 'Error de ImgBB: ${response.reasonPhrase}';
      }
    } catch (e) {
      // Replicamos el manejo de excepciones del curso pero adaptado
      if (e is SocketException) {
        throw 'Network Error: ${e.message}';
      } else if (e is PlatformException) {
        throw 'Platform Exception: ${e.message}';
      } else {
        throw 'Something went wrong! Please try again.';
      }
    }
  }

  /// --- FUNCIÓN 3: SUBIR ARCHIVO (XFILE) A IMGBB (EQUIVALENTE A PUTFILE) ---
  Future<String> uploadImageFile(String path, XFile image) async {
    try {
      // Leemos los bytes del archivo XFile
      final Uint8List bytes = await image.readAsBytes();
      
      // Reutilizamos nuestra función de arriba para no repetir código
      return await uploadImageData(path, bytes, image.name);
      
    } catch (e) {
      throw 'Something went wrong! Please try again.';
    }
  }
}