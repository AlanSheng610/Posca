import 'package:auto_animated_list/auto_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:fuzzy/fuzzy.dart';
import 'package:get/get.dart';
import 'package:posca/constants/languages.dart';

/// Searchable multi-select list of languages.
///
/// Takes the currently selected English names as arguments and returns the
/// new selection when confirmed.
class LanguagePickerScreen extends StatefulWidget {
  const LanguagePickerScreen({super.key});

  @override
  State<LanguagePickerScreen> createState() => _LanguagePickerScreenState();
}

class _LanguagePickerScreenState extends State<LanguagePickerScreen> {
  static final _fuzzy = Fuzzy<Language>(
    kLanguages,
    options: FuzzyOptions(
      threshold: 0.5,
      keys: [
        WeightedKey(name: 'english', getter: (l) => l.english, weight: 1),
        WeightedKey(name: 'native', getter: (l) => l.native, weight: 1),
      ],
    ),
  );

  late final Set<String> _selected = {...?Get.arguments as List<String>?};
  String _query = '';

  List<Language> get _results => _query.isEmpty
      ? kLanguages
      : _fuzzy.search(_query).map((result) => result.item).toList();

  void _toggle(Language language, bool selected) {
    setState(() {
      if (selected) {
        _selected.add(language.english);
      } else {
        _selected.remove(language.english);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () => Get.back(
              result: [
                for (final l in kLanguages)
                  if (_selected.contains(l.english)) l.english,
              ],
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              onChanged: (value) => setState(() => _query = value),
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Search',
                focusedBorder: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: AutoAnimatedList<Language>(
                items: _results,
                itemBuilder: (context, language, index, animation) {
                  return SizeFadeTransition(
                    animation: animation,
                    child: CheckboxListTile(
                      title: Text(
                        language.english,
                        style: const TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        language.native,
                        style: const TextStyle(color: Colors.white70),
                      ),
                      activeColor: Colors.white,
                      checkColor: Colors.black,
                      value: _selected.contains(language.english),
                      onChanged: (selected) => _toggle(language, selected!),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
