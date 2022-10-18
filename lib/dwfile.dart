import 'package:eltraingraph/mycolors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'dart:convert';
import 'dart:html' as html;

class WebDownload extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(
        Icons.save_alt,
        color: MyAppColors.FONT_LIGHT_COLOR,
      ),
      title: const Text(
        "Save File",
        style: TextStyle(color: MyAppColors.FONT_LIGHT_COLOR, fontSize: 14),
      ),
      onTap: () {
        if (!kIsWeb) return;
        const text = 'this is the text file';

        // prepare
        final bytes = utf8.encode(text);
        final blob = html.Blob([bytes]);
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.document.createElement('a') as html.AnchorElement
          ..href = url
          ..style.display = 'none'
          ..download = 'some_name.txt';
        html.document.body?.children.add(anchor);

        // download
        anchor.click();

        // cleanup
        html.document.body?.children.remove(anchor);
        html.Url.revokeObjectUrl(url);
      },
    );
  }
}
