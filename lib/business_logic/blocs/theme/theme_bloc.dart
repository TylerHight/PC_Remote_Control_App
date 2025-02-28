import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Events
abstract class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object?> get props => [];
}

class ThemeChanged extends ThemeEvent {
  final ThemeMode themeMode;
  final int colorIndex;

  const ThemeChanged({required this.themeMode, this.colorIndex = 0});

  @override
  List<Object?> get props => [themeMode, colorIndex];
}

class LoadTheme extends ThemeEvent {}

// State
class ThemeState extends Equatable {
  final ThemeMode themeMode;
  final int colorIndex;

  const ThemeState({
    this.themeMode = ThemeMode.system,
    this.colorIndex = 0,
  });

  ThemeState copyWith({
    ThemeMode? themeMode,
    int? colorIndex,
  }) {
    return ThemeState(
      themeMode: themeMode ?? this.themeMode,
      colorIndex: colorIndex ?? this.colorIndex,
    );
  }

  @override
  List<Object?> get props => [themeMode, colorIndex];
}

// BLoC
class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(const ThemeState()) {
    on<ThemeChanged>(_onThemeChanged);
    on<LoadTheme>(_onLoadTheme);
  }

  Future<void> _onThemeChanged(ThemeChanged event, Emitter<ThemeState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme_mode', event.themeMode.toString());
    await prefs.setInt('color_index', event.colorIndex);
    
    emit(state.copyWith(
      themeMode: event.themeMode,
      colorIndex: event.colorIndex,
    ));
  }

  Future<void> _onLoadTheme(LoadTheme event, Emitter<ThemeState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final themeModeString = prefs.getString('theme_mode') ?? ThemeMode.system.toString();
    final colorIndex = prefs.getInt('color_index') ?? 0;
    
    ThemeMode themeMode;
    if (themeModeString == ThemeMode.dark.toString()) {
      themeMode = ThemeMode.dark;
    } else if (themeModeString == ThemeMode.light.toString()) {
      themeMode = ThemeMode.light;
    } else {
      themeMode = ThemeMode.system;
    }
    
    emit(state.copyWith(
      themeMode: themeMode,
      colorIndex: colorIndex,
    ));
  }
}
