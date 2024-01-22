import 'package:calcu/assets/functions/search_services.dart';
import 'package:calcu/assets/widgets/search_field.dart';
import 'package:calcu/assets/utils/invitation_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchView extends StatefulWidget {
  const SearchView({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
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
      appBar: AppBar(
          title: SearchField(
            controller: _searchController,
            onSuggestionSelected: (suggestion) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return InvitationDialog(
                    suggestion: suggestion,
                    onCancel: () {
                      Navigator.of(context).pop();
                    },
                    onAccept: () {
                      Navigator.of(context).pop();
                      _searchService.sendInvitation(suggestion);
                    },
                  );
                },
              );
            },
            suggestionsCallback: _searchService.fetchUserSuggestions,
          ),
          automaticallyImplyLeading: false),
      body: Container(
        color: Theme.of(context).colorScheme.primary,
        child: Column(
          children: [
            const SizedBox(height: 60),
            Center(
                child: Text(
              'team member'.tr(),
              style: Theme.of(context).textTheme.bodyLarge,
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
                    style: Theme.of(context).textTheme.bodyLarge,
                  );
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Container(
                    color: Colors.black,
                    child: Text(
                      'empty.team'.tr(),
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  );
                }

                List<String> friendUsernames = snapshot.data!.docs
                    .map((doc) => doc.data() as Map<String, dynamic>)
                    .where((data) => data.containsKey('username'))
                    .map((data) => data['username'].toString())
                    .toList();

                return Container(
                  color: Theme.of(context).colorScheme.primary,
                  child: Column(
                    children: friendUsernames.map((username) {
                      return Row(
                        children: [
                          Expanded(
                            child: Container(
                              color: Theme.of(context).colorScheme.primary,
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Text(
                                username,
                                style: Theme.of(context).textTheme.bodyLarge,
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
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                                    content: Text(
                                      '¿Estás seguro de que deseas eliminar a $username de tus amigos?',
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          'cancel.bu'.tr(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge,
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          _searchService.removeFriend(username);
                                        },
                                        child: Text(
                                          'accept.bu'.tr(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge,
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Text(
                              'delete'.tr(),
                              style: Theme.of(context).textTheme.bodyLarge,
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
