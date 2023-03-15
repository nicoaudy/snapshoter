import 'package:cross_file/cross_file.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:example/utils.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

class DropZone extends StatefulWidget {
  final Function(XFile file) onFile;

  const DropZone({super.key, required this.onFile});

  @override
  DropZoneState createState() => DropZoneState();
}

class DropZoneState extends State<DropZone> {
  bool _dragging = false;

  @override
  Widget build(BuildContext context) {
    return DropTarget(
      onDragDone: (detail) async {
        final allowed = ['.jpg', '.jpeg', '.png'];
        final ext = extension(detail.files.first.path.toLowerCase());
        final ok = allowed.any((String value) => value.contains(ext));

        if (ok) {
          widget.onFile(detail.files.first);
        } else {
          errorToast(context, 'File is not an image', 350);
        }
      },
      onDragUpdated: (details) {},
      onDragEntered: (detail) {
        setState(() {
          _dragging = true;
        });
      },
      onDragExited: (detail) {
        setState(() {
          _dragging = false;
        });
      },
      child: Container(
        color: _dragging ? Colors.blue.withOpacity(0.4) : Colors.grey.shade200,
        child: const Center(child: Text('Drop image here')),
      ),
    );
  }
}
