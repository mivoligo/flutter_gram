import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../blocs/blocs.dart';
import '../../../models/models.dart';
import '../../../repositories/repositories.dart';

part 'create_post_state.dart';

class CreatePostCubit extends Cubit<CreatePostState> {
  CreatePostCubit({
    required PostRepository postRepository,
    required StorageRepository storageRepository,
    required AuthBloc authBloc,
  })  : _postRepository = postRepository,
        _storageRepository = storageRepository,
        _authBloc = authBloc,
        super(CreatePostState.initial());

  final PostRepository _postRepository;
  final StorageRepository _storageRepository;
  final AuthBloc _authBloc;

  void postImageChanged(File file) {
    emit(state.copyWith(postImage: file, status: CreatePostStatus.initial));
  }

  void captionChanged(String caption) {
    emit(state.copyWith(caption: caption, status: CreatePostStatus.initial));
  }

  Future<void> submit() async {
    emit(state.copyWith(status: CreatePostStatus.submitting));

    try {
      final author = User.empty.copyWith(id: _authBloc.state.user?.uid);
      final postImageUrl =
          await _storageRepository.uploadPostImage(image: state.postImage!);
      final post = Post(
        author: author,
        imageUrl: postImageUrl,
        caption: state.caption,
        likes: 0,
        date: DateTime.now(),
      );

      await _postRepository.createPost(post: post);

      emit(state.copyWith(status: CreatePostStatus.success));
    } catch (err) {
      emit(
        state.copyWith(
          status: CreatePostStatus.error,
          failure:
              const Failure(message: 'We were unable to create your post.'),
        ),
      );
    }
  }

  void reset() => emit(CreatePostState.initial());
}
