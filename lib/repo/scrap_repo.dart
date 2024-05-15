import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:scarpbook/models/scarph_photos_model.dart';
import 'package:scarpbook/screens/adding_image.dart';

class ScrapRepo {
  final scraphBookCollection =
      FirebaseFirestore.instance.collection('scrapBook');

  Stream<QuerySnapshot> getContentStream() {
    return scraphBookCollection
        .orderBy("imageDate", descending: false)
        .snapshots(includeMetadataChanges: true)
        .asBroadcastStream();
  }

  Future<List<AddingWebImageModel>> postWebImageToFS(
      List<AddingWebImageModel> webImages) async {
    try {
      var ref = FirebaseStorage.instance.ref().child("scrapImages");

      List<AddingWebImageModel> uploadedWebImages = [];
      for (var element in webImages) {
        final metadata = SettableMetadata(
          contentType: 'image/jpeg',
          customMetadata: {'picked-file-path': element.imagePath},
        );

        TaskSnapshot snapshot = await ref
            .child("/${element.imageName}")
            .putData(element.byteImage, metadata);

        var url = await snapshot.ref.getDownloadURL();

        uploadedWebImages.add(AddingWebImageModel(
          byteImage: element.byteImage,
          imageName: element.imageName,
          imagePath: url,
          title: element.title,
          polaroidTitle: element.polaroidTitle,
          imageDate: element.imageDate,
        ));
        debugPrint("check this -- $url");
      }
      return Future.value(uploadedWebImages);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> uploadDataToFireStore(
      List<AddingWebImageModel> uploadAddress) async {
    try {
      for (var element in uploadAddress) {
        await scraphBookCollection.add({
          "imageLink": element.imagePath,
          "imageName": element.imageName,
          "imageDate": element.imageDate?.toIso8601String() ??
              DateTime.now().toIso8601String(),
          "createdAt": DateTime.now().toIso8601String(),
          "userId": FirebaseAuth.instance.currentUser!.uid,
          "polaroidTitle": element.polaroidTitle,
          "title": element.title,
        });
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> deleteScrapPhoto(ScrapBookPhoto scrapPhoto) async {
    try {
      var ref = FirebaseStorage.instance
          .ref()
          .child("scrapImages")
          .child("/${scrapPhoto.imageName}");

      await ref.delete();
      await scraphBookCollection.doc(scrapPhoto.id).delete();
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> updateScrapPhoto(ScrapBookPhoto scrapPhoto) async {
    try {
      await scraphBookCollection.doc(scrapPhoto.id).update(scrapPhoto.toJson());
    } catch (e) {
      throw e.toString();
    }
  }
}
