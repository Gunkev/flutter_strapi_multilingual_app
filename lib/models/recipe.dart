import 'package:flutter_dotenv/flutter_dotenv.dart';

// models recipe_ request
class RecipeRequest {
  final int id;
  final String title;
  final List<Description> description;

  RecipeRequest({
    required this.id,
    required this.title,
    required this.description,
  });

  factory RecipeRequest.fromJson(Map<String, dynamic> json) {
    var attr = json['attributes'] ?? {};
    var attributes = json['attributes'] ?? {};
    List<Description> descriptionList = (attr['description'] as List? ?? [])
        .map((desc) => Description.fromJson(desc)).toList();


    print("Parsed Recipe: ${json['id']} - Descriptions: ${descriptionList.length}");

    return RecipeRequest(
      id: json['id'] ?? 0,
      title: attr['title'] ?? 'No title',
      description: descriptionList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description.map((desc) => desc.toJson()).toList(),
      // 'id': id
    };
  }
}

// step model

class Step {
  final String type;
  final List<TextContent> children;
  final int? level;

  Step({required this.type, required this.children, this.level});

  factory Step.fromJson(Map<String, dynamic> json) {
    var childrenList = json['children'] as List? ?? [];
    List<TextContent> parsedChildren = childrenList.map((child) => TextContent.fromJson(child)).toList();
    return Step(
      type: json['type'] ?? '',
      children: parsedChildren,
      level: json['level'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'children': children.map((child) => child.toJson()).toList(),
      'level': level,
    };
  }
}

// description model

class Description {
  final String type;
  final List<TextContent> children;
  final int? level;

  Description({required this.type, required this.children, this.level});

  factory Description.fromJson(Map<String, dynamic> json) {
    var childrenList = json['children'] as List? ?? [];
    List<TextContent> parsedChildren = childrenList.map((child) => TextContent.fromJson(child)).toList();
    return Description(
      type: json['type'] ?? '',
      children: parsedChildren,
      level: json['level'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'children': children.map((child) => child.toJson()).toList(),
      'level': level,
    };
  }
}

class TextContent {
  final String type;
  final String text;
  final bool? bold;

  TextContent({required this.type, required this.text, this.bold});

  factory TextContent.fromJson(Map<String, dynamic> json) {
    return TextContent(
      type: json['type'] ?? '',
      text: json['text'] ?? '',
      bold: json['bold'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'text': text,
      'bold': bold,
    };
  }
}

class Comment {
  final String content;
  final String author;
  final DateTime createdAt;

  Comment({
    required this.content,
    required this.author,
    required this.createdAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    var attributes = json['attributes'] as Map<String, dynamic> ?? {};
    var authorData = attributes['comment_author']?['data']?['attributes'] ?? {};
    return Comment(
      content: attributes['content'] ?? 'No content',
      author: authorData['username'] ?? 'Unknown',
      createdAt: DateTime.parse(attributes['createdAt'] ?? DateTime.now().toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'author': author,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

//recipe model

class Recipe {
  final int id;
  final String title;
  final List<Description> description;
  final String ingredients;
  late int likes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime publishedAt;
  final List<Step> steps;
  late int commentCount;
  final List<Comment> comments;
  final String coverImageUrl;

  Recipe({
    required this.id,
    required this.title,
    required this.description,
    required this.ingredients,
    required this.likes,
    required this.createdAt,
    required this.updatedAt,
    required this.publishedAt,
    required this.steps,
    required this.commentCount,
    required this.comments,
    required this.coverImageUrl
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    var attr = json['attributes'] as Map<String, dynamic> ?? {};

    // Parse descriptions
    List<Description> descriptionList = [];
    if (attr['description'] != null && attr['description'] is List) {
      descriptionList = (attr['description'] as List).map((desc) => Description.fromJson(desc)).toList();
    }

    // Parse steps
    List<Step> stepsList = [];
    if (attr['steps'] != null && attr['steps'] is List) {
      stepsList = (attr['steps'] as List).map((step) => Step.fromJson(step)).toList();
    }

    // Parse comments
    List<Comment> commentList = [];
    if (attr['comments'] != null && attr['comments']['data'] != null && attr['comments']['data'] is List) {
      commentList = (attr['comments']['data'] as List).map((comment) => Comment.fromJson(comment)).toList();
    }

    // var attr = json['attributes'] as Map<String, dynamic>;
    final String baseUrl = dotenv.env['BASE_URL']!;

    // Ensure image URL is correctly prefixed
    String coverImageUrl = '';
    if (attr['cover'] != null && attr['cover']['data'] != null) {
      var imageUrl = attr['cover']['data']['attributes']['url'];
      coverImageUrl = imageUrl.startsWith('http')
          ? imageUrl
          : baseUrl + imageUrl;  // Correctly append base URL if not already present
    }

    return Recipe(
        id: json['id'] ?? 0,
        title: attr['title'] ?? 'No title',
        description: descriptionList,
        ingredients: attr['ingredients'] ?? 'No ingredients',
        likes: attr['likes'] ?? 0,
        createdAt: DateTime.tryParse(attr['createdAt'] ?? DateTime.now().toIso8601String()) ?? DateTime.now(),
        updatedAt: DateTime.tryParse(attr['updatedAt'] ?? DateTime.now().toIso8601String()) ?? DateTime.now(),
        publishedAt: DateTime.tryParse(attr['publishedAt'] ?? DateTime.now().toIso8601String()) ?? DateTime.now(),
        steps: stepsList,
        commentCount: commentList.length,
        comments: commentList,
        coverImageUrl: coverImageUrl
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description.map((desc) => desc.toJson()).toList(),
      'ingredients': ingredients,
      'likes': likes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'publishedAt': publishedAt.toIso8601String(),
      'steps': steps.map((step) => step.toJson()).toList(),
      'commentCount': commentCount,
      'comments': comments.map((comment) => comment.toJson()).toList(),
      'cover': coverImageUrl
    };
  }
}

