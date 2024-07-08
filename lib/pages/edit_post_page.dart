import 'package:flutter/material.dart';
import '../models/post.dart';
import '../services/api_service.dart';

class EditPostPage extends StatefulWidget {
  final Post post;

  EditPostPage({required this.post});

  @override
  _EditPostPageState createState() => _EditPostPageState();
}

class _EditPostPageState extends State<EditPostPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.post.title;
    _bodyController.text = widget.post.body;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Post'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _bodyController,
                decoration: InputDecoration(
                  labelText: 'Body',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a body';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Post updatedPost = Post(
                      id: widget.post.id,
                      title: _titleController.text,
                      body: _bodyController.text,
                    );
                    apiService.updatePost(updatedPost).then((value) {
                      Navigator.pop(context, true);
                    });
                  }
                },
                child: Text('Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
