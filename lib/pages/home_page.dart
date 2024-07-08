import 'package:flutter/material.dart';
import '../models/post.dart';
import '../services/api_service.dart';
import 'create_post_page.dart';
import 'edit_post_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Post>> futurePosts;
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    futurePosts = apiService.fetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter CRUD App'),
      ),
      body: FutureBuilder<List<Post>>(
        future: futurePosts,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Post> posts = snapshot.data!;
            return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  elevation: 5,
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: ListTile(
                      title: Text(
                        posts[index].title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      subtitle: Text(
                        posts[index].body,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () async {
                              bool result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EditPostPage(post: posts[index]),
                                ),
                              );
                              if (result) {
                                setState(() {
                                  futurePosts = apiService.fetchPosts();
                                });
                              }
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Delete Post'),
                                    content: Text(
                                        'Are you sure you want to delete this post?'),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text('Cancel'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: Text('Delete'),
                                        onPressed: () {
                                          apiService
                                              .deletePost(posts[index].id)
                                              .then((value) {
                                            setState(() {
                                              futurePosts =
                                                  apiService.fetchPosts();
                                            });
                                          });
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          bool result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreatePostPage()),
          );
          if (result) {
            setState(() {
              futurePosts = apiService.fetchPosts();
            });
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
