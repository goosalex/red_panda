import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:rive/rive.dart' as rive;

import 'l10n/l10n.dart';
import 'platform/device.dart';
import 'storage/note_store.dart';
import 'ui/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await rive.RiveNative.init();
  } catch (_) {
    // Placeholder mascot works without the Rive runtime.
  }
  await Device.load();
  final store = await NoteStore.open();
  runApp(RedPandaApp(store: store));
}

class RedPandaApp extends StatelessWidget {
  const RedPandaApp({super.key, required this.store});
  final NoteStore store;

  static const _seed = Color(0xFFD9541E); // red panda fur

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (c) => c.l10n.appTitle,
      debugShowCheckedModeBanner: false,
      supportedLocales: appLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(colorSchemeSeed: _seed, useMaterial3: true),
      darkTheme: ThemeData(colorSchemeSeed: _seed, brightness: Brightness.dark, useMaterial3: true),
      home: HomeScreen(store: store),
    );
  }
}
