import 'dart:io';
import 'package:calcu/core/ui/themes/theme_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_icons/line_icon.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class MyDrawer extends StatefulWidget {
  final User? currentUser;
  final VoidCallback onFixTaxes;
  final Future<void> Function() onToggleLanguage;
  final VoidCallback onToggleTheme;
  final VoidCallback onLogout;

  const MyDrawer({
    super.key,
    required this.currentUser,
    required this.onFixTaxes,
    required this.onToggleLanguage,
    required this.onToggleTheme,
    required this.onLogout,
  });

  @override
  // ignore: library_private_types_in_public_api
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  late String displayName;
  late String email;
  late String imagePath;
  ImageProvider<Object>? profileImage;
  @override
  void initState() {
    super.initState();
    displayName = widget.currentUser?.displayName ?? 'N/A';
    email = widget.currentUser?.email ?? 'N/A';
    imagePath = ''; // Obtén la ruta de la imagen guardada en SharedPreferences
    _loadImagePath();
  }

  Future<void> _loadImagePath() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      imagePath = prefs.getString('userImage') ?? '';
    });
  }

  Future<void> _selectImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    final User? currentUser = FirebaseAuth.instance.currentUser;

    if (pickedFile != null) {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('userImage', pickedFile.path);

      setState(() {
        imagePath = pickedFile.path;
      });

      try {
        // Intenta subir la imagen a Firebase Storage y actualizar la URL en Firestore
        await uploadImageToFirebase(currentUser!.uid, pickedFile.path);
      } catch (e) {
        // Maneja el error aquí, por ejemplo, muestra un mensaje al usuario.

        // Guarda la nueva ruta de la imagen en SharedPreferences si la carga falla
        // para que puedas intentar cargarla nuevamente más tarde.
        prefs.setString('pendingUserImage', pickedFile.path);
      }

      // Descargar la imagen usando la URL almacenada en profileImageUrl
      if (currentUser != null) {
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .get();

        if (userSnapshot.exists) {
          String? profileImageUrl = userSnapshot['profileImageUrl'];

          if (profileImageUrl != null && profileImageUrl.isNotEmpty) {
            // Si hay una URL de imagen en Firestore, cargarla y mostrarla
            loadImageFromNetwork(profileImageUrl);
          }
        }
      }
    }
  }

  void loadImageFromNetwork(String imageUrl) {
    // Utiliza NetworkImage para cargar la imagen desde la URL de la red
    Image.network(imageUrl)
        .image
        .resolve(const ImageConfiguration())
        .addListener(
          ImageStreamListener(
            (info, synchronousCall) {
              // La imagen se ha cargado exitosamente, ahora puedes usarla
              // Por ejemplo, puedes mostrarla en un widget Image
              setState(() {
                // Actualiza el estado o la propiedad de la imagen en tu interfaz de usuario
                profileImage = Image.network(imageUrl).image;
              });
            },
            onError: (dynamic exception, StackTrace? stackTrace) {
              // Maneja errores de carga de la imagen si es necesari
            },
          ),
        );
  }

  Future<void> uploadImageToFirebase(String userId, String filePath) async {
    try {
      final File file = File(filePath);
      const String fileName = 'profile_image.jpg';

      final firebase_storage.Reference storageReference = firebase_storage
          .FirebaseStorage.instance
          .ref()
          .child('user_images')
          .child(userId)
          .child(fileName);

      final firebase_storage.UploadTask uploadTask =
          storageReference.putFile(file);

      await uploadTask.whenComplete(() async {
        final String downloadUrl = await storageReference.getDownloadURL();

        await FirebaseFirestore.instance.collection('users').doc(userId).set({
          'profileImageUrl': downloadUrl,
        }, SetOptions(merge: true));
      });
      // ignore: empty_catches
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                UserAccountsDrawerHeader(
                  accountName: Text(displayName),
                  accountEmail: Text(email),
                  currentAccountPicture: GestureDetector(
                    onTap: _selectImage,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      backgroundImage: imagePath.isNotEmpty
                          ? FileImage(File(imagePath))
                          : const AssetImage('assets/images/dprofile.png')
                              as ImageProvider<Object>,
                      child:
                          imagePath.isEmpty ? const Icon(Icons.camera) : null,
                    ),
                  ),
                ),
                ListTile(
                  leading: const LineIcon.userAlt(),
                  title: Text(
                    'cooming soon'.tr(),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  onTap: () {},
                ),
                ListTile(
                  leading: const LineIcon.moneyCheck(),
                  title: Text(
                    'fix taxs'.tr(),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  onTap: widget.onFixTaxes,
                ),
                ListTile(
                  leading: const LineIcon.language(),
                  title: Text(
                    context.locale.languageCode == 'en' ? 'es'.tr() : 'en'.tr(),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  onTap: () async => await widget.onToggleLanguage(),
                ),
                ListTile(
                  leading: const LineIcon.powerOff(),
                  title: Text(
                    'logout'.tr(),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  onTap: widget.onLogout,
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(
              ThemeManager.currentThemeMode == ThemeMode.light
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            title: Text(
              ThemeManager.currentThemeMode == ThemeMode.light
                  ? 'lighttheme'.tr()
                  : 'darktheme'.tr(),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            onTap: widget.onToggleTheme,
          ),
        ],
      ),
    );
  }
}
