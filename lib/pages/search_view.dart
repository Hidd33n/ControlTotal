import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class User {
  final String username;

  User({
    required this.username,
  });
}

class SearchView extends StatefulWidget {
  const SearchView({Key? key}) : super(key: key);

  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  TextEditingController _searchController = TextEditingController();
  String currentUserUsername = '';
  String currentUserUid = '';

  @override
  void initState() {
    super.initState();
    fetchCurrentUserUsername();
  }

  Future<void> fetchCurrentUserUsername() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null && mounted) {
      // La comprobación "mounted" está correcta
      currentUserUid =
          user.uid; // CAMBIO: Asignar el UID del usuario actual a la variable

      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserUid)
          .get();

      if (userSnapshot.exists) {
        currentUserUsername = userSnapshot['username'] ?? '';
        if (mounted) {
          setState(() {});
        }
      }
    }
  }

  void sendInvitation(String username) {
    FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: username)
        .get()
        .then((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot receiverDoc = querySnapshot.docs.first;
        String receiverDeviceToken = receiverDoc['deviceToken'];

        if (currentUserUid.isNotEmpty) {
          _sendNotificationToServer(receiverDeviceToken, 'Invitación',
              'Has recibido una invitación de $currentUserUsername');

          Fluttertoast.showToast(
            msg: 'Invitación enviada a $username',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            textColor: Colors.white,
          );
          FirebaseFirestore.instance
              .collection('users')
              .doc(receiverDoc.id)
              .collection('notifications')
              .add({
            'type': 'invitation',
            'from': currentUserUid,
            'to': receiverDoc.id,
            'titulo': 'Invitación recibida',
            'descripcion':
                'Has recibido una invitación de $currentUserUsername',
            'fecha': FieldValue.serverTimestamp(),
            'read': false,
          });
        } else {
          Fluttertoast.showToast(
            msg: 'error.v'.tr(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
        }
      } else {
        Fluttertoast.showToast(
          msg: 'error.u'.tr(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    });
  }

  Future<void> _sendNotificationToServer(
      String receiverUid, String title, String body) async {
    try {
      final userRef =
          FirebaseFirestore.instance.collection('users').doc(receiverUid);

      final userSnapshot = await userRef.get();

      if (userSnapshot.exists) {
        final deviceToken = userSnapshot['deviceToken'];

        if (deviceToken != null) {
          const url = 'http://154.56.51.64:3000/enviar-notificacion';

          final client = http
              .Client(); // Crea una instancia de IOClient para conexiones HTTPS

          final response = await client.post(
            Uri.parse(url),
            body: {
              'registrationToken': deviceToken,
              'title': title,
              'body': body,
            },
          );

          client.close(); // Cierra la conexión después de usarla

          if (response.statusCode == 200) {
          } else {}
        } else {}
      } else {}
    } catch (error) {}
  }

  Future<List<String>> fetchUserSuggestions(String pattern) async {
    if (pattern.isEmpty) return [];
    List<String> suggestions = [];

    // Realiza la consulta a Firestore usando solo 'pattern'.
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        // ... tus condiciones de consulta ...
        .get();

    // Agrega nombres de usuario a 'suggestions'
    for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
      suggestions.add(docSnapshot['username']);
    }

    return suggestions;
  }

  Future<String?> getUidFromUsername(String username) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: username)
        .limit(1) // Limitar la consulta a un solo resultado
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      String uid = querySnapshot.docs[0].id;
      return uid;
    } else {
      return null; // No se encontró el usuario con el username dado
    }
  }

  void removeFriend(String username) async {
    try {
      String currentUserUid = FirebaseAuth.instance.currentUser!.uid;
      String? friendUid = await getUidFromUsername(username);

      if (friendUid != null) {
        // Eliminar al amigo de la subcolección "friends" del usuario actual
        await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUserUid)
            .collection('friends')
            .where('username', isEqualTo: username)
            .get()
            .then((snapshot) {
          for (var doc in snapshot.docs) {
            doc.reference.delete();
          }
        });

        // Eliminar al usuario actual de la subcolección "friends" del amigo
        await FirebaseFirestore.instance
            .collection('users')
            .doc(friendUid)
            .collection('friends')
            .where('username', isEqualTo: currentUserUsername)
            .get()
            .then((snapshot) {
          for (var doc in snapshot.docs) {
            doc.reference.delete();
          }
        });

        // Mostrar un mensaje emergente (toast) indicando que el amigo ha sido eliminado
        Fluttertoast.showToast(
          msg: 'send.i'.tr(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
        );
      } else {
        // Manejar el caso en que no se encuentre el UID del amigo
        Fluttertoast.showToast(
          msg: 'send.ei'.tr(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      print('Error al eliminar amigo: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(
                top: 40.0, left: 16.0, right: 16.0, bottom: 16.0),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TypeAheadField(
                    textFieldConfiguration: TextFieldConfiguration(
                      controller: _searchController,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        hintText: 'search user'.tr(),
                        hintStyle: TextStyle(color: Colors.black, fontSize: 14),
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    suggestionsCallback: fetchUserSuggestions,
                    itemBuilder: (context, suggestion) {
                      return ListTile(title: Text(suggestion));
                    },
                    noItemsFoundBuilder: (context) {
                      return ListTile(title: Text('search.em'.tr()));
                    },
                    onSuggestionSelected: (suggestion) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('send.bu'.tr()),
                            content: Text(
                                '¿Quieres enviar una invitación a $suggestion?'),
                            actions: <Widget>[
                              TextButton(
                                child: Text('cancel.bu'.tr()),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: Text('accept.bu'.tr()),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  sendInvitation(suggestion);
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 100),
          Center(
              child: Text(
            'team member'.tr(),
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          )),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .collection('friends')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }

              if (snapshot.hasError) {
                return Text(
                  'error.team'.tr(),
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                );
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Text(
                  'empty.team'.tr(),
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                );
              }

              List<String> friendUsernames = snapshot.data!.docs
                  .map((doc) => doc.data() as Map<String, dynamic>)
                  .where((data) => data.containsKey('username'))
                  .map((data) => data['username'].toString())
                  .toList();

              return Column(
                children: friendUsernames.map((username) {
                  return Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding:
                              EdgeInsets.only(left: 20.0), // Adjust as needed
                          child: Text(
                            username,
                            style: GoogleFonts.oswald(
                                fontSize: 18.0), // Use Google Font Oswald
                          ),
                        ),
                      ),
                      TextButton(
                        // Replace IconButton with TextButton
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('delete.t'.tr()),
                                content: Text(
                                    '¿Estás seguro de que deseas eliminar a $username de tus amigos?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(
                                          context); // Close the dialog
                                    },
                                    child: Text('cancel.bu'.tr()),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(
                                          context); // Close the dialog
                                      removeFriend(
                                          username); // Call the function to remove the friend
                                    },
                                    child: Text('accept.bu'.tr(),
                                        style: TextStyle(
                                            color:
                                                Colors.blue)), // Set text color
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Text('delete'.tr(),
                            style: TextStyle(color: Colors.blue)),
                      ),
                    ],
                  );
                }).toList(),
              );
            },
          ),
          // Resto de tu contenido
        ],
      ),
    );
  }
}
