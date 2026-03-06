// ignore_for_file: constant_identifier_names, non_constant_identifier_names
const String REGEX_XML_NOCLOSE = '[^\'">]*("[^"]*"[^">]*|\'[^\']*\'[^\'">]*)*';
const String REGEX_XML_QUOTED = "[\"][^\"]*[\"]|['][^']*[']";
String REGEX_QUOTED_PATTERN(String Function(String quoteChar) regex) =>
    '("${regex('"')}"|\'${regex("'")}\')';
