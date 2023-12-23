import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tc/main.dart';

class MyHomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repositoriesAsyncValue = ref.watch(repositoriesProvider);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey,
          toolbarHeight: 90,
          title: Text('Repositories')),
        body: repositoriesAsyncValue.when(
          loading: () => Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Center(child: Text('Error fetching repositories')),
          data: (repositories) {
            if (repositories.isEmpty) {
              return Center(child: Text('No repositories found'));
            }
            return ListView.builder(
  itemCount: repositories.length,
  itemBuilder: (context, index) {
    final repo = repositories[index];
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(repo['name']),
          subtitle: Text(repo['description'] ?? 'No description available'),
          leading: CircleAvatar(
            backgroundImage: NetworkImage(repo['owner']['avatar']),
          ),
          trailing: Text('${repo['stars']} stars'),
        ),
        Divider(
          color: Colors.grey, 
          thickness: 1, 
          indent: 16, 
          endIndent: 16, 
        ),
      ],
    );
  },
);

          },
        ),
      ),
    );
  }
}