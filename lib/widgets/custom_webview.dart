import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modakbul/themes/styles.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants/assets_path.dart';
import '../constants/style_constants.dart';
import '../themes/color_schemes.dart';

class CustomWebview extends StatefulWidget {
  final String url;
  final String title;

  const CustomWebview({
    required this.url,
    required this.title,
    super.key});

  @override
  State<CustomWebview> createState() => _CustomWebviewState();
}

class _CustomWebviewState extends State<CustomWebview> {
  late final WebViewController controller;
  bool isLoading = true;
  double loadingProgress = 0;

  @override
  void initState() {
    // TODO: implement activate
    super.activate();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (progress) {
            setState(() {
              loadingProgress = progress / 100;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              isLoading = false;
            });
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorSchemes.gray000,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: StyleConstants.defaultPadding),
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: SvgPicture.asset(
                          IconPath.closeWebview,
                          width: 20.r)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        widget.title,
                          style: Theme.of(context)
                              .textTheme
                              .body3
                              .copyWith(color: ColorSchemes.orange100)
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(IconPath.lockWebview,width: 10.r),
                          SizedBox(width: 2.67.w),
                          Text(widget.url,
                            style: Theme.of(context)
                                .textTheme
                                .caption
                                .copyWith(color: ColorSchemes.gray200),)
                        ],
                      )
                    ],
                  ),
                  IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () {

                      },
                      icon: SvgPicture.asset(
                          IconPath.moreHorizontal,
                          width: 20.r)),
                ],
              ),
            ),
            SizedBox(height: 8.h),
            if (isLoading)
              SizedBox(
                height: 2.h,
                child: LinearProgressIndicator(
                  value: loadingProgress,
                  backgroundColor: ColorSchemes.orange200,
                  valueColor: const AlwaysStoppedAnimation<Color>(ColorSchemes.orange100),
                ),
              ),
            Expanded(
              child: WebViewWidget(controller: controller),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: ColorSchemes.gray100, width: 1.w),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: SvgPicture.asset(IconPath.arrowBack),
                    onPressed: () async {
                      if (await controller.canGoBack()) {
                        controller.goBack();
                      }
                    },
                  ),
                  IconButton(
                    icon: SvgPicture.asset(IconPath.lockWebview),
                    onPressed: () {
                      controller.reload();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  }

