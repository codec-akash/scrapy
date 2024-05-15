import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scarpbook/models/scarph_photos_model.dart';
import 'package:scarpbook/repo/scrap_repo.dart';
import 'package:scarpbook/screens/adding_image.dart';

part 'scrap_event.dart';
part 'scrap_state.dart';

class ScrapBookBloc extends Bloc<ScrapEvent, ScrapState> {
  ScrapRepo scrapRepo = ScrapRepo();
  late StreamSubscription<QuerySnapshot> _subscription;

  ScrapBookBloc() : super(Uninitialized()) {
    _subscription = scrapRepo.getContentStream().listen((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        add(GetStreamScrapBook(
            scrapPhotos: snapshot.docs
                .map((scrapPhoto) => ScrapBookPhoto.fromJson(
                    scrapPhoto.data() as Map<String, dynamic>)
                  ..id = scrapPhoto.id)
                .toList()));
      }
    });

    on<LoadScrap>(_loadScrap);
    on<PostWebImageToFirebaseStorage>(_postWebImageToFS);
    on<AddUploadedDataToFireStore>(_uploadDataToFireStore);
    on<GetStreamScrapBook>((event, emit) {
      emit(ScrapBookLoading(currentEvent: event));
      emit(StreamScrapbookLoaded(scrapPhotos: event.scrapPhotos));
    });
    on<DeleteScarpPhoto>(_deleteScrapPhoto);
    on<UpdateScrapPhoto>(_updateScrapPhoto);
  }

  Future<void> _loadScrap(LoadScrap event, Emitter<ScrapState> emit) async {}

  Future<void> _postWebImageToFS(
      PostWebImageToFirebaseStorage event, Emitter<ScrapState> emit) async {
    try {
      emit(ScrapBookLoading(currentEvent: event));
      List<AddingWebImageModel> uploadedImage =
          await scrapRepo.postWebImageToFS(event.webImageList);
      add(AddUploadedDataToFireStore(scrapDatas: uploadedImage));
      emit(WebImagePostedToFirebaseStorage(uploadImageList: uploadedImage));
    } catch (e) {
      emit(ScrapBookFailed(errorMsg: e.toString(), currentEvent: event));
    }
  }

  Future<void> _uploadDataToFireStore(
      AddUploadedDataToFireStore event, Emitter<ScrapState> emit) async {
    try {
      emit(ScrapBookLoading(currentEvent: event));
      await scrapRepo.uploadDataToFireStore(event.scrapDatas);
      emit(DataUploadedToFireStore());
    } catch (e) {
      emit(ScrapBookFailed(errorMsg: e.toString(), currentEvent: event));
    }
  }

  Future<void> _deleteScrapPhoto(
      DeleteScarpPhoto event, Emitter<ScrapState> emit) async {
    try {
      emit(ScrapBookLoading(currentEvent: event));
      await scrapRepo.deleteScrapPhoto(event.scarpBookPhoto);
      emit(ScrapPhotoDeleted());
    } catch (e) {
      emit(ScrapBookFailed(errorMsg: e.toString(), currentEvent: event));
    }
  }

  Future<void> _updateScrapPhoto(
      UpdateScrapPhoto event, Emitter<ScrapState> emit) async {
    try {
      emit(ScrapBookLoading(currentEvent: event));
      await scrapRepo.updateScrapPhoto(event.scrapBookPhoto);
      emit(ScrapPhotoUpdated());
    } catch (e) {
      emit(ScrapBookFailed(errorMsg: e.toString(), currentEvent: event));
    }
  }
}
