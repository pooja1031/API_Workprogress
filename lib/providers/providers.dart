import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:riverpod/riverpod.dart';
import 'package:tc/database/database.dart';

final databaseServiceProvider = Provider<DatabaseService>((ref) {
  return DatabaseService(); 
});

final repositoriesProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final String apiUrl =
      'https://api.github.com/search/repositories?q=created:>2022-04-29&sort=stars&order=desc';

  final response = await http.get(Uri.parse(apiUrl));

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    final List<dynamic> repositories = data['items'];

    final databaseService = ref.read(databaseServiceProvider);
    await databaseService.openDB();

    final List<Map<String, dynamic>> convertedRepositories = repositories.map<Map<String, dynamic>>((repo) {
      return {
        'name': repo['name'],
        'description': repo['description'],
        'stars': repo['stargazers_count'],
        'owner': {
          'username': repo['owner']['login'],
          'avatar': repo['owner']['avatar_url'],
        },
      };
    }).toList();

    await databaseService.saveData(convertedRepositories);

    return convertedRepositories;
  } else {
    throw Exception('Failed to load repositories');
  }
});
