import 'package:calcu/pages/ui/nav.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';


class RegisterPage extends StatefulWidget {
  final VoidCallback showLoginPage;
  const RegisterPage({Key? key, required this.showLoginPage });

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
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

Future<void> signUp() async {
  if (!passwordConfirmed()) {
    Fluttertoast.showToast(msg: 'Las contraseñas no coinciden');
    return;
  }

  if (_usernameController.text.trim().isEmpty ||
      _emailController.text.trim().isEmpty ||
      _passwordController.text.trim().isEmpty ||
      _cmpasswordController.text.trim().isEmpty) {
    Fluttertoast.showToast(msg: 'Todos los campos son obligatorios');
    return;
  }

  // Verificar si el nombre de usuario ya está en uso
  QuerySnapshot querySnapshot = await _firestore.collection('users')
      .where('username', isEqualTo: _usernameController.text)
      .get();

  if (querySnapshot.docs.isNotEmpty) {
    Fluttertoast.showToast(msg: 'El nombre de usuario ya está en uso');
    return;
  }

  try {
    // Obtener el token de dispositivo
    String? deviceToken = await FirebaseMessaging.instance.getToken();

    // Registrar al usuario en Firebase Authentication
    UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: _emailController.text.trim(), 
      password: _passwordController.text.trim());

    // Guardar datos en Firestore
    await _firestore.collection('users').doc(userCredential.user!.uid).set({
      'username': _usernameController.text,
      'deviceToken': deviceToken,  // Guardar el token del dispositivo
      // Otros datos de usuario...
    });

    Fluttertoast.showToast(msg: 'Usuario registrado exitosamente');

    // Navegar a la nueva página después del registro exitoso
    Navigator.push(context, MaterialPageRoute(builder: (context) => NavigationScreen()));
  } catch (e) {
    // Handle registration error
    Fluttertoast.showToast(msg: 'Error durante el registro');
    print('Error durante el registro: $e');
  }
}





//confirmar contraseña
 bool passwordConfirmed() {
  if (_passwordController.text.trim() == _cmpasswordController.text.trim()) {
    return true;
  } else {
    return false;
  }
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
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
        child: SingleChildScrollView(
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
                'Registro',
                style: GoogleFonts.bebasNeue(
                  fontSize: 52,
                )
              ),
              SizedBox(height: 10,),
              Text(
                'No te pierdas nada',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 50),
        //username textfield
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.deepPurple),
                        borderRadius: BorderRadius.circular(12)
                      ),
                      hintText: 'Username',
                      fillColor: Colors.grey[200],
                      filled: true,
                    ),
                  ),
                  ),
              ),
                SizedBox(height: 10),
              //email textfield
              SingleChildScrollView(
                child: Padding(
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
              ),
                SizedBox(height: 10),
              //pw textfield
              SingleChildScrollView(
                child: Padding(
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
              ),
          SizedBox(height: 10),
              //cmpw textfield
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: TextField(
                    obscureText: true,
                    controller: _cmpasswordController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.deepPurple),
                        borderRadius: BorderRadius.circular(12)
                      ),
                      hintText: 'Confirm Password',
                      fillColor: Colors.grey[200],
                      filled: true,
                    ),
                  ),
                  ),
              ),
                SizedBox(height: 10,),
                //boton de inicio sesion
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: GestureDetector(
                    onTap: signUp,
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          'Registrar',
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
              ),
                SizedBox(height: 10,),
                //registro
              SingleChildScrollView(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Ya estas registrado?',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: widget.showLoginPage,
                      child: Text('  Logearme',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                      ),
                    ),
                  ],
                ),
              )
        
            ],
          ),
        ),
      )),
    );
  }
}