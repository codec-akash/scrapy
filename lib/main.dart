import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scarpbook/blocs/login_bloc/login_bloc.dart';
import 'package:scarpbook/blocs/scrap_bloc.dart/scrap_bloc.dart';
import 'package:scarpbook/env/env.dart';
import 'package:scarpbook/models/scarph_photos_model.dart';
import 'package:scarpbook/repo/auth_repo.dart';
import 'package:scarpbook/screens/adding_image.dart';
import 'package:scarpbook/screens/home_palorid.dart';
import 'package:scarpbook/screens/login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: Env.apikey,
      appId: Env.appId,
      messagingSenderId: Env.messageId,
      projectId: Env.projectId,
      authDomain: Env.authDomain,
      storageBucket: Env.storageBucket,
      measurementId: Env.measurementId,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthRepo authRepo = AuthRepo();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(create: (context) => LoginBloc(authRepo)),
        BlocProvider<ScrapBookBloc>(create: (context) => ScrapBookBloc()),
      ],
      child: MaterialApp(
        title: 'Scrapy',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xff141115),
          brightness: Brightness.dark,
        ),
        initialRoute: "/",
        routes: {
          '': (context) => LoginScreen(),
          AddingImage.route: (context) => AddingImage(),
        },
        home: BlocBuilder<LoginBloc, LoginState>(
          builder: (context, state) {
            if (state is LoggedInWithGoogle) {
              return HomePolaroidScreen() ?? MyHomePage(title: "");
            }
            return const LoginScreen();
          },
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  ImagePicker imagePicker = ImagePicker();
  List<XFile> pickedImage = [];
  List<AddingWebImageModel> webImages = [];
  List<ScarpBookPhoto> scrapPhotos = [];

  void _incrementCounter() {
    Navigator.of(context).pushNamed(AddingImage.route);
  }

  Future<void> pickImage() async {
    List<XFile> files = await imagePicker.pickMultiImage();
    if (files.isNotEmpty) {
      pickedImage = files;

      if (kIsWeb) {
        for (var element in pickedImage) {
          var byteData = await element.readAsBytes();
          webImages.add(
            AddingWebImageModel(
              byteImage: byteData,
              imageName: element.name,
              imagePath: element.path,
            ),
          );
        }
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            BlocListener<ScrapBookBloc, ScrapState>(
                listener: (context, state) {
                  if (state is WebImagePostedToFirebaseStorage) {
                    print("success -- ");
                  }
                  if (state is ScrapBookFailed) {
                    print("state error -- ${state.errorMsg}");
                  }
                },
                child: Container()),
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Center(
              child: GestureDetector(
                onTap: () async {
                  pickImage().then((value) {
                    if (kIsWeb) {
                      context.read<ScrapBookBloc>().add(
                          PostWebImageToFirebaseStorage(
                              webImageList: webImages));
                    }
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Theme.of(context).primaryColor,
                  ),
                  child: Text("Add images"),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
