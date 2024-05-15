part of 'scrap_bloc.dart';

class ScrapEvent extends Equatable {
  const ScrapEvent();

  @override
  List<Object?> get props => [];
}

class LoadScrap extends ScrapEvent {}

class PostWebImageToFirebaseStorage extends ScrapEvent {
  final List<AddingWebImageModel> webImageList;

  const PostWebImageToFirebaseStorage({required this.webImageList});
}

class AddUploadedDataToFireStore extends ScrapEvent {
  final List<AddingWebImageModel> scrapDatas;

  const AddUploadedDataToFireStore({required this.scrapDatas});
}

class GetStreamScrapBook extends ScrapEvent {
  final List<ScrapBookPhoto> scrapPhotos;

  const GetStreamScrapBook({required this.scrapPhotos});
}

class DeleteScarpPhoto extends ScrapEvent {
  final ScrapBookPhoto scarpBookPhoto;

  const DeleteScarpPhoto({required this.scarpBookPhoto});
}

class UpdateScrapPhoto extends ScrapEvent {
  final ScrapBookPhoto scrapBookPhoto;

  const UpdateScrapPhoto({required this.scrapBookPhoto});
}
