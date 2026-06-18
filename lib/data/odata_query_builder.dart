// ignore_for_file: avoid_returning_this

class ODataQueryBuilder {
  ODataQueryBuilder({required this.baseUrl});
  final String baseUrl;
  final Map<String, String> _params = {};

  /// Add or replace $expand
  ODataQueryBuilder expand(String value) {
    _params[r'$expand'] = value;
    return this;
  }

  /// Add or replace $filter
  ODataQueryBuilder filter(String value) {
    _params[r'$filter'] = value;
    return this;
  }

  /// Add or replace $select
  ODataQueryBuilder select(String value) {
    _params[r'$select'] = value;
    return this;
  }

  /// Add or replace $orderby
  ODataQueryBuilder orderBy(String value) {
    _params[r'$orderby'] = value;
    return this;
  }

  /// Add or replace $top
  ODataQueryBuilder top(int count) {
    _params[r'$top'] = count.toString();
    return this;
  }

  /// Add or replace $skip
  ODataQueryBuilder skip(int count) {
    _params[r'$skip'] = count.toString();
    return this;
  }

  /// Add raw custom parameter
  ODataQueryBuilder param(String key, String value) {
    _params[key] = value;
    return this;
  }

  /// Builds the full URI
  Uri build() {
    return Uri.parse(baseUrl).replace(queryParameters: _params);
  }
}

// To include other fields like:

// contains(code, '$query')

// startswith(title, '$query')

// duration eq 5

// price lt 5000
