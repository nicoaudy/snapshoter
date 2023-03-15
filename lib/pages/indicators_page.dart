import 'dart:io';

import 'package:cross_file/cross_file.dart';
import 'package:example/constants.dart';
import 'package:example/providers/editor_provider.dart';
import 'package:example/providers/theme_provider.dart';
import 'package:example/widgets/dropzone.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:macos_ui/macos_ui.dart';

class IndicatorsPage extends ConsumerStatefulWidget {
  const IndicatorsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _IndicatorsPageState();
}

class _IndicatorsPageState extends ConsumerState<IndicatorsPage> {
  XFile? uploadFile;
  File? file;

  buildUi() {
    final editor = ref.watch(editorProvider);

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
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width / editor.zoom,
              height: MediaQuery.of(context).size.height / editor.zoom,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: FileImage(file!),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(editor.radius),
              ),
            ),
          )
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
          if (file != null)
            ToolBarIconButton(
              label: 'Delete',
              icon: const MacosIcon(
                CupertinoIcons.trash,
              ),
              showLabel: false,
              onPressed: () {
                setState(() {
                  uploadFile = null;
                  file = null;
                });
              },
            ),
          const ToolBarDivider(),
          ToolBarPullDownButton(
            label: 'Theme',
            icon: CupertinoIcons.moon_circle,
            items: [
              MacosPulldownMenuItem(
                label: 'Dark',
                title: const Text('Dark'),
                onTap: () {
                  ref.read(themeProvider.notifier).changeMode(ThemeMode.dark);
                },
              ),
              MacosPulldownMenuItem(
                label: 'Light',
                title: const Text('Light'),
                onTap: () {
                  ref.read(themeProvider.notifier).changeMode(ThemeMode.light);
                },
              ),
              MacosPulldownMenuItem(
                label: 'System',
                title: const Text('System'),
                onTap: () {
                  ref.read(themeProvider.notifier).changeMode(ThemeMode.system);
                },
              ),
            ],
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
