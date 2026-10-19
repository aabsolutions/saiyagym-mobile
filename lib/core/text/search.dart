/// Lowercase without Spanish accents ("Plátano" → "platano").
String foldForSearch(String text) => text
    .toLowerCase()
    .replaceAll(RegExp('[áàä]'), 'a')
    .replaceAll(RegExp('[éèë]'), 'e')
    .replaceAll(RegExp('[íìï]'), 'i')
    .replaceAll(RegExp('[óòö]'), 'o')
    .replaceAll(RegExp('[úùü]'), 'u')
    .replaceAll('ñ', 'n');

/// Every word of [query], in any order, accent-insensitive ("press banca"
/// finds "Press de banca"). An empty query matches everything.
bool Function(String text) searchMatcher(String query) {
  final words = foldForSearch(query)
      .split(RegExp(r'\s+'))
      .where((w) => w.isNotEmpty)
      .toList();
  return (text) {
    final folded = foldForSearch(text);
    return words.every(folded.contains);
  };
}
