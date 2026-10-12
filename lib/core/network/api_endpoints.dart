/// DummyJSON endpoints used by the app.
abstract final class ApiEndpoints {
  static const String baseUrl = 'https://dummyjson.com';

  static const String login = '/auth/login';
  static const String me = '/auth/me';

  // Data requests go through DummyJSON's `/auth` prefix, which serves any
  // resource as the logged-in user. An expired or invalid token then comes
  // back as a real 401, which drives the log-out-on-401 requirement.
  static const String recipes = '/auth/recipes';
  static const String searchRecipes = '/auth/recipes/search';
  static String recipe(int id) => '/auth/recipes/$id';

  /// Endpoints that must not carry a bearer token or trigger a log out.
  static const Set<String> _public = {login};

  static bool isPublic(String path) => _public.contains(path);
}