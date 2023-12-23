
import 'dart:convert';
import 'package:riverpod/riverpod.dart'; 
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tc/screens/home.dart';

final repositoriesProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final DateTime thirtyDaysAgo = DateTime.now().subtract(Duration(days: 30));
  final String formattedDate = thirtyDaysAgo.toIso8601String();

  final String apiUrl =
      'https://api.github.com/search/repositories?q=created:>$formattedDate&sort=stars&order=desc';

  final response = await http.get(Uri.parse(apiUrl));

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    final List<dynamic> repositories = data['items'];

    return repositories.map((repo) {
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
  } else {
    throw Exception('Failed to load repositories');
  }
});

void main() {
  runApp(ProviderScope(child: MyApp()));
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:  MyHomePage(),
    );
  }
}

