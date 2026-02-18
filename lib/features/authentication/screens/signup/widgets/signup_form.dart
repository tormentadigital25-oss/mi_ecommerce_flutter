import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/authentication/controllers/signup/signup_controller.dart';
import 'package:flutter_application_1/utils/validators/validation.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_application_1/features/authentication/screens/signup/verify_email.dart';
import 'package:flutter_application_1/features/authentication/screens/signup/widgets/terms_conditions_checkbox.dart';
import 'package:flutter_application_1/utils/constants/sizes.dart';
import 'package:flutter_application_1/utils/constants/text_strings.dart';

class TSignupForm extends StatelessWidget {
  const TSignupForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignupController());    
    return Form(
      key: controller.signupFormKey, //llave creada en el controlador de signup
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller.firstName,
                  validator: (value) => TValidator.validateEmptyText('First name', value),
                  expands: false,
                  decoration: const InputDecoration(
                    labelText: TTexts.firstName,
                    prefixIcon: Icon(Iconsax.user),
                  ),
                ),
              ),
              const SizedBox(width: TSizes.spaceBtwInputFields),
              Expanded(
                child: TextFormField(
                  controller: controller.lastName,
                  validator: (value) => TValidator.validateEmptyText('Last name', value),
                  expands: false,
                  decoration: const InputDecoration(
                    labelText: TTexts.lastName,
                    prefixIcon: Icon(Iconsax.user),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),
          //Username
          TextFormField(
            controller: controller.userName,
            validator: (value) => TValidator.validateEmptyText('username', value),
            expands: false,
            decoration: const InputDecoration(
              labelText: TTexts.username,
              prefixIcon: Icon(Iconsax.user_edit),
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),
          //Email
          TextFormField(
            controller: controller.email,
            validator: (value) => TValidator.validateEmail(value),
            decoration: const InputDecoration(
              labelText: TTexts.email,
              prefixIcon: Icon(Iconsax.direct),
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),
          //Email
          TextFormField(
            controller: controller.phoneNumber,
            validator: (value) => TValidator.validatePhoneNumber(value),
            expands: false,
            decoration: const InputDecoration(
              labelText: TTexts.phoneNumber,
              prefixIcon: Icon(Iconsax.call),
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),
          TextFormField(
            controller: controller.password,
            validator: (value) => TValidator.validatePassword(value),
            obscureText: true,
            decoration: const InputDecoration(
              labelText: TTexts.password,
              prefixIcon: Icon(Iconsax.password_check),
              suffixIcon: Icon(Iconsax.eye_slash),
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwSections),

          //Terms and conditions checkbox
          const TTermsAndConditionCheckbox(),
          const SizedBox(height: TSizes.spaceBtwSections),
          //Sign Up Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Get.to(
                () => const VerifyEmailScreen(),
              ), //Get.to permite poder regresar con la informacion guardada para no perder el registro del usuario
              child: const Text(TTexts.createAccount),
            ),
          ),
        ],
      ),
    );
  }
}
