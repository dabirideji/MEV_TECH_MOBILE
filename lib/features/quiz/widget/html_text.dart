import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

class HtmlText extends StatelessWidget {
  const HtmlText(this.data, {super.key, this.fontWeight, this.fontSize = 14});
  final String data;
  final FontWeight? fontWeight;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return HtmlWidget(
      formatHtmlTags(data),
      textStyle: TextStyle(fontSize: fontSize.sp, fontWeight: fontWeight),
      customStylesBuilder: (element) {
        if (element.localName == 'u') {
          return {'text-decoration': 'underline', 'font-weight': '700'};
        }
        if (element.localName == 'i') {
          return {
            'font-style': 'italic',
            'font-weight': '700',
          };
        }
        return null;
      },
    );

    // SingleChildScrollView(
    //   child: Html(
    //     data: data,
    //     style: {
    //       'body': Style(
    //         margin: Margins.zero,
    //         padding: HtmlPaddings.zero,
    //         fontSize: FontSize(14.sp),
    //         color: Colors.black,
    //         fontWeight: FontWeight.w500,
    //       ),
    //       'u': Style(textDecoration: TextDecoration.underline),
    //       'i': Style(fontStyle: FontStyle.italic),
    //       'b': Style(fontWeight: FontWeight.bold),
    //       'strong': Style(fontWeight: FontWeight.bold),
    //       'em': Style(fontStyle: FontStyle.italic),
    //       'mark': Style(backgroundColor: Colors.yellow),
    //       'sup': Style(
    //           verticalAlign: VerticalAlign.sup, fontSize: FontSize.smaller),
    //       'sub': Style(
    //           verticalAlign: VerticalAlign.sub, fontSize: FontSize.smaller),
    //     },
    //   ),
    // );
  }
}

String formatHtmlTags(String input) {
  if (input.isEmpty) return input;

  return input
      // Fix underline
      .replaceAll(RegExp(r'<u\s*/>'), '</u>')
      // Fix italic
      .replaceAll(RegExp(r'<i\s*/>'), '</i>')
      // Fix bold
      .replaceAll(RegExp(r'<b\s*/>'), '</b>')
      // Normalize <br> to <br/>
      .replaceAll('<br>', '<br/>')
      // Trim spaces inside tags (just in case)
      .replaceAll(RegExp(r'\s+>'), '>');
}
