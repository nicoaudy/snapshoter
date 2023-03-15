import 'dart:io';

import 'package:cross_file/cross_file.dart';
import 'package:example/constants.dart';
import 'package:example/widgets/dropzone.dart';
import 'package:macos_ui/macos_ui.dart';
// ignore: implementation_imports
import 'package:macos_ui/src/library.dart';

class IndicatorsPage extends StatefulWidget {
  const IndicatorsPage({super.key});

  @override
  State<IndicatorsPage> createState() => _IndicatorsPageState();
}

class _IndicatorsPageState extends State<IndicatorsPage> {
  XFile? uploadFile;
  File? file;

  buildUi() {
    if (uploadFile == null) {
      return DropZone(onFile: (XFile payload) {
        setState(() => uploadFile = payload);
        setState(() => file = File(uploadFile!.path));
      });
    } else {
      return SingleChildScrollView(
        child: Column(
          children: const [Center(child: Text('Hello world'))],
        ),
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
