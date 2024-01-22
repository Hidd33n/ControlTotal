import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class Slider2 extends StatefulWidget {
  const Slider2({Key? key}) : super(key: key);

  @override
  State<Slider2> createState() => _Slider2State();
}

class _Slider2State extends State<Slider2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 40),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  Icon(
                    Icons.attach_money,
                    size: 60,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  const SizedBox(height: 20),

                  // Primera frase
                  Text(
                    'adjust'.tr(),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontSize: 20.0,
                        ),
                  ),
                  const SizedBox(height: 10),

                  // Segunda frase
                  Text(
                    'slidersub2'.tr(),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),

                  // Imagen centrada
                  Center(
                    child: Image.asset(
                      'assets/images/slider_img_2.png', // Reemplaza con la ruta de tu imagen
                      width: 350, // Ajusta el ancho según tus necesidades
                      height: 350, // Ajusta la altura según tus necesidades
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
