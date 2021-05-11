import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../extensions/extensions.dart';
import '../models/models.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/screens.dart';
import 'user_profile_image.dart';

class PostView extends StatelessWidget {
  const PostView({
    required this.post,
    required this.isLiked,
    required this.onLike,
    this.recentlyLiked = false,
  });

  final Post post;
  final bool isLiked;
  final VoidCallback onLike;
  final bool recentlyLiked;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => Navigator.of(context).pushNamed(
            ProfileScreen.routeName,
            arguments: ProfileScreenArgs(userId: post.author.id),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                UserProfileImage(
                  radius: 18.0,
                  profileImageUrl: post.author.profileImageUrl,
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: Text(
                    post.author.username,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        GestureDetector(
          onDoubleTap: onLike,
          child: CachedNetworkImage(
            width: double.infinity,
            height: MediaQuery.of(context).size.height / 2,
            imageUrl: post.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        Row(
          children: [
            IconButton(
              onPressed: onLike,
              icon: isLiked
                  ? const Icon(
                      Icons.favorite,
                      color: Colors.red,
                    )
                  : const Icon(Icons.favorite_border),
            ),
            IconButton(
              onPressed: () => Navigator.of(context).pushNamed(
                CommentsScreen.routeName,
                arguments: CommentsScreenArgs(post: post),
              ),
              icon: const Icon(Icons.comment_outlined),
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '${recentlyLiked ? post.likes + 1 : post.likes} likes',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4.0),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: post.author.username,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const TextSpan(text: ' '),
                    TextSpan(text: post.caption),
                  ],
                ),
              ),
              const SizedBox(height: 4.0),
              Text(
                post.date?.timeAgo() ?? '',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
