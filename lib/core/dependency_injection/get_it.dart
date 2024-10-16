import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '/core/utils/dio/dio_helper.dart';
import '/modules/home/bloc/weather_bloc.dart';
import '/modules/home/repository/home_repository.dart';

/// GetIt is a simple service locator for Dart and Flutter projects. [GetIt]
final gi = GetIt.instance;

/// init GetIt
Future<void> initGetIt() async {
  // init isar
  // final isar = await Isar.open(
  //   [
  //     AuthModelSchema,
  //   ],
  //   directory: await getApplicationDocumentsDirectory().then(
  //     (value) => value.path,
  //   ),
  // );

  gi
    // helpers

    // blocs
    ..registerFactory(() => WeatherBloc(gi()))

    // data ( local + remote) repositories Objects
    ..registerLazySingleton(() => HomeRepository(dio: gi()))
    ..registerLazySingleton<Dio>(() => DioHelper(Dio()).init());
  // ..registerLazySingleton<Isar>(() => isar);
}
