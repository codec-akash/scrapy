part of 'scrap_bloc.dart';

class ScrapState extends Equatable {
  const ScrapState();

  @override
  List<Object?> get props => [];
}

class Uninitialized extends ScrapState {
  @override
  String toString() => 'Uninitialized';
}

class ScrapBookLoading extends ScrapState {
  final ScrapEvent currentEvent;

  const ScrapBookLoading({required this.currentEvent});
}

class ScrapBookFailed extends ScrapState {
  final String errorMsg;
  final ScrapEvent currentEvent;

  const ScrapBookFailed({
    required this.errorMsg,
    required this.currentEvent,
  });
}

class ScrapLoaded extends ScrapState {}

class WebImagePostedToFirebaseStorage extends ScrapState {
  final List<AddingWebImageModel> uploadImageList;

  const WebImagePostedToFirebaseStorage({required this.uploadImageList});
}

class DataUploadedToFireStore extends ScrapState {}

class StreamScrapbookLoaded extends ScrapState {
  final List<ScarpBookPhoto> scrapPhotos;

  const StreamScrapbookLoaded({required this.scrapPhotos});
}

class ScrapPhotoDeleted extends ScrapState {}
