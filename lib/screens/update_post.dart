import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:scarpbook/models/scarph_photos_model.dart';
import 'package:scarpbook/utils/date_format_util.dart';
import 'package:scarpbook/utils/extension_fucntion.dart';
import 'package:scarpbook/widgets/image_widget.dart';

import '../blocs/scrap_bloc.dart/scrap_bloc.dart';

class UpdateScrapPost extends StatefulWidget {
  static const String route = '/updatingImage';
  final ScrapBookPhoto scrapBookPhoto;
  const UpdateScrapPost({super.key, required this.scrapBookPhoto});

  @override
  State<UpdateScrapPost> createState() => _UpdateScrapPostState();
}

class _UpdateScrapPostState extends State<UpdateScrapPost> {
  bool isLoading = false;
  TextEditingController titleController = TextEditingController();
  TextEditingController polaroidTitleController = TextEditingController();

  @override
  void initState() {
    titleController.text = widget.scrapBookPhoto.title ?? "";
    polaroidTitleController.text = widget.scrapBookPhoto.polaroidTitle ?? "";
    super.initState();
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
                      state.currentEvent is UpdateScrapPhoto) {
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
                  if (state is ScrapPhotoUpdated) {
                    context.showSnackBar("updated successfully");
                    setState(() {
                      isLoading = false;
                    });
                    Navigator.pop(context);
                  }
                },
                child: Container()),
            SizedBox(
              height: context.getHeightAspectValue(30),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Column(
                children: [
                  Container(
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
                          child: ImageWidget.getImageWidget(
                              widget.scrapBookPhoto.imageLink),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              TextField(
                                maxLines: 2,
                                controller: titleController,
                                onChanged: (value) {
                                  widget.scrapBookPhoto.title = value;
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
                                controller: polaroidTitleController,
                                onChanged: (value) {
                                  widget.scrapBookPhoto.polaroidTitle = value;
                                },
                                decoration: InputDecoration(
                                    hintText: "polaroid title ?",
                                    hintStyle: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(color: Colors.white24)),
                              ),
                              GestureDetector(
                                child: widget.scrapBookPhoto.imageDate != null
                                    ? Text(DateTimeUtil.dateFormatToDateTime(
                                        DateTime.parse(
                                                widget.scrapBookPhoto.imageDate)
                                            .toLocal()))
                                    : const Text("select date time"),
                                onTap: () async {
                                  DateTime? date =
                                      await DatePicker.showDateTimePicker(
                                          context);
                                  if (date != null) {
                                    setState(() {
                                      widget.scrapBookPhoto.imageDate =
                                          date.toLocal().toIso8601String();
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
                ],
              ),
            ),
            Center(
              child: GestureDetector(
                onTap: () {
                  context.read<ScrapBookBloc>().add(
                      UpdateScrapPhoto(scrapBookPhoto: widget.scrapBookPhoto));
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Theme.of(context).primaryColor,
                  ),
                  child: isLoading
                      ? Center(child: CircularProgressIndicator())
                      : Text("Update Images"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
