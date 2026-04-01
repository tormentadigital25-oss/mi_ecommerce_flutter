import 'package:flutter/material.dart';
import 'package:flutter_application_1/common/widgets/appbar/appbar.dart';
import 'package:flutter_application_1/common/widgets/appbar/tabbar.dart';
import 'package:flutter_application_1/common/widgets/brands/brand_card.dart';
import 'package:flutter_application_1/common/widgets/custom_shapes/containers/search_container.dart';
import 'package:flutter_application_1/common/widgets/layouts/grid_layout.dart';
import 'package:flutter_application_1/common/widgets/products/cart/cart_menu_icon.dart';
import 'package:flutter_application_1/common/widgets/shimmers/brands_shimmer.dart';
import 'package:flutter_application_1/common/widgets/texts/section_heading.dart';
import 'package:flutter_application_1/features/shop/controllers/category_controller.dart';
import 'package:flutter_application_1/features/shop/controllers/product/brand_controller.dart';
import 'package:flutter_application_1/features/shop/screens/brands/all_brands.dart';
import 'package:flutter_application_1/features/shop/screens/brands/brand_products.dart';
import 'package:flutter_application_1/features/shop/screens/store/widgets/category_tab.dart';
import 'package:flutter_application_1/utils/constants/colors.dart';
import 'package:flutter_application_1/utils/constants/sizes.dart';
import 'package:flutter_application_1/utils/helpers/helpers_functions.dart';
import 'package:get/get.dart';

class StoreScreen extends StatelessWidget {
  const StoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Usamos Get.put para asegurar que existan, independientemente del Binding global
    final brandController = Get.put(BrandController());
    final categoryController = Get.put(CategoryController());

    return Obx(() {
      final categories = categoryController.featuredCategories;

      // Pantalla de carga mientras la lista está vacía
      if (categories.isEmpty) {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }

      return DefaultTabController(
        length: categories.length,
        child: Scaffold(
          appBar: TAppBar(
            title: Text('Store',
                style: Theme.of(context).textTheme.headlineMedium),
            actions: [TCartCounterIcon(onPressed: () {})],
          ),
          body: NestedScrollView(
            headerSliverBuilder: (_, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  pinned: true,
                  floating: true,
                  backgroundColor: THelperFunctions.isDarkMode(context)
                      ? TColors.black
                      : TColors.white,
                  expandedHeight: 440,
                  flexibleSpace: Padding(
                    padding: const EdgeInsets.all(TSizes.defaultSpace),
                    child: ListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        const SizedBox(height: TSizes.spaceBtwItems),
                        const TSearchContainer(
                          text: 'Search in Store',
                          showBorder: true,
                          showBackground: false,
                          padding: EdgeInsets.zero,
                        ),
                        const SizedBox(height: TSizes.spaceBtwSections),
                        TSectionHeading(
                          title: 'Featured Brands',
                          onPressed: () =>
                              Get.to(() => const AllBrandsScreen()),
                        ),
                        const SizedBox(height: TSizes.spaceBtwItems / 1.5),
                        // Aquí usamos el controlador de forma segura
                        Obx(() {
                          if (brandController.isLoading.value) {
                            return const TBrandsShimmer();
                          }
                          if (brandController.featuredBrands.isEmpty) {
                            return Center(
                                child: Text('No Data Found',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .apply(color: Colors.white)));
                          }
                          return TGridLayout(
                            itemCount: brandController.featuredBrands.length,
                            mainAxisExtent: 80,
                            itemBuilder: (_, index) {
                              final brand =
                                  brandController.featuredBrands[index];
                              return TBrandCard(
                                showBorder: true,
                                brand: brand,
                                onTap: () =>
                                    Get.to(() => BrandProducts(brand: brand)),
                              );
                            },
                          );
                        }),
                      ],
                    ),
                  ),
                  bottom: TTabBar(
                      tabs: categories
                          .map((c) => Tab(child: Text(c.name)))
                          .toList()),
                ),
              ];
            },
            body: TabBarView(
                children:
                    categories.map((c) => TCategoryTab(category: c)).toList()),
          ),
        ),
      );
    });
  }
}
