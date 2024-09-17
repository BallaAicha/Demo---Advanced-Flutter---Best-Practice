import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:testeur/presentation/ressources/strings_manager.dart';
import '../../ressources/assets_manager.dart';
import '../../ressources/colors_manager.dart';
import '../../ressources/value_manager.dart';
import '../viewmodel/login_view_model.dart';


final TextEditingController _userNameController = TextEditingController();
final TextEditingController _passwordController = TextEditingController();

Widget getContentWidget(BuildContext context, LoginViewModel loginViewModel) {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  return Container(
    padding: const EdgeInsets.only(top: AppPadding.p100),
    child: SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const Image(image: AssetImage(ImageAssets.Logo2)),
            const SizedBox(height: AppSize.s28),
            Padding(
              padding: const EdgeInsets.only(left: AppPadding.p28, right: AppPadding.p28),
              child: TextFormField(
                style: const TextStyle(color: Colors.white), // Text color
                keyboardType: TextInputType.emailAddress,
                controller: _userNameController,
                decoration: const InputDecoration(
                  hintText: 'Username',
                  labelText: 'Username',
                  labelStyle: TextStyle(color: Colors.white), // Label color
                  hintStyle: TextStyle(color: Colors.white), // Hint color
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your username';
                  }
                  return null;
                },
                onChanged: (value) {
                  loginViewModel.validateForm(_userNameController.text, _passwordController.text);
                },
              ),
            ),
            const SizedBox(height: AppSize.s28),
            Padding(
              padding: const EdgeInsets.only(left: AppPadding.p28, right: AppPadding.p28),
              child: TextFormField(
                keyboardType: TextInputType.visiblePassword,
                style: const TextStyle(color: Colors.white), // Text color
                controller: _passwordController,
                decoration: const InputDecoration(
                  hintText: 'Password',
                  labelText: 'Password',
                  labelStyle: TextStyle(color: Colors.white), // Label color
                  hintStyle: TextStyle(color: Colors.white), // Hint color
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                 return 'Please enter your password';
                  }
                  return null;
                },
                onChanged: (value) {
                  loginViewModel.validateForm(_userNameController.text, _passwordController.text);
                },
              ),
            ),
            const SizedBox(height: AppSize.s28),
            Padding(
              padding: const EdgeInsets.only(left: AppPadding.p28, right: AppPadding.p28),
              child: SizedBox(
                width: double.infinity,//pour que le bouton prenne toute la largeur
                height: AppSize.s40,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {//si le formulaire est valide ou non
                      loginViewModel.login(
                        _userNameController.text,
                        _passwordController.text,
                      );
                    } else {
                      loginViewModel.validateForm(
                        _userNameController.text,
                        _passwordController.text,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorManager.white
                  ),
                  child: const Text(AppStrings.login),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: AppPadding.p8, left: AppPadding.p28, right: AppPadding.p28),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: Text(

                     AppStrings.forgetPassword,
                      style: TextStyle(color: ColorManager.white),
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      AppStrings.registerText,
                      style: TextStyle(color: ColorManager.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}