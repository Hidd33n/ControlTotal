import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class SearchField extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String) onSuggestionSelected;
  final Future<List<String>> Function(String) suggestionsCallback;

  const SearchField({
    super.key,
    required this.controller,
    required this.onSuggestionSelected,
    required this.suggestionsCallback,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      child: Align(
        alignment: Alignment.center,
        child: TypeAheadField(
          textFieldConfiguration: TextFieldConfiguration(
            controller: controller,
            style: Theme.of(context).textTheme.bodySmall,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 5),
              hintText: 'search user'.tr(),
              hintStyle: Theme.of(context).textTheme.bodySmall,
              filled: true,
              fillColor: Theme.of(context).colorScheme.shadow,
              border: InputBorder.none,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              prefixIcon: Icon(
                Icons.search,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          suggestionsCallback: suggestionsCallback,
          itemBuilder: (context, suggestion) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context)
                    .colorScheme
                    .primary, // Puedes personalizar el color de fondo
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ListTile(
                title: Text(suggestion),
              ),
            );
          },
          noItemsFoundBuilder: (context) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).colorScheme.error,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ListTile(
                title: Text(
                  'search.em'.tr(),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            );
          },
          onSuggestionSelected: onSuggestionSelected,
        ),
      ),
    );
  }
}
