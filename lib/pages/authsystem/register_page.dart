import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:calcu/assets/widgets/custombuttons.dart';
import 'package:calcu/assets/widgets/customtextinput.dart';
import 'package:calcu/pages/authsystem/register_service.dart';

import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

class RegisterPage extends StatefulWidget {
  final VoidCallback showLoginPage;
  const RegisterPage({Key? key, required this.showLoginPage});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //text controller
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _cmpasswordController = TextEditingController();
  final _usernameController = TextEditingController();
  //firebase registo
  final RegisterService _registerService = RegisterService();
  void signUp(BuildContext context) {
    _registerService.signUp(
      context,
      _usernameController,
      _emailController,
      _passwordController,
      _cmpasswordController,
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _cmpasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.only(top: 40),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //logo
                const Icon(
                  Icons.library_books_rounded,
                  size: 100,
                  color: Colors.teal,
                ),
                const SizedBox(height: 20),

                //Primera frase
                Text('apptitle'.tr(),
                    style: GoogleFonts.poppins(
                        fontSize: 30,
                        textStyle: const TextStyle(color: Colors.white))),
                const SizedBox(
                  height: 10,
                ),
                TyperAnimatedTextKit(
                  isRepeatingAnimation: false,
                  speed: const Duration(milliseconds: 60),
                  text: ['appsubtitle'.tr().toUpperCase()],
                  textStyle: const TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      fontSize: 10,
                      color: Colors.white
                      // color: Color.fromARGB(255, 91, 91, 91)),
                      ),
                ),
                const SizedBox(height: 50),
                //username textfield
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: CustomTextField(
                      controller: _usernameController,
                      hintText: 'Username',
                      icon: Icons.supervised_user_circle,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                //email textfield
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: CustomTextField(
                      controller: _emailController,
                      hintText: 'Email',
                      icon: Icons.mail_lock,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                //pw textfield
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: CustomTextField(
                      controller: _passwordController,
                      hintText: 'Password',
                      icon: Icons.password,
                      obscureText: true,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                //cmpw textfield
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: CustomTextField(
                      controller: _cmpasswordController,
                      hintText: 'Confirm Password',
                      icon: Icons.password,
                      obscureText: true,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                //boton de inicio sesion
                CustomButton(
                  onPressed: () => signUp(context),
                  buttonText: 'register'.tr(),
                ),
                const SizedBox(
                  height: 10,
                ),
                //registro
                SingleChildScrollView(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: widget.showLoginPage,
                        child: Text(
                          'signin'.tr(),
                          style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                  fontFamily: 'poppins',
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      )),
    );
  }
}
