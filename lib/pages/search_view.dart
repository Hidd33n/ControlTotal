import 'package:calcu/assets/functions/search_services.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchView extends StatefulWidget {
  const SearchView({Key? key}) : super(key: key);

  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController _searchController = TextEditingController();
  final SearchService _searchService = SearchService();
  String? currentUserUsername;

  @override
  void initState() {
    super.initState();
    fetchCurrentUserUsername;
  }

  Future<void> fetchCurrentUserUsername() async {
    final username = await _searchService.fetchCurrentUserUsername();

    if (username != null && mounted) {
      setState(() {
        currentUserUsername = username;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(
                top: 40.0,
                left: 16.0,
                right: 16.0,
                bottom: 16.0,
              ),
              color: Colors.black,
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0.0),
                      child: Container(
                        padding: const EdgeInsets.only(left: 10),
                        width: MediaQuery.of(context).size.width *
                            0.10, // Ajusta el ancho según tus necesidades
                        child: Row(
                          children: [
                            const Icon(
                              Icons.search,
                              color: Colors.white,
                            ),
                            const SizedBox(
                                width:
                                    5), // Espacio entre el icono y el campo de texto
                            Expanded(
                              child: TypeAheadField(
                                textFieldConfiguration: TextFieldConfiguration(
                                  controller: _searchController,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    hintText: 'search user'.tr(),
                                    hintStyle: GoogleFonts.poppins(
                                        textStyle: const TextStyle(
                                            fontFamily: 'poppins',
                                            fontWeight: FontWeight.w400),
                                        color: Colors.white),
                                    filled: true,
                                    fillColor: Colors.black,
                                    border: InputBorder.none,
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: const BorderSide(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                suggestionsCallback:
                                    _searchService.fetchUserSuggestions,
                                itemBuilder: (context, suggestion) {
                                  return ListTile(title: Text(suggestion));
                                },
                                noItemsFoundBuilder: (context) {
                                  return ListTile(
                                      title: Text(
                                    'search.em'.tr(),
                                    style: GoogleFonts.poppins(
                                        textStyle: const TextStyle(
                                            fontFamily: 'poppins',
                                            fontWeight: FontWeight.w400),
                                        color: Colors.white),
                                  ));
                                },
                                onSuggestionSelected: (suggestion) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text(
                                          'send.bu'.tr(),
                                          style: GoogleFonts.poppins(
                                              textStyle: const TextStyle(
                                                  fontFamily: 'poppins',
                                                  fontWeight: FontWeight.w400),
                                              color: Colors.white),
                                        ),
                                        content: Text(
                                          '¿Quieres enviar una invitación a $suggestion?',
                                          style: GoogleFonts.poppins(
                                              textStyle: const TextStyle(
                                                  fontFamily: 'poppins',
                                                  fontWeight: FontWeight.w400),
                                              color: Colors.white),
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            child: Text(
                                              'cancel.bu'.tr(),
                                              style: GoogleFonts.poppins(
                                                  textStyle: const TextStyle(
                                                      fontFamily: 'poppins',
                                                      fontWeight:
                                                          FontWeight.w400),
                                                  color: Colors.white),
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          TextButton(
                                            child: Text(
                                              'accept.bu'.tr(),
                                              style: GoogleFonts.poppins(
                                                  textStyle: const TextStyle(
                                                      fontFamily: 'poppins',
                                                      fontWeight:
                                                          FontWeight.w400),
                                                  color: Colors.white),
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              _searchService
                                                  .sendInvitation(suggestion);
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
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 100),
            Center(
                child: Text(
              'team member'.tr(),
              style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                      fontFamily: 'poppins', fontWeight: FontWeight.w400),
                  color: Colors.white),
            )),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .collection('friends')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                if (snapshot.hasError) {
                  return Text(
                    'error.team'.tr(),
                    style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                            fontFamily: 'poppins', fontWeight: FontWeight.w400),
                        color: Colors.white),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Container(
                    color: Colors.black,
                    child: Text(
                      'empty.team'.tr(),
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                            fontFamily: 'poppins', fontWeight: FontWeight.w400),
                        color: Colors.white,
                        backgroundColor: Colors.black,
                      ),
                    ),
                  );
                }

                List<String> friendUsernames = snapshot.data!.docs
                    .map((doc) => doc.data() as Map<String, dynamic>)
                    .where((data) => data.containsKey('username'))
                    .map((data) => data['username'].toString())
                    .toList();

                return Container(
                  color: Colors.black,
                  child: Column(
                    children: friendUsernames.map((username) {
                      return Row(
                        children: [
                          Expanded(
                            child: Container(
                              color: Colors.black,
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Text(
                                username,
                                style: GoogleFonts.oswald(fontSize: 18.0),
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(
                                      'delete'.tr(),
                                      style: GoogleFonts.poppins(
                                          textStyle: const TextStyle(
                                              fontFamily: 'poppins',
                                              fontWeight: FontWeight.w400),
                                          color: Colors.white),
                                    ),
                                    content: Text(
                                      '¿Estás seguro de que deseas eliminar a $username de tus amigos?',
                                      style: GoogleFonts.poppins(
                                          textStyle: const TextStyle(
                                              fontFamily: 'poppins',
                                              fontWeight: FontWeight.w400),
                                          color: Colors.white),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          'cancel.bu'.tr(),
                                          style: GoogleFonts.poppins(
                                              textStyle: const TextStyle(
                                                  fontFamily: 'poppins',
                                                  fontWeight: FontWeight.w400),
                                              color: Colors.white),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          _searchService.removeFriend(username);
                                        },
                                        child: Text(
                                          'accept.bu'.tr(),
                                          style: GoogleFonts.poppins(
                                              textStyle: const TextStyle(
                                                  fontFamily: 'poppins',
                                                  fontWeight: FontWeight.w400),
                                              color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Text(
                              'delete'.tr(),
                              style: GoogleFonts.poppins(
                                  textStyle: const TextStyle(
                                      fontFamily: 'poppins',
                                      fontWeight: FontWeight.w400),
                                  color: Colors.white),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
