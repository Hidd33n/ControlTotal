import 'package:calcu/assets/widgets/custombuttons.dart';
import 'package:calcu/assets/widgets/customtextinput.dart';
import 'package:calcu/assets/widgets/slogananimation.dart';
import 'package:calcu/pages/authsystem/login_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback showRegisterPage;

  const LoginPage({Key? key, required this.showRegisterPage}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //text controller
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late String email; // Cambiado el nombre de la variable para evitar conflictos

  void someFunction() {
    email = _emailController.text;
    // Resto del código...
  }

  final LoginService _loginService = LoginService();

  void signIn(BuildContext context) {
    _loginService.signIn(
      _emailController.text,
      _passwordController.text,
      context,
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
            child: Padding(
          padding: const EdgeInsets.only(top: 80),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //logo
                Icon(
                  Icons.library_books_rounded,
                  size: 100,
                  color: Theme.of(context).iconTheme.color,
                ),
                const SizedBox(height: 20),

                //Primera frase
                Text('apptitle'.tr(),
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(
                  height: 10,
                ),
                // ignore: deprecated_member_use
                SloganAnim(),
                const SizedBox(height: 50),

                //email textfield

                CustomTextField(
                  controller: _emailController,
                  hintText: 'Email',
                  icon: Icons.mail_lock,
                ),

                const SizedBox(height: 5),
                //pw textfield
                CustomTextField(
                  controller: _passwordController,
                  hintText: 'Password',
                  icon: Icons.password,
                  obscureText: true,
                ),

                const SizedBox(
                  height: 10,
                ),
                //boton de inicio sesion

                CustomButton(
                  onPressed: () => signIn(context),
                  buttonText: 'signin'.tr(),
                ),

                const SizedBox(
                  height: 10,
                ),
                //registro
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: widget.showRegisterPage,
                      child: Text(
                        'register?'.tr(),
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        )),
      ),
    );
  }
}
