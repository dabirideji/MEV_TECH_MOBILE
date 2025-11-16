import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template/core/utils/colors.dart';
// import 'package:swipe_to/swipe_to.dart';

// import 'package:whatsapp_ui/common/utils/colors.dart';
// import 'package:whatsapp_ui/common/enums/message_enum.dart';
// import 'package:whatsapp_ui/features/chat/widgets/display_text_image_gif.dart';

class MyMessageCard extends StatelessWidget {
  final String message;
  final String date;
  // final MessageEnum type;
  final VoidCallback onLeftSwipe;
  final String repliedText;
  final String username;
  // final MessageEnum repliedMessageType;
  final bool isSeen;

  const MyMessageCard({
    Key? key,
    required this.message,
    required this.date,
    // required this.type,
    required this.onLeftSwipe,
    required this.repliedText,
    required this.username,
    // required this.repliedMessageType,
    required this.isSeen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isReplying = repliedText.isNotEmpty;

    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 45,
        ),
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          color: AppColor.primary,
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Stack(
            children: [
              Padding(
                padding:
                    // type == MessageEnum.text
                    //     ?
                    EdgeInsets.only(
                  left: 10.w,
                  right: 30.w,
                  top: 5.h,
                  bottom: 20.h,
                )
                // : const EdgeInsets.only(
                //     left: 5,
                //     top: 5,
                //     right: 5,
                //     bottom: 25,
                //   ),
                ,
                child: Column(
                  children: [
                    if (isReplying) ...[
                      Text(
                        username,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Container(
                        padding: EdgeInsets.all(10.r),
                        decoration: BoxDecoration(
                          color: AppColor.primary,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text('Gif'),
                        // DisplayTextImageGIF(
                        //   message: repliedText,
                        //   type: repliedMessageType,
                        // ),
                      ),
                      const SizedBox(height: 8),
                    ],
                    // DisplayTextImageGIF(
                    //   message: message,
                    //   type: type,
                    // ),
                    Text(
                      message,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 13.sp,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 4,
                right: 10,
                child: Row(
                  children: [
                    Text(
                      date,
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Icon(
                      isSeen ? Icons.done_all : Icons.done,
                      size: 20,
                      color: isSeen ? Colors.blue : Colors.white60,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
