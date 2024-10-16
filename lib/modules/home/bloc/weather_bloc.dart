import 'package:bloc/bloc.dart';
import '/core/utils/helper/get_current_location.dart';
import '/modules/home/models/weather_list_model.dart';
import '/modules/home/models/weather_model.dart';
import '/modules/home/repository/home_repository.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  WeatherBloc(this.homeRepository) : super(const WeatherState()) {
    on<WeatherEvent>(
      (event, emit) async {
        switch (event) {
          case GetWeatherEvent():
            await _getWeather(emit, event);
        }
      },
    );
  }

  final HomeRepository homeRepository;

  Future<void> _getWeather(
    Emitter<WeatherState> emit,
    GetWeatherEvent event,
  ) async {
    double? lat = event.lat;
    double? lon = event.lon;
    emit(state.copyWith(status: WeatherStatus.loading));
    if (event.needLocation) {
      final (fail, pos) = await determinePosition();
      if (fail != null) {
        emit(
          state.copyWith(status: WeatherStatus.failure, error: fail.message),
        );
        return;
      } else {
        lat = pos!.latitude;
        lon = pos.longitude;
      }
    }
    final (fail, weather) = await homeRepository.getWeather(
      lat: lat,
      lon: lon,
      city: event.city,
    );

    final (fail2, weatherList) = await homeRepository.getWeatherFor5Days(
      lat: lat,
      lon: lon,
      city: event.city,
    );

    if (fail != null || fail2 != null) {
      emit(
        state.copyWith(
          status: WeatherStatus.failure,
          error: fail == null ? fail?.message : fail2!.message,
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: WeatherStatus.success,
          weather: weather,
          weatherList: WeatherListModel.filterUniqueDates(
            weatherList?.list ?? [],
          ),
        ),
      );
    }
  }
}
