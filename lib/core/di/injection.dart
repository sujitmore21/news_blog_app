import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:news_blog_app/features/auth/data/datasources/auth_local_data_source_impl.dart';
import 'package:news_blog_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:news_blog_app/features/auth/data/datasources/auth_remote_data_source_impl.dart';
import 'package:news_blog_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:news_blog_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:news_blog_app/features/auth/domain/usecases/sign_in_with_email_and_password.dart';
import 'package:news_blog_app/features/news/data/datasources/news_local_data_source_impl.dart';
import 'package:news_blog_app/features/news/data/datasources/news_remote_data_source.dart';
import 'package:news_blog_app/features/news/data/datasources/news_remote_data_source_impl.dart';
import 'package:news_blog_app/features/news/data/repositories/news_repository_impl.dart';
import 'package:news_blog_app/features/news/domain/repositories/news_repository.dart';
import 'package:news_blog_app/features/news/domain/usecases/get_top_headlines.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:news_blog_app/features/auth/data/models/user_model_adapter.dart';

import '../network/network_client.dart';

import '../../features/auth/presentation/bloc/auth_cubit.dart';

import '../../features/news/presentation/bloc/news_cubit.dart';

final sl = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async {
  // Initialize Hive
  await Hive.initFlutter();

  // Register Hive adapters
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(UserModelAdapter());
  }

  // Initialize SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(sharedPreferences);

  // Initialize Network Client
  NetworkClient.init();

  // Register core dependencies
  sl.registerSingleton<NetworkClient>(NetworkClient());

  // Register data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<NewsRemoteDataSource>(
    () => NewsRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<NewsLocalDataSource>(
    () => NewsLocalDataSourceImpl(sl()),
  );

  // Register repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
  );
  sl.registerLazySingleton<NewsRepository>(
    () => NewsRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
  );

  // Register use cases
  sl.registerLazySingleton(() => SignInWithEmailAndPassword(sl()));
  sl.registerLazySingleton(() => SignUpWithEmailAndPassword(sl()));
  sl.registerLazySingleton(() => SignInWithGoogle(sl()));
  sl.registerLazySingleton(() => SignInWithApple(sl()));
  sl.registerLazySingleton(() => SignOut(sl()));
  sl.registerLazySingleton(() => GetCurrentUser(sl()));
  sl.registerLazySingleton(() => IsSignedIn(sl()));
  sl.registerLazySingleton(() => SendPasswordResetEmail(sl()));
  sl.registerLazySingleton(() => UpdateUserProfile(sl()));
  sl.registerLazySingleton(() => DeleteUserAccount(sl()));

  sl.registerLazySingleton(() => GetTopHeadlines(sl()));
  sl.registerLazySingleton(() => GetEverything(sl()));
  sl.registerLazySingleton(() => GetNewsByCategory(sl()));
  sl.registerLazySingleton(() => GetBookmarkedArticles(sl()));
  sl.registerLazySingleton(() => BookmarkArticle(sl()));
  sl.registerLazySingleton(() => RemoveBookmark(sl()));
  sl.registerLazySingleton(() => IsArticleBookmarked(sl()));
  sl.registerLazySingleton(() => GetCachedArticles(sl()));

  // Register BLoC/Cubit
  sl.registerFactory(
    () => AuthCubit(
      signInWithEmailAndPassword: sl(),
      signUpWithEmailAndPassword: sl(),
      signInWithGoogle: sl(),
      signInWithApple: sl(),
      signOut: sl(),
      getCurrentUser: sl(),
      isSignedIn: sl(),
      sendPasswordResetEmail: sl(),
      updateUserProfile: sl(),
      deleteUserAccount: sl(),
    ),
  );

  sl.registerFactory(
    () => NewsCubit(
      getTopHeadlines: sl(),
      getEverything: sl(),
      getNewsByCategory: sl(),
      getBookmarkedArticles: sl(),
      bookmarkArticle: sl(),
      removeBookmark: sl(),
      isArticleBookmarked: sl(),
      getCachedArticles: sl(),
    ),
  );
}
