import 'dart:io';

import 'package:cross_file/cross_file.dart';
import 'package:example/constants.dart';
import 'package:example/providers/theme_provider.dart';
import 'package:example/widgets/dropzone.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:macos_ui/macos_ui.dart';
// ignore: implementation_imports
import 'package:macos_ui/src/library.dart';

class IndicatorsPage extends ConsumerStatefulWidget {
  const IndicatorsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _IndicatorsPageState();
}

class _IndicatorsPageState extends ConsumerState<IndicatorsPage> {
  XFile? uploadFile;
  File? file;

  buildUi() {
    if (uploadFile == null) {
      return DropZone(onFile: (XFile payload) {
        setState(() => uploadFile = payload);
        setState(() => file = File(uploadFile!.path));
      });
    } else {
      return Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xffe91e63), Color(0xffffc107)],
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(50),
            child: Center(child: Image.file(file!)),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeProvider);

    return MacosScaffold(
      toolBar: ToolBar(
        title: const Text(appName),
        titleWidth: 200.0,
        leading: MacosTooltip(
          message: 'Toggle Sidebar',
          useMousePosition: false,
          child: MacosIconButton(
            icon: MacosIcon(
              CupertinoIcons.sidebar_left,
              color: MacosTheme.brightnessOf(context).resolve(
                const Color.fromRGBO(0, 0, 0, 0.5),
                const Color.fromRGBO(255, 255, 255, 0.5),
              ),
              size: 20.0,
            ),
            boxConstraints: const BoxConstraints(
              minHeight: 20,
              minWidth: 20,
              maxWidth: 48,
              maxHeight: 38,
            ),
            onPressed: () => MacosWindowScope.of(context).toggleSidebar(),
          ),
        ),
        actions: [
          ToolBarIconButton(
            icon: Icon(theme.mode == ThemeMode.light
                ? CupertinoIcons.sun_min
                : CupertinoIcons.moon),
            label: 'Theme',
            showLabel: false,
            onPressed: () {
              ref.read(themeProvider.notifier).changeMode();
            },
          ),
        ],
      ),
      children: [
        ContentArea(
          builder: (context, scrollController) {
            return buildUi();
          },
        ),
      ],
    );
  }
}
