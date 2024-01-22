import 'package:flutter/material.dart';

class SliderButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonText;

  const SliderButton({
    required this.onPressed,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(
              horizontal: 20, vertical: 10), // Ajusta el tamaño del padding
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius:
                BorderRadius.circular(25), // Ajusta el radio de la esquina
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5), // Color de la sombra
                spreadRadius: 2, // Extensión de la sombra
                blurRadius: 5, // Desenfoque de la sombra
                offset: Offset(0, 3), // Posición de la sombra
              ),
            ],
          ),
          child: Center(
            child: Text(
              buttonText,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ),
      ),
    );
  }
}
