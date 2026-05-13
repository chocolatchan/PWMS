class Gs1Parser {
  /// Parses a GS1 string (from DataMatrix or GS1-128) into a Map of AI codes and their values.
  /// Standard AIs supported:
  /// - 01: GTIN (14 chars)
  /// - 17: Expiry Date (6 chars, YYMMDD)
  /// - 10: Batch Number (Variable length, max 20, uses \x1D as separator)
  /// - 21: Serial Number (Variable length, max 20, uses \x1D as separator)
  static Map<String, String> parse(String code) {
    final Map<String, String> results = {};
    int i = 0;
    
    // Group Separator (FNC1) is often represented as ASCII 29 (\x1D)
    const String gs = '\x1D';

    // Strip common GS1 prefixes if present
    String cleanCode = code;
    if (cleanCode.startsWith(']C1')) cleanCode = cleanCode.substring(3);
    if (cleanCode.startsWith(']d2')) cleanCode = cleanCode.substring(3);

    while (i < cleanCode.length) {
      // Basic check for AI 01 (GTIN)
      if (cleanCode.startsWith('01', i) && i + 16 <= cleanCode.length) {
        results['gtin'] = cleanCode.substring(i + 2, i + 16);
        i += 16;
      } 
      // Basic check for AI 17 (Expiry)
      else if (cleanCode.startsWith('17', i) && i + 8 <= cleanCode.length) {
        results['expiry'] = cleanCode.substring(i + 2, i + 8);
        i += 8;
      }
      // AI 10 (Batch) - Variable length
      else if (cleanCode.startsWith('10', i)) {
        int end = cleanCode.indexOf(gs, i + 2);
        if (end == -1) end = cleanCode.length;
        results['batch'] = cleanCode.substring(i + 2, end);
        i = end;
        if (i < cleanCode.length && cleanCode[i] == gs) i++; // skip GS
      }
      // AI 21 (Serial Number) - Variable length
      else if (cleanCode.startsWith('21', i)) {
        int end = cleanCode.indexOf(gs, i + 2);
        if (end == -1) end = cleanCode.length;
        results['serial'] = cleanCode.substring(i + 2, end);
        i = end;
        if (i < cleanCode.length && cleanCode[i] == gs) i++; // skip GS
      }
      // AI 30 (Count) - Variable length
      else if (cleanCode.startsWith('30', i)) {
        int end = cleanCode.indexOf(gs, i + 2);
        if (end == -1) end = cleanCode.length;
        results['count'] = cleanCode.substring(i + 2, end);
        i = end;
        if (i < cleanCode.length && cleanCode[i] == gs) i++; // skip GS
      }
      // AI 37 (Count of trade items) - Variable length
      else if (cleanCode.startsWith('37', i)) {
        int end = cleanCode.indexOf(gs, i + 2);
        if (end == -1) end = cleanCode.length;
        results['count'] = cleanCode.substring(i + 2, end);
        i = end;
        if (i < cleanCode.length && cleanCode[i] == gs) i++; // skip GS
      }
      else {
        // Skip unknown character or move forward
        i++;
      }
    }
    return results;
  }

  /// Parses YYMMDD into a DateTime object
  static DateTime? parseGs1Date(String yymmdd) {
    if (yymmdd.length != 6) return null;
    try {
      int year = int.parse('20${yymmdd.substring(0, 2)}');
      int month = int.parse(yymmdd.substring(2, 4));
      int day = int.parse(yymmdd.substring(4, 6));
      
      // GS1 convention: if day is 00, it means the last day of the month
      if (day == 0) {
        DateTime firstOfNextMonth = DateTime(year, month + 1, 1);
        return firstOfNextMonth.subtract(const Duration(days: 1));
      }
      
      return DateTime(year, month, day);
    } catch (e) {
      return null;
    }
  }
}
