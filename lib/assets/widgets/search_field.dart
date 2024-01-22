import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class SearchField extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String) onSuggestionSelected;
  final Future<List<String>> Function(String) suggestionsCallback;

  const SearchField({
    required this.controller,
    required this.onSuggestionSelected,
    required this.suggestionsCallback,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.search,
          color: Theme.of(context).iconTheme.color,
        ),
        const SizedBox(
          width: 5,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.6,
          child: TypeAheadField(
            textFieldConfiguration: TextFieldConfiguration(
              controller: controller,
              style: Theme.of(context).textTheme.bodySmall,
              decoration: InputDecoration(
                hintText: 'search user'.tr(),
                hintStyle: Theme.of(context).textTheme.bodySmall,
                filled: true,
                fillColor: Theme.of(context).colorScheme.shadow,
                border: InputBorder.none,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
            suggestionsCallback: suggestionsCallback,
            itemBuilder: (context, suggestion) {
              return ListTile(title: Text(suggestion));
            },
            noItemsFoundBuilder: (context) {
              return ListTile(
                title: Text(
                  'search.em'.tr(),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              );
            },
            onSuggestionSelected: onSuggestionSelected,
          ),
        ),
      ],
    );
  }
}
