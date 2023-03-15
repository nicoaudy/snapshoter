import 'package:example/constants.dart';
import 'package:example/initial_page.dart';
import 'package:example/providers/theme_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_hot_toast/flutter_hot_toast.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:macos_ui/macos_ui.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appTheme = ref.watch(themeProvider);

    return GlobalLoaderOverlay(
      child: MacosApp(
        title: appName,
        theme: MacosThemeData.light(),
        darkTheme: MacosThemeData.dark(),
        themeMode: appTheme.mode,
        debugShowCheckedModeBanner: false,
        home: const InitialPage(),
      ),
    );
  }
}
