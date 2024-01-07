import 'package:calcu/functions/search_services.dart';
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
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(
                top: 40.0, left: 16.0, right: 16.0, bottom: 16.0),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TypeAheadField(
                    textFieldConfiguration: TextFieldConfiguration(
                      controller: _searchController,
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        hintText: 'search user'.tr(),
                        hintStyle:
                            const TextStyle(color: Colors.black, fontSize: 14),
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    suggestionsCallback: _searchService.fetchUserSuggestions,
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
                                  _searchService.sendInvitation(suggestion);
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
          const SizedBox(height: 100),
          Center(
              child: Text(
            'team member'.tr(),
            style: const TextStyle(
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
                return const CircularProgressIndicator();
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
                                title: Text('delete'.tr()),
                                content: Text(
                                    '¿Estás seguro de que deseas eliminar a $username de tus amigos?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('cancel.bu'.tr()),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      _searchService.removeFriend(username);
                                    },
                                    child: Text('accept.bu'.tr(),
                                        style: const TextStyle(
                                            color: Colors.blue)),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Text('delete'.tr(),
                            style: const TextStyle(color: Colors.blue)),
                      ),
                    ],
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
