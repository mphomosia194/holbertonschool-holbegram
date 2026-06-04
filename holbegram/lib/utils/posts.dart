import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../screens/pages/methods/post_storage.dart';
class Posts extends StatefulWidget {
  const Posts({Key? key}) : super(key: key);

  @override
  State<Posts> createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('posts')
          .snapshots(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Error ${snapshot.error}'),
          );
        }

        if (snapshot.hasData) {
          final data = snapshot.data.docs;

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              return SingleChildScrollView(
                child: Container(
                  margin: EdgeInsetsGeometry.lerp(
                    const EdgeInsets.all(8),
                    const EdgeInsets.all(8),
                    10,
                  ),
                  height: 540,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(
                      255,
                      255,
                      255,
                      255,
                    ),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration:
                                  const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: ClipOval(
                                child: Image.network(
                                  data[index]
                                      ['profImage'],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              data[index]
                                  ['username'],
                            ),
                            const Spacer(),
                            IconButton(
                              onPressed: () async {
  await PostStorage().deletePost(
    data[index]['postId'],
    '',
  );

  if (!mounted) return;

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text(
        'Post Deleted',
      ),
    ),
  );
},
                              icon: const Icon(
                                Icons.more_horiz,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        child: Text(
                          data[index]['caption'],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: 350,
                        height: 350,
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(
                            25,
                          ),
                          image: DecorationImage(
                            image: NetworkImage(
                              data[index]
                                  ['postUrl'],
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Row(
                        children: const [
                          Icon(Icons.favorite_border),
                          SizedBox(width: 15),
                          Icon(Icons.comment_outlined),
                          SizedBox(width: 15),
                          Icon(Icons.send),
                          Spacer(),
                          IconButton(
  onPressed: () async {
    await FirebaseFirestore.instance
        .collection('favorites')
        .doc(data[index]['postId'])
        .set({
      'postId': data[index]['postId'],
      'postUrl': data[index]['postUrl'],
      'caption': data[index]['caption'],
      'username': data[index]['username'],
      'profImage': data[index]['profImage'],
    });

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Post Saved'),
      ),
    );
  },
  icon: const Icon(
   ,
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
