import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/features/shop/models/brand_model.dart';
import 'package:flutter_application_1/features/shop/models/product_attribute_model.dart';
import 'package:flutter_application_1/features/shop/models/product_variation_model.dart';

/// Modelo de datos que representa un producto en la tienda.
/// Este modelo es la base para interactuar con Firestore.
class ProductModel {
  String id;
  int stock;
  String? sku;
  double price;
  String title;
  DateTime? date;
  double? salePrice;
  String thumbnail;
  bool? isFeatured;
  BrandModel? brand;
  String? description;
  String? categoryId;
  List<String>? images;
  String productType;
  List<ProductAttributeModel>? productAttributes;
  List<ProductVariationModel>? productVariations;

  ProductModel({
    required this.id,
    required this.title,
    required this.stock,
    required this.price,
    required this.thumbnail,
    required this.productType,
    this.sku,
    this.brand,
    this.date,
    this.images,
    this.salePrice,
    this.isFeatured,
    this.categoryId,
    this.description,
    this.productAttributes,
    this.productVariations,
  });

  /// Retorna un modelo vacío para evitar errores de null-safety en la UI.
  static ProductModel empty() => ProductModel(
      id: '', title: '', stock: 0, price: 0, thumbnail: '', productType: '');

  /// Convierte el objeto a JSON para subirlo a Firebase (Firestore).
  toJson() {
    return {
      'SKU': sku,
      'Title': title,
      'Stock': stock,
      'Price': price,
      'Images': images ?? [],
      'Thumbnail': thumbnail,
      'SalePrice': salePrice,
      'IsFeatured': isFeatured,
      'CategoryId': categoryId,
      'Brand': brand!.toJson(),
      'Description': description,
      'ProductType': productType,
      'ProductAttributes': productAttributes != null
          ? productAttributes!.map((e) => e.toJson()).toList()
          : [],
      'ProductVariations': productVariations != null
          ? productVariations!.map((e) => e.toJson()).toList()
          : []
    };
  }
  /// Factory: Convierte un DocumentSnapshot de Firebase en un objeto ProductModel.
  factory ProductModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() == null) return ProductModel.empty();

    final data = document.data()!;

    // Función auxiliar para obtener Map de forma segura
    Map<String, dynamic> getMap(dynamic value) {
      if (value is Map) return Map<String, dynamic>.from(value);
      return {}; // Retorna vacío si es nulo o no es mapa
    }

    return ProductModel(
      id: document.id,
      sku: data['SKU'] ?? '',
      title: data['Title'] ?? '',
      stock: data['Stock'] ?? 0,
      isFeatured: data['IsFeatured'] ?? false,
      price: double.parse((data['Price'] ?? 0.0).toString()),
      salePrice: double.parse((data['SalePrice'] ?? 0.0).toString()),
      thumbnail: data['Thumbnail'] ?? '',
      categoryId: data['CategoryId'] ?? '',
      description: data['Description'] ?? '',
      productType: data['ProductType'] ?? '',
      // Aquí está la protección real:
      brand: (data['Brand'] != null)
          ? BrandModel.fromJson(getMap(data['Brand']))
          : BrandModel.empty(),
      images: (data['Images'] is List) ? List<String>.from(data['Images']) : [],
      productAttributes: (data['ProductAttributes'] is List)
          ? (data['ProductAttributes'] as List)
              .map((e) => ProductAttributeModel.fromJson(getMap(e)))
              .toList()
          : [],
      productVariations: (data['ProductVariations'] is List)
          ? (data['ProductVariations'] as List)
              .map((e) => ProductVariationModel.fromJson(getMap(e)))
              .toList()
          : [],
    );
  }
/* 
  factory ProductModel.fromQuerySnapshot(QueryDocumentSnapshot<Object?> document){
    final data = document.data() as Map<String,dynamic>;
    return ProductModel(id: document.id,sku: data['SKU']??'',);
  }
  
*/
}
