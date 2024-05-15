import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scarpbook/blocs/scrap_bloc.dart/scrap_bloc.dart';
import 'package:scarpbook/models/scarph_photos_model.dart';
import 'package:scarpbook/screens/adding_image.dart';
import 'package:scarpbook/widgets/polaroid_photo.dart';

class HomePolaroidScreen extends StatefulWidget {
  const HomePolaroidScreen({super.key});

  @override
  State<HomePolaroidScreen> createState() => _HomePolaroidScreenState();
}

class _HomePolaroidScreenState extends State<HomePolaroidScreen> {
  List<ScrapBookPhoto> scrapBookPhoto = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text("Your Scrapbook Polaroid 🤗"),
            const Spacer(),
            Tooltip(
              message: "add your memories",
              child: Container(
                padding: const EdgeInsets.all(4),
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.primary,
                ),
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(AddingImage.route);
                  },
                  icon: const Icon(
                    Icons.add_a_photo_outlined,
                    size: 18,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            BlocListener<ScrapBookBloc, ScrapState>(
              listener: (context, state) {
                if (state is WebImagePostedToFirebaseStorage) {
                  setState(() {});
                }
                if (state is StreamScrapbookLoaded) {
                  setState(() {
                    scrapBookPhoto = state.scrapPhotos;
                  });
                }
              },
              child: Container(),
            ),
            Expanded(
              child: Column(
                children: [
                  if (scrapBookPhoto.isEmpty) ...[
                    const SizedBox(height: 10),
                    const Center(
                      child: Text("No memories yet"),
                    ),
                  ],
                  Expanded(
                    child: ListView.builder(
                      itemCount: scrapBookPhoto.length,
                      itemBuilder: (context, index) => PolaroidPhotoCard(
                        scarpBookPhoto: scrapBookPhoto[index],
                        isEven: index % 2 == 0,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
