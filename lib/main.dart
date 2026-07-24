import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:issues_tracking/app.dart';
import 'package:issues_tracking/core/init_dependencies.dart';
import 'package:issues_tracking/features/app/presentation/cubit/app_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Supabase Initialization
  await Supabase.initialize(
    url: 'https://jadgeemsdhhtrgnieumt.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImphZGdlZW1zZGhodHJnbmlldW10Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODQ4MTE2MjUsImV4cCI6MjEwMDM4NzYyNX0.GaHm8zhNVXemvqZOsXApTocqLJquOFmDE5Dv9bfMLUw',
  );

  // Anonymous Sign-in
  final supabase = Supabase.instance.client;
  if (supabase.auth.currentUser == null) {
    try {
      await supabase.auth.signInAnonymously();
    } catch (e) {
      debugPrint('Anonymous sign-in failed (non-critical): $e');
    }
  }

  // Core Dependencies
  await initDependencies();

  runApp(
    BlocProvider(
      create: (context) => sl<AppCubit>()..init(),
      child: const Application(),
    ),
  );
}
