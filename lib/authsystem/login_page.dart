import 'package:calcu/pages/ui/nav.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ionicons/ionicons.dart';

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

Future signIn() async {
  // Verifica si los campos están vacíos para evitar el inicio de sesión automático
  if (_emailController.text.trim().isEmpty || _passwordController.text.trim().isEmpty) {
    print('Los campos de correo electrónico y contraseña no pueden estar vacíos.');
    return;
  }

  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: _emailController.text.trim(), 
      password: _passwordController.text.trim(),
    );

    // Verificar si el widget sigue montado antes de realizar la navegación.
    if (!mounted) return;

    // Obtener el token de dispositivo actualizado
    String? deviceToken = await FirebaseMessaging.instance.getToken();

    // Actualizar el token en la base de datos si el usuario está autenticado
    if (FirebaseAuth.instance.currentUser != null) {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'deviceToken': deviceToken,
      });

      // Verificar de nuevo si el widget sigue montado antes de realizar la navegación.
      if (!mounted) return;

      // Navegar a la nueva página después de iniciar sesión
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NavigationScreen()));
    }
  } on FirebaseAuthException catch (e) {
    // Manejar el error de inicio de sesión específicamente
    print('Error durante el inicio de sesión: $e');
  } catch (e) {
    // Manejar otros posibles errores
    print('Error durante el inicio de sesión: $e');
  }
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
      backgroundColor: Colors.grey[300],
      body: SafeArea(child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //logo
            Icon(
              Ionicons.business_sharp,
              size: 100,
            ),
            SizedBox(height: 75),

            //Primera frase
            Text(
              'ControlTotal',
              style: GoogleFonts.bebasNeue(
                fontSize: 52,
              )
            ),
            SizedBox(height: 10,),
            Text(
              'Administrar tu negocio nunca fue tan facil',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            SizedBox(height: 50),

            //email textfield
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.deepPurple),
                    borderRadius: BorderRadius.circular(12)
                  ),
                  hintText: 'Email',
                  fillColor: Colors.grey[200],
                  filled: true,
                ),
              ),
              ),
              SizedBox(height: 10),
            //pw textfield
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: TextField(
                obscureText: true,
                controller: _passwordController,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.deepPurple),
                    borderRadius: BorderRadius.circular(12)
                  ),
                  hintText: 'Password',
                  fillColor: Colors.grey[200],
                  filled: true,
                ),
              ),
              ),

              SizedBox(height: 10,),
              //boton de inicio sesion
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: GestureDetector(
                onTap: signIn,
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      'Iniciar Sesion',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
              ),
              SizedBox(height: 10,),
              //registro
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'No estas registrado?',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  onTap: widget.showRegisterPage,
                  child: Text('  Registrar',
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                  ),
                ),
              ],
            )

          ],
        ),
      )),
    );
  }
}