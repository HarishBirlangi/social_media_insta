import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_media_insta/models/user.dart';
import 'package:social_media_insta/pages/home_page.dart';
import 'package:social_media_insta/widgets/progress_widget.dart';

class Post extends StatefulWidget {
  final String postId;
  final String ownerId;
  final dynamic likes;
  final String userName;
  final String description;
  final String location;
  final String url;
  const Post({
    Key? key,
    required this.postId,
    required this.ownerId,
    required this.likes,
    required this.userName,
    required this.description,
    required this.location,
    required this.url,
  }) : super(key: key);

  factory Post.fromDocument(DocumentSnapshot documentSnapshot) {
    return Post(
        postId: documentSnapshot['postId'],
        ownerId: documentSnapshot['ownerId'],
        likes: documentSnapshot['likes'],
        userName: documentSnapshot['userName'],
        description: documentSnapshot['description'],
        location: documentSnapshot['location'],
        url: documentSnapshot['url']);
  }

  int getTotalNumberOfLikes(likes) {
    if (likes == null) {
      return 0;
    }

    int counter = 0;
    likes.values.forEach((eachValue) {
      if (eachValue == true) {
        counter += 1;
      }
    });
    return counter;
  }

  @override
  createState() => _PostState();
}

class _PostState extends State<Post> {
  @override
  Widget build(BuildContext context) {
    int likeCount = 0;
    bool isLiked = false;
    bool showHeart = false;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          createPostHead(widget.ownerId, widget.location),
          createPostPicture(widget.url),
          createPostFooter(
              isLiked, likeCount, widget.userName, widget.description),
        ],
      ),
    );
  }
}

createPostPicture(String url) {
  return GestureDetector(
    onDoubleTap: () {
      print('Likes the post');
    },
    child: Stack(
      alignment: Alignment.center,
      children: [
        Image.network(url),
      ],
    ),
  );
}

createPostHead(String ownerId, String location) {
  return FutureBuilder(
    future: userReference.doc(ownerId).get(),
    builder: (context, dataSnapshot) {
      if (!dataSnapshot.hasData) {
        return circularProgress();
      }
      UserDetails user = UserDetails.fromDocument(dataSnapshot.data!);
      bool isPostOwner = currentUser.id == ownerId;
      return ListTile(
          leading: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(user.url),
            backgroundColor: Colors.grey,
          ),
          title: GestureDetector(
            onTap: () {
              print('Show profile');
            },
            child: Text(
              user.userName,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          subtitle: Text(
            location,
            style: const TextStyle(color: Colors.white),
          ),
          trailing: isPostOwner
              ? IconButton(
                  onPressed: () {
                    print('Deleted');
                  },
                  icon: const Icon(
                    Icons.more_vert,
                    color: Colors.white,
                  ))
              : const Text(""));
    },
  );
}

createPostFooter(
    bool isLiked, int likeCount, String userName, String description) {
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Padding(padding: EdgeInsets.only(top: 40, left: 20)),
          GestureDetector(
            onTap: () {
              print("liked the post");
            },
            child: const Icon(
              Icons.favorite, color: Colors.grey,
              // isLiked ? Icons.favorite : Icons.favorite_border,
              // size: 28,
            ),
          ),
          const Padding(padding: EdgeInsets.only(left: 20)),
          GestureDetector(
            onTap: () {
              print('Show comments');
            },
            child: const Icon(
              Icons.chat_bubble_outline,
              size: 28,
              color: Colors.white,
            ),
          )
        ],
      ),
      Row(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 20),
            child: Text(
              '$likeCount likes',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(left: 20),
            child: Text(
              '$userName ',
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(
              description,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    ],
  );
}
