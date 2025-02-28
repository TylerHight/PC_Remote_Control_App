import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pc_remote_control_app/data/repositories/remote_control_repository.dart';
import 'package:pc_remote_control_app/business_logic/blocs/connection/connection_bloc.dart';
import 'package:pc_remote_control_app/business_logic/blocs/remote_control/remote_control_bloc.dart';
import 'package:pc_remote_control_app/presentation/widgets/feedback_overlay.dart';
import 'package:pc_remote_control_app/presentation/screens/remote_control_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Remote Control',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: MultiRepositoryProvider(
        providers: [
          RepositoryProvider<RemoteControlRepository>(
            create: (context) => RemoteControlRepositoryImpl(),
          ),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider<ConnectionBloc>(
              create: (context) => ConnectionBloc(
                remoteControlRepository: context.read<RemoteControlRepository>(),
              ),
            ),
            BlocProvider<RemoteControlBloc>(
              create: (context) => RemoteControlBloc(
                remoteControlRepository: context.read<RemoteControlRepository>(),
              ),
            ),
          ],
          child: const FeedbackOverlay(
            child: RemoteControlScreen(),
          ),
        ),
      ),
    );
  }
}
