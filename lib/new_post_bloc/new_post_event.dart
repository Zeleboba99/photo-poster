import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class NewPostEvent extends Equatable {
  NewPostEvent([List props = const []]) : super(props);
}

class ImageChanged extends NewPostEvent {
  ByteData? image;

  ImageChanged(this.image) : super([image]);

  @override
  String toString() => 'ImageChanged { image :$image }';
}

class DescriptionChanged extends NewPostEvent {
  final String description;

  DescriptionChanged({required this.description}) : super([description]);

  @override
  String toString() => 'DescriptionChanged { description: $description }';
}

class PublishPostPressed extends NewPostEvent {
  final ByteData image;
  final String? description;

  PublishPostPressed({required this.image, this.description})
      : super([image, description]);

  @override
  String toString() {
    return 'PublishPostPressed { image: $image, description: $description }';
  }
}
