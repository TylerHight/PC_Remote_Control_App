import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pc_remote_control_app/business_logic/blocs/theme/theme_bloc.dart';
import 'package:pc_remote_control_app/presentation/theme/app_themes.dart';

class ThemeSettingsScreen extends StatelessWidget {
  const ThemeSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme Settings'),
        elevation: 2,
      ),
      body: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Theme mode selection
                Card(
                  elevation: 3,
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'App Theme',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),
                        _buildThemeModeSelector(context, state),
                      ],
                    ),
                  ),
                ),

                // Color selection
                Card(
                  elevation: 3,
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Accent Color',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),
                        _buildColorSelector(context, state),
                      ],
                    ),
                  ),
                ),

                // Preview
                Card(
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Preview',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),
                        _buildThemePreview(context, state),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildThemeModeSelector(BuildContext context, ThemeState state) {
    return Column(
      children: [
        RadioListTile<ThemeMode>(
          title: const Text('System Theme'),
          value: ThemeMode.system,
          groupValue: state.themeMode,
          onChanged: (value) {
            if (value != null) {
              context.read<ThemeBloc>().add(
                    ThemeChanged(
                      themeMode: value,
                      colorIndex: state.colorIndex,
                    ),
                  );
            }
          },
        ),
        RadioListTile<ThemeMode>(
          title: const Text('Light Theme'),
          value: ThemeMode.light,
          groupValue: state.themeMode,
          onChanged: (value) {
            if (value != null) {
              context.read<ThemeBloc>().add(
                    ThemeChanged(
                      themeMode: value,
                      colorIndex: state.colorIndex,
                    ),
                  );
            }
          },
        ),
        RadioListTile<ThemeMode>(
          title: const Text('Dark Theme'),
          value: ThemeMode.dark,
          groupValue: state.themeMode,
          onChanged: (value) {
            if (value != null) {
              context.read<ThemeBloc>().add(
                    ThemeChanged(
                      themeMode: value,
                      colorIndex: state.colorIndex,
                    ),
                  );
            }
          },
        ),
      ],
    );
  }

  Widget _buildColorSelector(BuildContext context, ThemeState state) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: List.generate(
        AppThemes.primaryColors.length,
        (index) => GestureDetector(
          onTap: () {
            context.read<ThemeBloc>().add(
                  ThemeChanged(
                    themeMode: state.themeMode,
                    colorIndex: index,
                  ),
                );
          },
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppThemes.primaryColors[index],
              shape: BoxShape.circle,
              border: Border.all(
                color: state.colorIndex == index
                    ? Theme.of(context).colorScheme.primary
                    : Colors.transparent,
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppThemes.primaryColors[index].withOpacity(0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: state.colorIndex == index
                ? const Icon(
                    Icons.check,
                    color: Colors.white,
                  )
                : null,
          ),
        ),
      ),
    );
  }

  Widget _buildThemePreview(BuildContext context, ThemeState state) {
    final colorName = AppThemes.getThemeName(state.colorIndex);
    final themeModeName = state.themeMode == ThemeMode.system
        ? 'System'
        : state.themeMode == ThemeMode.light
            ? 'Light'
            : 'Dark';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Current Theme: $colorName $themeModeName',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.palette,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Primary Color',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Elevated Button'),
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: () {},
                child: const Text('Outlined Button'),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () {},
                child: const Text('Text Button'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
