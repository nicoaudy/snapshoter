import 'dart:io';

import 'package:cross_file/cross_file.dart';
import 'package:example/constants.dart';
import 'package:example/mock.dart';
import 'package:example/providers/editor_provider.dart';
import 'package:example/providers/theme_provider.dart';
import 'package:example/widgets/dropzone.dart';
import 'package:example/widgets/layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hot_toast/flutter_hot_toast.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:screenshot/screenshot.dart';
import 'package:super_clipboard/super_clipboard.dart';

class EditorPage extends ConsumerStatefulWidget {
  const EditorPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditorPageState();
}

class _EditorPageState extends ConsumerState<EditorPage> {
  ScreenshotController screenshotController = ScreenshotController();

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
      return Screenshot(
        controller: screenshotController,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradients[editor.background],
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
                  boxShadow: [
                    BoxShadow(
                      color: editor.shadow == 0
                          ? Colors.transparent
                          : Colors.black87,
                      blurRadius: editor.shadow *
                          10, // has the effect of softening the shadow
                      spreadRadius: editor
                          .shadow, // has the effect of extending the shadow
                      offset: const Offset(5.0, 5.0),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      );
    }
  }

  void copyImage(Uint8List image) async {
    final item = DataWriterItem(suggestedName: 'snapshooter.png');
    item.add(Formats.png(image));
    await ClipboardWriter.instance.write([item]);
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      onScreenshot: () {
        screenshotController.capture().then((Uint8List? image) async {
          if (image != null) {
            copyImage(image);

            context.loaderOverlay.show(
              widget: FlutterHotToast.success(
                context,
                height: 60,
                width: 500,
                alignment: Alignment.topRight,
                label: const Text(
                  'Image has been copied to clipboard',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            );
          }
        }).catchError((onError) {
          debugPrint(onError);
        });
      },
      child: MacosScaffold(
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
                    ref
                        .read(themeProvider.notifier)
                        .changeMode(ThemeMode.light);
                  },
                ),
                MacosPulldownMenuItem(
                  label: 'System',
                  title: const Text('System'),
                  onTap: () {
                    ref
                        .read(themeProvider.notifier)
                        .changeMode(ThemeMode.system);
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
      ),
    );
  }
}
