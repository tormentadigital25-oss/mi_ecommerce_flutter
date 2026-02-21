import 'package:flutter/material.dart';
import 'package:flutter_application_1/common/styles/spacing_styles.dart';
import 'package:flutter_application_1/utils/constants/sizes.dart';
import 'package:flutter_application_1/utils/constants/text_strings.dart';
import 'package:flutter_application_1/utils/helpers/helpers_functions.dart';
import 'package:lottie/lottie.dart';





class SuccessScreen extends StatelessWidget {
  const SuccessScreen({
    super.key,
    required this.image,
    required this.title,
    required this.subTitle,
    required this.onPressed,
  });

  final String image, title, subTitle;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: TSpacingStyle.paddingWithAppBarHeight * 2,
          child: Column(
            children: [
              image.endsWith('.json')
              ? Lottie.asset(image, width: THelperFunctions.screenWidth() * 0.6) // Si es true, usa Lottie
              : Image(image: AssetImage(image), width: THelperFunctions.screenWidth() * 0.6), // Si es false, usa Image normal
              const SizedBox(height: TSizes.spaceBtwSections),
              //Title and Subtitle
              Text(
                title,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              Text(
                subTitle,
                style: Theme.of(context).textTheme.labelMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              //Buttons
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onPressed,
                  child: const Text(TTexts.Continue),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
