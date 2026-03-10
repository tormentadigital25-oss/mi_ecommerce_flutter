import 'package:flutter_application_1/features/shop/controllers/product/images_controller.dart';
import 'package:flutter_application_1/features/shop/models/product_model.dart';
import 'package:flutter_application_1/features/shop/models/product_variation_model.dart';
import 'package:get/get.dart';

class VariationController extends GetxController {
  static VariationController get instance => Get.find();

  RxMap selectedAttributes = {}.obs;
  RxString variationStockStatus = ''.obs;
  Rx<ProductVariationModel> selectedVariation =
      ProductVariationModel.empty().obs;

  /// Se ejecuta cuando el usuario hace clic en un atributo (Ej: Color -> Azul)
  void onAttributeSelected(
      ProductModel product, attributeName, attributeValue) {
  // 1. Creamos una copia local de los atributos seleccionados para comparar
    final selectedAttributes =
        Map<String, dynamic>.from(this.selectedAttributes);
    selectedAttributes[attributeName] = attributeValue;
    // 2. Actualizamos el mapa observable que usa la UI para resaltar los botones
    this.selectedAttributes[attributeName] = attributeValue;
    // 3. Buscamos en la lista de variaciones del producto una que coincida con TODOS los atributos elegidos
    final selectedVariation = product.productVariations!.firstWhere(
        (variation) => _isSameAttributeValues(
            variation.attributeValues, selectedAttributes),
        orElse: () => ProductVariationModel.empty());
    // 4. Si la variante encontrada tiene imagen, actualizamos el slider principal automáticamente
    if (selectedVariation.image.isNotEmpty) {
      print("DEBUG: Intentando cargar imagen de variante: '${selectedVariation.image}'");
      ImagesController.instance.selectedProductImage.value =
          selectedVariation.image;
    }
    // 5. Asignamos la variante encontrada a nuestra variable observable principal
    this.selectedVariation.value = selectedVariation;
    // 6. Actualizamos el texto de disponibilidad (In Stock / Out of Stock)
    getproductVariationStockStatus();
  }

  /// Compara si los atributos de una variante coinciden exactamente con la selección del usuario
  bool _isSameAttributeValues(Map<String, dynamic> variationAttributes,
      Map<String, dynamic> selectedAttributes) {
    // Si no tienen la misma cantidad de atributos (ej. falta elegir la talla), no hay coincidencia
    if (variationAttributes.length != selectedAttributes.length) return false;
    // Recorremos las llaves (Color, Talla, etc.) para verificar que los valores sean idénticos
    for (final key in variationAttributes.keys) {
      
      if (variationAttributes[key] != selectedAttributes[key]) return false;
    }
    return true;
  }
  /// Filtra y devuelve qué valores de un atributo (ej: qué tallas) tienen stock real disponible
  Set<String?> getAttributeAvailabilityInVariation(
      List<ProductVariationModel> variations, String attributeName) {
    final availableVariationAttributeValues = variations
        .where((variation) =>
        // Verificamos que el atributo exista en la variante, no esté vacío y tenga stock > 0
            variation.attributeValues[attributeName] != null &&
            variation.attributeValues[attributeName]!.isNotEmpty &&
            variation.stock > 0)
            // Mapeamos solo el valor del atributo (ej: "XL")
        .map((variation) => variation.attributeValues[attributeName])
        .toSet();// El Set elimina automáticamente los duplicados
    return availableVariationAttributeValues;
  }
/// Devuelve el precio actual (oferta o normal) de la variante seleccionada
  String getVariationPrice() {
    return (selectedVariation.value.salePrice > 0
            ? selectedVariation.value.salePrice
            : selectedVariation.value.price)
        .toString();
  }
/// Determina el texto a mostrar según el inventario de la variante elegida
  void getproductVariationStockStatus() {
    variationStockStatus.value =
        selectedVariation.value.stock > 0 ? 'In Stock' : 'Out of Stock';
  }
/// Limpia los filtros cuando el usuario sale de la pantalla o cambia de producto
  void resetSelectedAttribute() {
    selectedAttributes.clear();
    variationStockStatus.value = '';
    selectedVariation.value = ProductVariationModel.empty();
  }
}
