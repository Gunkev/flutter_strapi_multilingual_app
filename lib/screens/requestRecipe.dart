import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../utils/server.dart';


/// Request a recipe
class RecipeRequestScreen extends StatefulWidget {
  @override
  _RecipeRequestScreenState createState() => _RecipeRequestScreenState();
}

class _RecipeRequestScreenState extends State<RecipeRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final ApiService _apiService = ApiService();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submitRequest() async {
    if (_formKey.currentState!.validate()) {
      final description = _descriptionController.text;
      final descriptionList = [
        Description(
          type: 'paragraph',
          children: [
            TextContent(
              type: 'text',
              text: description,
              bold: false
            ),
          ],
        ),
      ];
      final request = RecipeRequest(
        title: _titleController.text,
        description: descriptionList,
        id: 0,
      );
      try {
        await _apiService.submitRecipeRequest(request);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(tr('request_successful'))),
        );
        _titleController.clear();
        _descriptionController.clear();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit recipe request: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr('request_recipe')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: tr('recipe_title')),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: tr('description')),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return tr('enter_description');
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitRequest,
                child: Text(tr('submit_request')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
