import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_recipe_app/screens/requestRecipe.dart';
import '../models/recipe.dart';
import '../utils/server.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<List<RecipeRequest>> _requestedRecipesFuture;

  @override
  void initState() {
    super.initState();
    _requestedRecipesFuture = ApiService().fetchUserRequestedRecipes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr('profile')),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Text(
                  tr('request_list'),
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RecipeRequestScreen()),

                    );
                  },
                  child: Text(tr('request_new_recipe')),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<RecipeRequest>>(
              future: _requestedRecipesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error.toString()}'));
                } else if (snapshot.data == null || snapshot.data!.isEmpty) {
                  return Center(child: Text(tr('no_request_found')));
                }

                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    RecipeRequest request = snapshot.data![index];
                    String fullDescription = request.description
                        .map((d) => d.children.map((t) => t.text).join('\n'))
                        .join('\n\n');

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0),
                      child: ListTile(
                        title: Text(request.title.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold),),
                        subtitle: Text(fullDescription),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      )

    );
  }
}
