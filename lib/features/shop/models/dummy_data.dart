import 'package:flutter_application_1/features/shop/models/category_model.dart';
import 'package:flutter_application_1/utils/constants/image_strings.dart';

class TDummyData{

  static final List<CategoryModel> categories =[
    CategoryModel(id: '1', name: 'Sports', image: TImages.sportIcon, isFeatured: true),
    CategoryModel(id: '2', name: 'Electronics', image: TImages.electronicsIcon, isFeatured: true),
    CategoryModel(id: '3', name: 'Clothes', image: TImages.clothIcon, isFeatured: true),
    CategoryModel(id: '4', name: 'Animal', image: TImages.animalIcon, isFeatured: true),
    CategoryModel(id: '5', name: 'Furniture', image: TImages.furnitureIcon, isFeatured: true),
    CategoryModel(id: '6', name: 'Shoes', image: TImages.shoeIcon, isFeatured: true),
    CategoryModel(id: '7', name: 'Cosmetics', image: TImages.cosmeticsIcon, isFeatured: true),

    CategoryModel(id: '8', name: 'Sport Shoes', image: TImages.sportIcon,parentId: '1', isFeatured: false),
    CategoryModel(id: '9', name: 'Track Suites', image: TImages.sportIcon,parentId: '1', isFeatured: false),
    CategoryModel(id: '10', name: 'Sports Equipments', image: TImages.sportIcon,parentId: '1', isFeatured: false),

    CategoryModel(id: '11', name: 'Bedroom furniture', image: TImages.furnitureIcon,parentId: '5', isFeatured: false),
    CategoryModel(id: '12', name: 'Kitchen furniture', image: TImages.furnitureIcon,parentId: '5', isFeatured: false),
    CategoryModel(id: '13', name: 'Office furniture', image: TImages.furnitureIcon,parentId: '5', isFeatured: false),

    CategoryModel(id: '14', name: 'Laptops', image: TImages.electronicsIcon,parentId: '2', isFeatured: false),
    CategoryModel(id: '15', name: 'Mobile', image: TImages.electronicsIcon,parentId: '2', isFeatured: false),

    CategoryModel(id: '16',image: TImages.clothIcon,name: 'Shirts',parentId: '3',isFeatured: false),
  
  ];
  

}

