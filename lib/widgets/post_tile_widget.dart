import 'package:flutter/material.dart';
import 'package:social_media_insta/widgets/post_widget.dart';

class PostTile extends StatelessWidget {
  final Post post;
  const PostTile({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Image.network(post.url),
    );
  }
}
