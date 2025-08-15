import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:isp_app/core/di/service_locator.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeState(isDarkMode: true)) {
    on<ToggleThemeEvent>(_onToggleTheme);
  }

  void _onToggleTheme(ToggleThemeEvent event, Emitter<ThemeState> emit) async {
    final newState = ThemeState(isDarkMode: !state.isDarkMode);
    await getIt<SharedPreferences>().setBool('isDarkMode', newState.isDarkMode);
    emit(newState);
  }
}