import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/theme/app_theme.dart';
import 'core/utils/app_storage.dart';
import 'presentation/providers/theme_provider.dart';
import 'presentation/screens/navigation_shell.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive before runApp to prevent flash
  await initializeApp();
  
  runApp(const ProviderScope(child: SyntropheApp()));
}

class SyntropheApp extends ConsumerStatefulWidget {
  const SyntropheApp({super.key});
  
  @override
  ConsumerState<SyntropheApp> createState() => _SyntropheAppState();
}

class _SyntropheAppState extends ConsumerState<SyntropheApp> {
  ThemeMode _themeMode = ThemeMode.light;
  
  @override
  void initState() {
    super.initState();
    _loadTheme();
  }
  
  void _loadTheme() {
    final savedTheme = getSavedThemeMode();
    setState(() {
      _themeMode = savedTheme;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: MaterialApp(
        key: ValueKey(_themeMode),
        title: 'Syntrophe',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: _themeMode,
        home: _AppContent(themeMode: _themeMode),
      ),
    );
  }
}

class _AppContent extends ConsumerWidget {
  final ThemeMode themeMode;
  
  const _AppContent({required this.themeMode});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Sync theme with Riverpod provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(themeModeProvider.notifier).setThemeMode(themeMode);
    });
    
    return NavigationShell();
  }
}
