import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';

Future<void> launchCustomTab(BuildContext context, {
  required String url,
  required String title,
}) async {
    await launch(
      url,
      customTabsOption: CustomTabsOption(
        toolbarColor: Colors.white,
        enableDefaultShare: true,
        enableUrlBarHiding: true,
        showPageTitle: true,
        animation: CustomTabsSystemAnimation.slideIn(),
      ),
      safariVCOption: const SafariViewControllerOption(
        preferredBarTintColor: Colors.white,
        preferredControlTintColor: Colors.black,
        barCollapsingEnabled: true,
        entersReaderIfAvailable: false,
        dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
      ),
    );
}