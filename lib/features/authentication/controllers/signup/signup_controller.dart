


import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupController extends GetxController{
  static SignupController get instance => Get.find();

  final email = TextEditingController();
  final lastName = TextEditingController();
  final userName = TextEditingController();
  final password = TextEditingController();
  final firstName = TextEditingController();
  final phoneNumber = TextEditingController();
  GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();


  Future <void> signup() async{
    try{

    }catch(e){

    }finally{
      
    }
  }

}