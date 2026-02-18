import 'package:flutter/material.dart';
import 'package:flutter_application_1/common/widgets/login_signup/form_divider.dart';
import 'package:flutter_application_1/common/widgets/login_signup/social_buttons.dart';
import 'package:flutter_application_1/features/authentication/screens/login/widgets/login_form.dart';
import 'package:flutter_application_1/features/authentication/screens/login/widgets/login_header.dart';
import 'package:flutter_application_1/utils/constants/sizes.dart';
import 'package:flutter_application_1/utils/constants/text_strings.dart';
import 'package:get/get_utils/src/extensions/string_extensions.dart';
import 'package:flutter_application_1/common/styles/spacing_styles.dart';




class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: TSpacingStyle.paddingWithAppBarHeight,
          child: Column(
            children: [
              //Logo, title and subtitle
              const TLoginHeader(),
              const TLoginForm(),
              //Divider
              TFormDivider(dividerText: TTexts.orSignInWith.capitalize!),
              const SizedBox(height: TSizes.spaceBtwSections),
              //Footer
              const TSocialButtons(),
            ],
          ),
        ),
      ),
    );
  }
}
