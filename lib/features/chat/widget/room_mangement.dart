import 'dart:async';
import 'dart:developer';

import 'package:contentsize_tabbarview/contentsize_tabbarview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mevtech/core/utils/colors.dart';
import 'package:mevtech/features/chat/data/models/bottom_sheet_model.dart';
import 'package:mevtech/features/chat/data/models/chat_user_model.dart';
import 'package:mevtech/features/chat/logic/chat_cubit.dart';
import 'package:mevtech/features/chat/widget/my_textfield.dart';
import 'package:mevtech/features/presentation/utilities-class/form_validator.dart';
import 'package:mevtech/features/user/data/models/user_model.dart';

class RoomMangement {
  static dynamic showAddRoomOption({
    required BuildContext context,
    void Function()? onTapCreateGroup,
    void Function()? onTapCreatePrivateChat,
    void Function()? onTapJoinGroup,
  }) {
    return showModalBottomSheet<dynamic>(
      // isScrollControlled: true,
      backgroundColor: Colors.grey.shade100,
      context: context,
      builder: (builder) {
        return SizedBox(
          // height: MediaQuery.sizeOf(context).height * 0.5,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(7.r),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 35,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(2.5),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: Stack(
                        alignment: AlignmentDirectional.center,
                        children: [
                          Text(
                            'Room Mangement',
                            style: TextStyle(
                              fontSize: 13.sp,
                              // color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Positioned(
                            right: 0,
                            child: IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(
                                Icons.cancel_outlined,
                                color: Colors.black54,
                                size: 30.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              MenuItem(
                title: 'Create Room',
                onTap: onTapCreateGroup,
                color: Colors.blueAccent.shade700,
                icon: Icons.add,
              ),
              SizedBox(height: 15.h),
              MenuItem(
                title: 'Start DM',
                onTap: onTapCreatePrivateChat,
              ),
              SizedBox(height: 30.h),
              SafeArea(
                child: Padding(
                  padding:
                      EdgeInsets.only(bottom: 20.h, right: 10.w, left: 10.w),
                  child: Column(
                    children: [
                      Text(
                        textAlign: TextAlign.center,
                        'Create a general or private room to connect to other community member',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.black54,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 10.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static bool showRoomPasswordField = false;

  static dynamic showCreateRoom({
    required BuildContext context,
    // required bool isPrivate,
    void Function({bool isPrivate, String roomName, String roomPass})?
        onConfirmGroup,
    void Function(String)? onConfirmCommunity,
  }) {
    var initialIndex = 0;

    return showModalBottomSheet<dynamic>(
      isScrollControlled: true,
      backgroundColor: Colors.grey.shade100,
      context: context,
      builder: (builder) {
        return DefaultTabController(
          initialIndex: initialIndex,
          length: 2,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
            child: SizedBox(
              // height: MediaQuery.sizeOf(context).height * 0.5,
              child: StatefulBuilder(
                builder: (context, setState) {
                  return SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.all(7.r),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                          child: Column(
                            children: [
                              Container(
                                width: 35,
                                height: 5,
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(2.5),
                                ),
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: Stack(
                                  alignment: AlignmentDirectional.center,
                                  children: [
                                    Text(
                                      'Create Room',
                                      style: GoogleFonts.poppins(
                                        fontSize: 20.sp,
                                        // color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Positioned(
                                      right: 0,
                                      child: IconButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        icon: Icon(
                                          Icons.cancel_outlined,
                                          color: Colors.black54,
                                          size: 30.sp,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20.h),
                        Text(
                          'Room Type',
                          style: TextStyle(
                            fontSize: 13.sp,
                            // color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Theme(
                          data: Theme.of(context).copyWith(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                          ),
                          child: TabBar(
                            tabAlignment: TabAlignment.center,
                            labelPadding:
                                const EdgeInsets.symmetric(horizontal: 7),
                            splashFactory: NoSplash.splashFactory,
                            overlayColor: WidgetStateProperty.all<Color>(
                              Colors.transparent,
                            ),
                            dividerColor: Colors.transparent,
                            onTap: (value) {
                              setState(() {
                                initialIndex = value;
                              });
                            },
                            isScrollable: true,
                            tabs: [
                              Tab(
                                height: 150.h,
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  padding: EdgeInsets.symmetric(
                                    vertical: 15.h,
                                    horizontal: 30.w,
                                  ),
                                  decoration: BoxDecoration(
                                    color: initialIndex == 0
                                        ? Colors.blue.shade50
                                        : Colors.transparent,
                                    border: Border.all(
                                      color: initialIndex == 0
                                          ? Colors.blueAccent.shade700
                                          : Colors.grey.shade300,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.language,
                                        size: 30.sp,
                                        color: Colors.blueAccent.shade700,
                                      ),
                                      SizedBox(height: 10.h),
                                      Text(
                                        'Community',
                                        style: GoogleFonts.poppins(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      SizedBox(height: 10.h),
                                      Text(
                                        'Public Room',
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Tab(
                                height: 150.h,
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  padding: EdgeInsets.symmetric(
                                    vertical: 15.h,
                                    horizontal: 25.w,
                                  ),
                                  decoration: BoxDecoration(
                                    color: initialIndex == 1
                                        ? AppColor.primaryLight1
                                        : Colors.transparent,
                                    border: Border.all(
                                      color: initialIndex == 1
                                          ? AppColor.primary
                                          : Colors.grey.shade300,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.group_outlined,
                                        size: 30.sp,
                                        color: AppColor.primary,
                                      ),
                                      SizedBox(height: 10.h),
                                      Text(
                                        'Group',
                                        style: GoogleFonts.poppins(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      SizedBox(height: 10.h),
                                      Text(
                                        'Private or Public',
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                            indicatorColor: Colors.transparent,
                          ),
                        ),
                        SizedBox(height: 20.h),
                        ContentSizeTabBarView(
                          // physics: const NeverScrollableScrollPhysics(),
                          children: [
                            CommunityWidget(
                              onConfirm: onConfirmCommunity,
                              onCancel: () {
                                Navigator.pop(context);
                              },
                            ),
                            GroupWidget(
                              onConfirm: onConfirmGroup,
                              onCancel: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  static dynamic showCreatePrivateChat({
    required BuildContext context,
    required ValueNotifier<BottomSheetState<ChatUser>> notifier,
    void Function(String)? onSearch,
    void Function(String)? onSelect,
  }) {
    final txtSearchText = TextEditingController();

    Timer? debounce;

    void onChanged(String query) {
      if (debounce?.isActive ?? false) debounce?.cancel();
      debounce = Timer(const Duration(milliseconds: 500), () {
        onSearch?.call(query.trim());
      });
    }

    return showModalBottomSheet<dynamic>(
      // isScrollControlled: true,
      backgroundColor: Colors.grey.shade100,
      context: context,
      builder: (builder) {
        notifier.value = BottomSheetState();
        return ValueListenableBuilder<BottomSheetState<ChatUser>>(
          valueListenable: notifier,
          builder: (context, state, child) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
              child: SizedBox(
                // height: MediaQuery.sizeOf(context).height * 0.5,
                child: StatefulBuilder(
                  builder: (context, setState) {
                    return Column(
                      // mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.all(7.r),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                          child: Column(
                            children: [
                              Container(
                                width: 35,
                                height: 5,
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(2.5),
                                ),
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: Stack(
                                  alignment: AlignmentDirectional.center,
                                  children: [
                                    Text(
                                      'Start Direct Message',
                                      style: GoogleFonts.poppins(
                                        fontSize: 20.sp,
                                        // color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Positioned(
                                      right: 0,
                                      child: IconButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        icon: Icon(
                                          Icons.cancel_outlined,
                                          color: Colors.black54,
                                          size: 30.sp,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20.h),
                        MyTextField(
                          controller: txtSearchText,
                          hintText: 'Search. users by name or email',
                          filled: true,
                          isDense: false,
                          fillColor: Colors.white,
                          prefixIcon: IconButton(
                            onPressed: null,
                            icon: const Icon(
                              Icons.search,
                              color: Colors.black38,
                            ),
                            style: IconButton.styleFrom(
                              padding: EdgeInsets.zero,
                              visualDensity: const VisualDensity(
                                horizontal: -4,
                                vertical: -4,
                              ),
                            ),
                          ),
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
                          onChanged: (value) {
                            onChanged(value);
                            setState(() {});
                          },
                        ),
                        if (state.isLoading)
                          const Expanded(
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(
                                    color: AppColor.primary,
                                  ),
                                ],
                              ),
                            ),
                          )
                        else if (state.chatUsers.isNotEmpty)
                          Expanded(
                            child: ListView.builder(
                              padding: EdgeInsets.only(top: 20.h),
                              itemCount: state.chatUsers.length,
                              itemBuilder: (context, index) {
                                final user = state.chatUsers[index];
                                return Container(
                                  margin: EdgeInsets.only(bottom: 10.h),
                                  // padding: EdgeInsets.all(10.r),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                      width: 2,
                                    ),
                                  ),
                                  child: ListTile(
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 17.w, vertical: 7.h),
                                    onTap: () => onSelect?.call(user.id),
                                    title: Text(
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      user.username,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13.sp,
                                      ),
                                    ),
                                    subtitle: Text(
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      user.email,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12.sp,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    leading: CircleAvatar(
                                      radius: 25.r,
                                      backgroundColor: AppColor.primary,
                                      child: Text(
                                        user.username[0],
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    trailing: const Icon(
                                      Icons.person_add_alt,
                                      color: AppColor.primary,
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        else if (state.error != null)
                          Expanded(
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.search,
                                    color: Colors.black38,
                                    size: 60,
                                  ),
                                  SizedBox(height: 20.h),
                                  Text(
                                    state.error ?? 'No users Found',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        else
                          Expanded(
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.search,
                                    color: Colors.black38,
                                    size: 60,
                                  ),
                                  SizedBox(height: 20.h),
                                  Text(
                                    'Start typing to search for users',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                      ],
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Widget menuItems() {}
}

class MyBottomSheetWidget extends StatefulWidget {
  const MyBottomSheetWidget({super.key, this.onSearch, this.onSelect});

  final void Function(String)? onSearch;
  final void Function(String)? onSelect;

  @override
  State<MyBottomSheetWidget> createState() => _MyBottomSheetWidgetState();
}

class _MyBottomSheetWidgetState extends State<MyBottomSheetWidget> {
  final txtSearchText = TextEditingController();

  Timer? debounce;

  void onChanged(String query) {
    if (debounce?.isActive ?? false) debounce?.cancel();
    debounce = Timer(const Duration(milliseconds: 500), () {
      widget.onSearch?.call(query.trim());
    });
  }

  @override
  void initState() {
    super.initState();
    context.read<ChatCubit>().users.clear();
  }

  @override
  Widget build(BuildContext context) {
    final chatCubit = context.read<ChatCubit>();
    return BlocConsumer<ChatCubit, ChatState>(
      listener: (context, state) {
        // Handle side-effects, like showing a SnackBar or closing the sheet
        // if (state is MyStateLoaded) {
        //   // Optionally close the sheet after data is loaded
        //   Navigator.of(context).pop();
        // }
      },
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
          child: SizedBox(
            // height: MediaQuery.sizeOf(context).height * 0.5,
            child: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  // mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(7.r),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 35,
                            height: 5,
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(2.5),
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: Stack(
                              alignment: AlignmentDirectional.center,
                              children: [
                                Text(
                                  'Start Direct Message',
                                  style: GoogleFonts.poppins(
                                    fontSize: 20.sp,
                                    // color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Positioned(
                                  right: 0,
                                  child: IconButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: Icon(
                                      Icons.cancel_outlined,
                                      color: Colors.black54,
                                      size: 30.sp,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),
                    MyTextField(
                      controller: txtSearchText,
                      hintText: 'Search. users by name or email',
                      filled: true,
                      isDense: false,
                      fillColor: Colors.white,
                      prefixIcon: IconButton(
                        onPressed: null,
                        icon: const Icon(
                          Icons.search,
                          color: Colors.black38,
                        ),
                        style: IconButton.styleFrom(
                          padding: EdgeInsets.zero,
                          visualDensity: const VisualDensity(
                            horizontal: -4,
                            vertical: -4,
                          ),
                        ),
                      ),
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
                      onChanged: onChanged,
                    ),
                    if (chatCubit.isLoading)
                      const Expanded(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(
                                color: AppColor.primary,
                              ),
                            ],
                          ),
                        ),
                      )
                    else if (chatCubit.users.isNotEmpty)
                      Expanded(
                        child: ListView.builder(
                          padding: EdgeInsets.only(top: 20.h),
                          itemCount: chatCubit.users.length,
                          itemBuilder: (context, index) {
                            final user = chatCubit.users[index];
                            return Container(
                              margin: EdgeInsets.only(bottom: 10.h),
                              // padding: EdgeInsets.all(10.r),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.grey.shade300,
                                  width: 2,
                                ),
                              ),
                              child: ListTile(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 17.w, vertical: 7.h),
                                onTap: () {
                                  log(user.id);
                                },
                                title: Text(
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  user.username,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13.sp,
                                  ),
                                ),
                                subtitle: Text(
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  user.email,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12.sp,
                                    color: Colors.black54,
                                  ),
                                ),
                                leading: CircleAvatar(
                                  radius: 25.r,
                                  backgroundColor: AppColor.primary,
                                  child: Text(
                                    user.username[0],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                trailing: const Icon(
                                  Icons.person_add_alt,
                                  color: AppColor.primary,
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    else if (chatCubit.error != null)
                      Expanded(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.search,
                                color: Colors.black38,
                                size: 60,
                              ),
                              SizedBox(height: 20.h),
                              Text(
                                'No users found matching ${txtSearchText.text}',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      Expanded(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.search,
                                color: Colors.black38,
                                size: 60,
                              ),
                              SizedBox(height: 20.h),
                              Text(
                                'Start typing to search for users',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}

// targetUserId

class MenuItem extends StatelessWidget {
  const MenuItem({
    required this.title,
    super.key,
    this.onTap,
    this.color = AppColor.primary,
    this.icon = Icons.person_add_outlined,
  });
  final String title;
  final void Function()? onTap;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: ElevatedButton.icon(
        onPressed: onTap,
        label: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        icon: Icon(
          icon,
          size: 25,
          color: Colors.white,
        ),
        style: ElevatedButton.styleFrom(
          minimumSize: Size(double.infinity, 60.h),
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}

class Nero extends StatelessWidget {
  Nero({super.key});

  final txtSearchText = TextEditingController();
  final void Function()? onTap = () {};
  final List<ChatUser> users = [];

  void fetchUser() {
    final res = [
      ChatUser(id: 'a', username: 'Nero', email: 'nero@gmail.com'),
      ChatUser(id: 'b', username: 'Yayo', email: 'yayo@gmail.com'),
      ChatUser(id: 'c', username: 'Kunle', email: 'kunle@gmail.com'),
      ChatUser(id: 'd', username: 'Samson', email: 'samson@gmail.com'),
      ChatUser(id: 'e', username: 'Kerry', email: 'kerry@gmail.com'),
      ChatUser(id: 'f', username: 'greg', email: 'greg@gmail.com'),
      ChatUser(id: 'g', username: 'trey', email: 'trey@gmail.com'),
      ChatUser(id: 'h', username: 'friday', email: 'friday@gmail.com'),
    ];
    users.addAll(res);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
        child: SizedBox(
          // height: MediaQuery.sizeOf(context).height * 0.5,
          child: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                // mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(7.r),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 35,
                          height: 5,
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(2.5),
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: Stack(
                            alignment: AlignmentDirectional.center,
                            children: [
                              Text(
                                'Start Direct Message',
                                style: GoogleFonts.poppins(
                                  fontSize: 20.sp,
                                  // color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Positioned(
                                right: 0,
                                child: IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: Icon(
                                    Icons.cancel_outlined,
                                    color: Colors.black54,
                                    size: 30.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                  MyTextField(
                    controller: txtSearchText,
                    hintText: 'Search. users by name or email',
                    filled: true,
                    isDense: false,
                    fillColor: Colors.white,
                    prefixIcon: IconButton(
                      onPressed: null,
                      icon: const Icon(
                        Icons.search,
                        color: Colors.black38,
                      ),
                      style: IconButton.styleFrom(
                        padding: EdgeInsets.zero,
                        visualDensity: const VisualDensity(
                          horizontal: -4,
                          vertical: -4,
                        ),
                      ),
                    ),
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
                  ),
                  if (users.isEmpty)
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.search,
                              color: Colors.black38,
                              size: 60,
                            ),
                            SizedBox(height: 20.h),
                            Text(
                              'Start typing to search for users',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.only(top: 20.h),
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          final user = users[index];
                          return Container(
                            margin: EdgeInsets.only(bottom: 10.h),
                            // padding: EdgeInsets.all(10.r),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.grey.shade300,
                                width: 2,
                              ),
                            ),
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 17.w, vertical: 7.h),
                              onTap: () {
                                log(user.id);
                              },
                              title: Text(
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                user.username,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13.sp,
                                ),
                              ),
                              subtitle: Text(
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                user.email,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12.sp,
                                  color: Colors.black54,
                                ),
                              ),
                              leading: CircleAvatar(
                                radius: 25.r,
                                backgroundColor: AppColor.primary,
                                child: Text(
                                  user.username[0],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              trailing: const Icon(
                                Icons.person_add_alt,
                                color: AppColor.primary,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class GroupWidget extends StatefulWidget {
  const GroupWidget({
    super.key,
    this.onTogglePrivate,
    this.onConfirm,
    this.onCancel,
  });

  final ValueChanged<bool>? onTogglePrivate;
  final void Function({String roomName, String roomPass, bool isPrivate})?
      onConfirm;
  final void Function()? onCancel;

  @override
  State<GroupWidget> createState() => _GroupWidgetState();
}

class _GroupWidgetState extends State<GroupWidget> {
  final _formKey = GlobalKey<FormState>();
  bool isPrivate = false;
  final txtRoomName = TextEditingController();
  final txtRoomPassword = TextEditingController();
  bool _autovalidateForm = false;

  @override
  void dispose() {
    txtRoomName.dispose();
    txtRoomPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Form(
        key: _formKey,
        autovalidateMode: _autovalidateForm
            ? AutovalidateMode.onUserInteraction
            : AutovalidateMode.disabled,
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
              controller: txtRoomName,
              hintText: 'Enter Room Name',
              isDense: false,
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
              validator: FormValidator.customField,
            ),
            SizedBox(height: 10.h),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Password (Optional)',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 5.h),
                MyTextField(
                  controller: txtRoomPassword,
                  hintText: 'Leave empty for no password',
                  filled: true,
                  isDense: false,
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
                  // validator: FormValidator.validatePassword,
                ),
              ],
            ),
            SizedBox(height: 15.h),
            Container(
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                children: [
                  Transform.scale(
                    scale: 0.7,
                    child: Switch(
                      activeColor: AppColor.primary,
                      value: isPrivate,
                      onChanged: (value) {
                        setState(() {
                          isPrivate = value;
                          widget.onTogglePrivate?.call(value);
                        });
                      },
                    ),
                  ),
                  Text(
                    'Make this a private room (invite only)',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30.h),
            SafeArea(
              child: Padding(
                padding: EdgeInsets.only(bottom: 20.h),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: widget.onCancel,
                        label: Text(
                          'Cancel',
                          style: GoogleFonts.poppins(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        icon: Icon(
                          Icons.add,
                          size: 20.sp,
                          color: Colors.black87,
                        ),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(100, 50.h),
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: Colors.grey.shade300,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            _autovalidateForm = true;
                          });
                          if (_formKey.currentState!.validate()) {
                            widget.onConfirm?.call(
                              roomName: txtRoomName.text,
                              roomPass: txtRoomPassword.text,
                              isPrivate: isPrivate,
                            );
                          }
                        },
                        label: Text(
                          'Create Room',
                          style: GoogleFonts.poppins(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        icon: Icon(
                          Icons.add,
                          size: 20.sp,
                          color: Colors.white,
                        ),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(150, 50.h),
                          backgroundColor: AppColor.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
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
      ),
    );
  }
}

class CommunityWidget extends StatefulWidget {
  const CommunityWidget({
    super.key,
    this.onConfirm,
    this.onCancel,
  });

  final void Function(String)? onConfirm;
  final void Function()? onCancel;

  @override
  State<CommunityWidget> createState() => _CommunityWidgetState();
}

class _CommunityWidgetState extends State<CommunityWidget> {
  final txtRoomName = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _autovalidateForm = false;

  @override
  void dispose() {
    txtRoomName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Form(
        key: _formKey,
        autovalidateMode: _autovalidateForm
            ? AutovalidateMode.onUserInteraction
            : AutovalidateMode.disabled,
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
              controller: txtRoomName,
              hintText: 'Enter Room Name',
              isDense: false,
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
              validator: FormValidator.customField,
            ),
            SizedBox(height: 30.h),
            SafeArea(
              child: Padding(
                padding: EdgeInsets.only(bottom: 20.h),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: widget.onCancel,
                        label: Text(
                          'Cancel',
                          style: GoogleFonts.poppins(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        icon: Icon(
                          Icons.add,
                          size: 20.sp,
                          color: Colors.black87,
                        ),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(100, 50.h),
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: Colors.grey.shade300,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            _autovalidateForm = true;
                          });
                          if (_formKey.currentState!.validate()) {
                            widget.onConfirm?.call(txtRoomName.text);
                          }
                        },
                        label: Text(
                          'Create Room',
                          style: GoogleFonts.poppins(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        icon: Icon(
                          Icons.add,
                          size: 20.sp,
                          color: Colors.white,
                        ),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(150, 50.h),
                          backgroundColor: Colors.blueAccent.shade700,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
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
      ),
    );
  }
}

class MyBottomSheet extends StatelessWidget {
  const MyBottomSheet({
    required this.notifier,
    super.key,
    this.onChanged,
    this.txtSearchText,
  });
  final ValueNotifier<BottomSheetState<ChatUser>> notifier;
  final ValueChanged<String>? onChanged;
  final TextEditingController? txtSearchText;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<BottomSheetState<ChatUser>>(
      valueListenable: notifier,
      builder: (context, state, child) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text('Chat Users', style: TextStyle(fontSize: 20)),
              SizedBox(height: 20.h),
              MyTextField(
                controller: txtSearchText,
                hintText: 'Search. users by name or email',
                filled: true,
                isDense: false,
                fillColor: Colors.white,
                prefixIcon: IconButton(
                  onPressed: null,
                  icon: const Icon(
                    Icons.search,
                    color: Colors.black38,
                  ),
                  style: IconButton.styleFrom(
                    padding: EdgeInsets.zero,
                    visualDensity: const VisualDensity(
                      horizontal: -4,
                      vertical: -4,
                    ),
                  ),
                ),
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
                onChanged: onChanged,
              ),
              const SizedBox(height: 16),
              if (state.isLoading) const CircularProgressIndicator(),
              if (state.error != null) Text('Error: ${state.error}'),
              if (!state.isLoading && state.chatUsers.isNotEmpty)
                Expanded(
                  child: ListView.builder(
                    itemCount: state.chatUsers.length,
                    itemBuilder: (context, index) {
                      final user = state.chatUsers[index];
                      return ListTile(title: Text(user.username));
                    },
                  ),
                ),
              if (!state.isLoading &&
                  state.chatUsers.isEmpty &&
                  state.error == null)
                const Text('No chat users found.'),
            ],
          ),
        );
      },
    );
  }
}
