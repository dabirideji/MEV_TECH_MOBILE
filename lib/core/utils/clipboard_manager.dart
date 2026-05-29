import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mevtech/features/presentation/utilities-class/mev_tech_utilities.dart';

class ClipboardManager {
  static void copyToClipboard(String text, BuildContext context) {
    Clipboard.setData(ClipboardData(text: text));
    MevTechUtilities.backgroundToast('Copied Successfully', context);
  }
}
