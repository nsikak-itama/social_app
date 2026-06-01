import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/cubits/profile_cubits.dart';
import 'package:social_app/features/posts/data/firebase_post_repo.dart';
import 'package:social_app/features/posts/presentation/cubits/post_cubits.dart';
import 'package:social_app/features/search/cubits/search_cubits.dart';
import 'package:social_app/features/search/firebase_search_repo.dart';
import 'package:social_app/features/storage/firebase_storage_repo.dart';
import 'package:social_app/firebase_options.dart';
import 'package:social_app/services/auth/auth_gate.dart';
import 'package:social_app/services/auth/auth_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:social_app/theme/theme-provider.dart';
import 'package:social_app/services/profile/profile_firebase_repo.dart';
import 'package:social_app/theme/theme_cubits.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        // ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => AuthService()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        BlocProvider(create: (context) => ProfileCubit(storageRepo: FirebaseStorageRepo(), profileRepo: FirebaseProfileRepo())),
        BlocProvider(create: (context) => PostCubit(postRepo: FirebasePostRepo(), storageRepo: FirebaseStorageRepo())),
        BlocProvider(create: (context) => SearchCubits(searchRepo: FirebaseSearchRepo())),
        BlocProvider(create: (context) => ThemeCubit())
  ],
  child: MyApp(),
  ));
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthGate(),
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}