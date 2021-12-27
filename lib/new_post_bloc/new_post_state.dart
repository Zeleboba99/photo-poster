import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

@immutable
class NewPostState {
  final ByteData? image;
  final String? description;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;

  bool get isFormValid => image != null;

  NewPostState({
    this.image,
    this.description,
    required this.isSubmitting,
    required this.isSuccess,
    required this.isFailure,
  });

  factory NewPostState.empty() {
    return NewPostState(
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
    );
  }

  factory NewPostState.loading(ByteData image) {
    return NewPostState(
      image: image,
      isSubmitting: true,
      isSuccess: false,
      isFailure: false,
    );
  }

  factory NewPostState.failure(ByteData image) {
    return NewPostState(
      image: image,
      isSubmitting: false,
      isSuccess: false,
      isFailure: true,
    );
  }

  factory NewPostState.success(ByteData image) {
    return NewPostState(
      image: image,
      isSubmitting: false,
      isSuccess: true,
      isFailure: false,
    );
  }

  NewPostState update({
    ByteData? image,
    String? description
  }) {
    return copyWith(
      image: image,
      description: description,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
    );
  }

  NewPostState copyWith({
    ByteData? image,
    String? description,
    required bool isSubmitting,
    required bool isSuccess,
    required bool isFailure,
  }) {
    return NewPostState(
      image: image,
      description: description,
      isSubmitting: isSubmitting,
      isSuccess: isSuccess,
      isFailure: isFailure,
    );
  }

  @override
  String toString() {
    return '''RegisterState {
      image: $image,
      isSubmitting: $isSubmitting,
      isSuccess: $isSuccess,
      isFailure: $isFailure,
    }''';
  }
}