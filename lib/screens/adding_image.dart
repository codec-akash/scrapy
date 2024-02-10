import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scarpbook/blocs/scrap_bloc.dart/scrap_bloc.dart';
import 'package:scarpbook/models/scarph_photos_model.dart';
import 'package:scarpbook/utils/date_format_util.dart';
import 'package:scarpbook/utils/extension_fucntion.dart';

class AddingImage extends StatefulWidget {
  static const String route = '/addingImage';
  const AddingImage({super.key});

  @override
  State<AddingImage> createState() => _AddingImageState();
}

class _AddingImageState extends State<AddingImage> {
  ImagePicker imagePicker = ImagePicker();
  List<XFile> pickedImage = [];
  List<AddingWebImageModel> webImages = [];

  bool isLoading = false;

  Future<void> pickImage() async {
    List<XFile> files = await imagePicker.pickMultiImage();
    if (files.isNotEmpty) {
      pickedImage = files;

      if (kIsWeb) {
        for (var element in pickedImage) {
          var byteData = await element.readAsBytes();
          webImages.add(AddingWebImageModel(
            byteImage: byteData,
            imageName: element.name,
            imagePath: element.path,
          ));
        }
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocListener<ScrapBookBloc, ScrapState>(
                listener: (context, state) {
                  if (state is ScrapBookLoading &&
                      state.currentEvent is PostWebImageToFirebaseStorage) {
                    setState(() {
                      isLoading = true;
                    });
                  }
                  if (state is ScrapBookFailed) {
                    context.showSnackBar(state.errorMsg);
                    setState(() {
                      isLoading = false;
                    });
                  }
                  if (state is WebImagePostedToFirebaseStorage) {
                    setState(() {
                      isLoading = false;
                    });
                    Navigator.of(context).pop();
                  }
                },
                child: Container()),
            SizedBox(
              height: context.getHeightAspectValue(30),
            ),
            if (pickedImage.isEmpty) ...[
              Center(
                child: GestureDetector(
                  onTap: () async {
                    await pickImage();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Theme.of(context).primaryColor,
                    ),
                    child: const Text("Add images"),
                  ),
                ),
              ),
            ],
            if (pickedImage.isNotEmpty) ...[
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Column(
                  children: webImages
                      .map(
                        (image) => Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                width: context.getWidthAspectValue(240),
                                child: Image.memory(image.byteImage),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    TextField(
                                      maxLines: 2,
                                      onChanged: (value) {
                                        image.title = value;
                                      },
                                      decoration: InputDecoration(
                                          hintText:
                                              "want to something about this post ??",
                                          hintStyle: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .copyWith(color: Colors.white24)),
                                    ),
                                    TextField(
                                      maxLength: 60,
                                      onChanged: (value) {
                                        image.polaroidTitle = value;
                                      },
                                      decoration: InputDecoration(
                                          hintText: "polaroid title ?",
                                          hintStyle: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .copyWith(color: Colors.white24)),
                                    ),
                                    GestureDetector(
                                      child: image.imageDate != null
                                          ? Text(
                                              DateTimeUtil.dateFormatToDateTime(
                                                  image.imageDate!))
                                          : const Text("select date time"),
                                      onTap: () async {
                                        DateTime? date =
                                            await DatePicker.showDateTimePicker(
                                                context);
                                        if (date != null) {
                                          setState(() {
                                            image.imageDate = date;
                                          });
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
              )
            ],
            if (webImages.isNotEmpty) ...[
              Center(
                child: GestureDetector(
                  onTap: () {
                    context.read<ScrapBookBloc>().add(
                        PostWebImageToFirebaseStorage(webImageList: webImages));
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Theme.of(context).primaryColor,
                    ),
                    child: isLoading
                        ? Center(child: CircularProgressIndicator())
                        : Text("Post Images"),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class AddingWebImageModel {
  final Uint8List byteImage;
  final String imageName;
  final String imagePath;
  late String? title;
  late String? polaroidTitle;
  late DateTime? imageDate;

  AddingWebImageModel({
    required this.byteImage,
    required this.imageName,
    required this.imagePath,
    this.title,
    this.polaroidTitle,
    this.imageDate,
  });
}
