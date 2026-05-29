import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:swipe_to/swipe_to.dart';

// import 'package:whatsapp_ui/common/utils/colors.dart';
// import 'package:whatsapp_ui/common/enums/message_enum.dart';
// import 'package:whatsapp_ui/features/chat/widgets/display_text_image_gif.dart';

class SenderMessageCard extends StatelessWidget {
  const SenderMessageCard({
    Key? key,
    required this.message,
    required this.date,
    // required this.type,
    required this.onRightSwipe,
    required this.repliedText,
    required this.username,
    // required this.repliedMessageType,
  }) : super(key: key);
  final String message;
  final String date;
  // final MessageEnum type;
  final VoidCallback onRightSwipe;
  final String repliedText;
  final String username;
  // final MessageEnum repliedMessageType;

  @override
  Widget build(BuildContext context) {
    final isReplying = repliedText.isNotEmpty;

    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 45,
        ),
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          color: Colors.white,
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
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.grey,
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
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                        fontSize: 13.sp,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 2,
                right: 10,
                child: Text(
                  date,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
