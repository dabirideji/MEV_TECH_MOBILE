import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template/core/utils/colors.dart';
import 'package:template/features/chat/widget/my_textfield.dart';
import 'package:template/features/presentation/utilities-class/form_validator.dart';

class RoomMangement {
  static dynamic showAddRoomOption({
    required BuildContext context,
    void Function()? onTapCreateGroup,
    void Function()? onTapCreatePrivateChat,
    void Function()? onTapJoinGroup,
  }) {
    return showModalBottomSheet<dynamic>(
        isScrollControlled: true,
        backgroundColor: Colors.grey.shade100,
        context: context,
        builder: (builder) {
          return SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.8,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(7.r),
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: AppColor.primary,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 35,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(2.5),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Room Mangement',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                MenuItem(
                  title: 'Create Group',
                  onTap: onTapCreateGroup,
                ),
                SizedBox(height: 10.h),
                MenuItem(
                  title: 'Create Private Chat',
                  onTap: onTapCreatePrivateChat,
                ),
                const Spacer(),
                SafeArea(
                  child: Padding(
                    padding:
                        EdgeInsets.only(bottom: 20.h, right: 10.w, left: 10.w),
                    child: Column(
                      children: [
                        Text(
                          'Have an Invite already?',
                          style: TextStyle(
                            fontSize: 13.sp,
                            // color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        ElevatedButton(
                          onPressed: onTapJoinGroup,
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            backgroundColor: AppColor.primary,
                            foregroundColor: Colors.white,
                          ),
                          child: Container(
                            height: 40,
                            width: double.infinity,
                            alignment: Alignment.center,
                            child: Text(
                              'Join a Room',
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  static bool showRoomPasswordField = false;

  static dynamic showCreateRoom({
    required BuildContext context,
    // required bool isPrivate,
    void Function(String, String?, {bool isPrivate})? onConfirm,
  }) {
    showRoomPasswordField = false;
    final roomName = TextEditingController();
    final roomPassword = TextEditingController();
    var isPrivate = false;
    return showModalBottomSheet<dynamic>(
        isScrollControlled: true,
        backgroundColor: Colors.grey.shade100,
        context: context,
        builder: (builder) {
          return SizedBox(
            // height: MediaQuery.sizeOf(context).height * 0.8,
            child: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(7.r),
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: AppColor.primary,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 35,
                            height: 5,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(2.5),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Create Room',
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 20.h),
                          Text(
                            'Room Name',
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 5.h),
                          MyTextField(
                            controller: roomName,
                            keyboardType: TextInputType.number,
                            hintText: 'Enter Room Name',

                            filled: true,
                            fillColor: Colors.white,
                            suffixIcon: IconButton(
                              onPressed: null,
                              icon: const Text(''),
                              style: IconButton.styleFrom(
                                padding: EdgeInsets.zero,
                                visualDensity: const VisualDensity(
                                  horizontal: -4,
                                  vertical: -4,
                                ),
                              ),
                            ),
                            // validator: FormValidator.validatePhoneNumber,
                          ),
                          SizedBox(height: 10.h),
                          if (showRoomPasswordField)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Room Password',
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 5.h),
                                MyTextField(
                                  controller: roomPassword,
                                  keyboardType: TextInputType.visiblePassword,
                                  hintText: 'Enter Room Password',
                                  filled: true,
                                  fillColor: Colors.white,
                                  suffixIcon: IconButton(
                                    onPressed: null,
                                    icon: const Text(''),
                                    style: IconButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      visualDensity: const VisualDensity(
                                        horizontal: -4,
                                        vertical: -4,
                                      ),
                                    ),
                                  ),
                                  validator: FormValidator.validatePassword,
                                ),
                              ],
                            )
                          else
                            ElevatedButton.icon(
                              onPressed: () {
                                setState(() {
                                  showRoomPasswordField = true;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                backgroundColor: Colors.white,
                                foregroundColor: AppColor.primary,
                              ),
                              icon: const Icon(
                                Icons.add,
                                color: AppColor.primary,
                              ),
                              label: const Text('Add Password to room'),
                            ),
                          Row(
                            children: [
                              Text(
                                'Make Room Private',
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Transform.scale(
                                scale: 0.7,
                                child: Switch(
                                  value: isPrivate,
                                  onChanged: (value) {
                                    setState(() {
                                      isPrivate = value;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          SafeArea(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  bottom: 20.h, right: 10.w, left: 10.w),
                              child: ElevatedButton(
                                onPressed: () => onConfirm?.call(
                                  roomName.text,
                                  roomPassword.text,
                                  isPrivate: isPrivate,
                                ),
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  backgroundColor: AppColor.primary,
                                  foregroundColor: Colors.white,
                                ),
                                child: Container(
                                  height: 40,
                                  width: double.infinity,
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Confirm',
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        });
  }

  static dynamic showCreatePrivateChat({
    required BuildContext context,
    required TextEditingController targetUserId,
  }) {
    showRoomPasswordField = false;
    return showModalBottomSheet<dynamic>(
        isScrollControlled: true,
        backgroundColor: Colors.grey.shade100,
        context: context,
        builder: (builder) {
          return SizedBox(
            // height: MediaQuery.sizeOf(context).height * 0.8,
            child: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(7.r),
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: AppColor.primary,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 35,
                            height: 5,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(2.5),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Create Private Chat',
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 20.h),
                          Text(
                            'User ID',
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 5.h),
                          MyTextField(
                            controller: targetUserId,
                            keyboardType: TextInputType.number,
                            hintText: 'Enter UserID',

                            filled: true,
                            fillColor: Colors.white,
                            suffixIcon: IconButton(
                              onPressed: null,
                              icon: const Text(''),
                              style: IconButton.styleFrom(
                                padding: EdgeInsets.zero,
                                visualDensity: const VisualDensity(
                                  horizontal: -4,
                                  vertical: -4,
                                ),
                              ),
                            ),
                            // validator: FormValidator.validatePhoneNumber,
                          ),
                          SizedBox(height: 10.h),
                          SafeArea(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  bottom: 20.h, right: 10.w, left: 10.w),
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  backgroundColor: AppColor.primary,
                                  foregroundColor: Colors.white,
                                ),
                                child: Container(
                                  height: 40,
                                  width: double.infinity,
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Create Chat',
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        });
  }

  // Widget menuItems() {}
}

// targetUserId

class MenuItem extends StatelessWidget {
  const MenuItem({required this.title, super.key, this.onTap});
  final String title;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.w),
      padding: EdgeInsets.all(8.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.grey.shade300,
          width: 0.5,
        ),
      ),
      child: Column(
        children: [
          ListTile(
            title: Text(
              title,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 15),
            onTap: onTap,
          ),
        ],
      ),
    );
  }
}
