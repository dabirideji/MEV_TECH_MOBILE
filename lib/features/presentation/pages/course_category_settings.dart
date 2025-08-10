import 'package:contentsize_tabbarview/contentsize_tabbarview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:template/app/router/app_router.dart';
import 'package:template/core/utils/colors.dart';
import 'package:template/features/course/logic/course-cubit/course_cubit.dart';
import 'package:template/features/presentation/utilities-class/form_validator.dart';
import 'package:template/features/presentation/utilities-class/mev_tech_utilities.dart';
import 'package:template/features/presentation/widgets/course.dart';

class CourseCategorySettings extends StatefulWidget {
  const CourseCategorySettings({super.key});

  @override
  State<CourseCategorySettings> createState() => _CourseCategorySettingsState();
}

class _CourseCategorySettingsState extends State<CourseCategorySettings>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int tabIndex = 0;

  String? spCategory;
  List<String> categoryItems = List.from(Course.categoryItems);
  String spTag = Course.allTags;
  List<String> selectedCategoryItems = [];
  List<String> selectedTagItems = [];
  List<Map<String, List<String>>> categoryTags = List.from(Course.categoryTags);

  Map<String, bool> toggleTagMap = {};

  TextEditingController txtCategoryName = TextEditingController();
  TextEditingController txtCategoryDescription = TextEditingController();
  TextEditingController txtTagName = TextEditingController();
  TextEditingController txtTagDescription = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _autovalidateForm = false;

  void tabChange(int index) {
    setState(() {
      tabIndex = index;
      _formKey.currentState?.reset();
      if (index == 0) {
        txtTagName.clear();
        txtTagDescription.clear();
      }
      if (index == 1) {
        txtCategoryName.clear();
        txtCategoryDescription.clear();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    return BlocConsumer<CourseCubit, CourseState>(
      listenWhen: (previous, current) {
        if (current is CourseSuccess &&
            current.routeName == AppRouter.courseCategorySettings) {
          if (current.actionMethod == ActionMethod.creating) {
            return true;
          }
          if (current.actionMethod == ActionMethod.created) {
            return true;
          }
          if (current.actionMethod == ActionMethod.notCreated) {
            return true;
          }
          return false;
        }
        return false;
      },
      listener: (context, state) {
        if (state is CourseSuccess &&
            state.actionMethod == ActionMethod.creating) {
          MevTechUtilities.showProgressIndicator(context);
        } else if (state is CourseSuccess &&
            state.actionMethod == ActionMethod.notCreated) {
          MevTechUtilities.hideProgressIndicator(context);

          // context.read<CourseCubit>().clearTempData();
          MevTechUtilities.errorToast(context, state.message ?? '');
          context.read<CourseCubit>().resetRoute();
        } else if (state is CourseSuccess &&
            state.actionMethod == ActionMethod.created) {
          MevTechUtilities.hideProgressIndicator(context);

          MevTechUtilities.successToast(
              context, state.message ?? 'Request Successful');

          context.read<CourseCubit>().resetRoute();
        }
      },
      builder: (context, state) {
        final courseCubit = context.read<CourseCubit>();

        return PopScope(
          onPopInvokedWithResult: (didPop, result) {},
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                'Course Category Settings',
                style: GoogleFonts.poppins(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(12),
              child: Form(
                key: _formKey,
                autovalidateMode: _autovalidateForm
                    ? AutovalidateMode.onUserInteraction
                    : AutovalidateMode.disabled,
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 5.w),
                      decoration: BoxDecoration(
                        color: AppColor.primaryLight2,
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TabBar(
                        labelColor: Colors.green.shade900,
                        indicatorColor: AppColor.primary,
                        unselectedLabelColor: Colors.black54,
                        labelPadding: EdgeInsets.zero,
                        onTap: tabChange,
                        controller: _tabController,
                        labelStyle: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 11,
                        ),
                        tabs: [
                          Tab(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 10.h,
                                horizontal: 20.w,
                              ),
                              decoration: BoxDecoration(
                                color: tabIndex == 0
                                    ? AppColor.primaryFaint
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Text('Course Category'),
                            ),
                          ),
                          Tab(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 10.h,
                                horizontal: 20.w,
                              ),
                              decoration: BoxDecoration(
                                color: tabIndex == 1
                                    ? AppColor.primaryFaint
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Text('Course Tags'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ContentSizeTabBarView(
                        controller: _tabController,
                        children: [
                          categorySection(
                            onSubmit: () {
                              setState(() {
                                _autovalidateForm = true;
                              });
                              if (_formKey.currentState!.validate()) {
                                courseCubit.createCourseCategory(
                                  categoryName: txtCategoryName.text,
                                  categoryDescription:
                                      txtCategoryDescription.text,
                                );
                                _formKey.currentState?.reset();
                                _autovalidateForm = false;
                              }
                            },
                          ),
                          tagSection(
                            onSubmit: () {
                              setState(() {
                                _autovalidateForm = true;
                              });
                              if (_formKey.currentState!.validate()) {
                                courseCubit.createCourseTags(
                                  tagName: txtTagName.text,
                                  tagDescription: txtTagDescription.text,
                                );
                                _formKey.currentState?.reset();
                                _autovalidateForm = false;
                              }
                            },
                          ),
                        ])
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget categorySection({required void Function()? onSubmit}) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 25.h),
          Center(
            child: Text(
              'Select from the category option menu or create new\ncategory by '
              'entering the name and the description',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black38,
              ),
            ),
          ),
          SizedBox(height: 25.h),
          Text(
            'Select Category',
            style: GoogleFonts.poppins(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 5.h),
          dropdownBtn(
            value: spCategory,
            hint: 'Select course category',
            context: context,
            items: categoryItems,
            onChanged: (newValue) {
              final tempValue = spCategory;
              setState(() {
                spCategory = newValue ?? spCategory;
                txtCategoryName.text = spCategory ?? '';
                txtCategoryDescription.text = spCategory ?? '';

                if (newValue != null &&
                    !selectedCategoryItems.contains(newValue)) {
                  if (tempValue != null &&
                      selectedCategoryItems.contains(tempValue)) {
                    selectedCategoryItems.remove(tempValue);
                  }
                  selectedCategoryItems.add(newValue);
                }
              });
            },
          ),
          SizedBox(height: 20.h),
          Text(
            'Category Name',
            style: GoogleFonts.poppins(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 5.h),
          myTextField(
            controller: txtCategoryName,
            hintText: 'Enter Category Name',
          ),
          SizedBox(height: 15.h),
          Text(
            'Category Description',
            style: GoogleFonts.poppins(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 5.h),
          myTextField(
            controller: txtCategoryDescription,
            hintText: 'Enter Category Description',
          ),
          SizedBox(height: 25.h),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: ElevatedButton(
              onPressed: onSubmit,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: const BorderSide(
                    width: 0.9,
                    color: Colors.black45,
                  ),
                ),
                backgroundColor: AppColor.primary,
                foregroundColor: Colors.grey.shade200,
              ),
              child: Container(
                height: 45.h,
                width: double.infinity,
                alignment: Alignment.center,
                child: Text(
                  'Create',
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColor.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget tagSection({required void Function()? onSubmit}) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 25.h),
          Center(
            child: Text(
              'Select from the Tag option menu or create new\nTag by '
              'entering the name and the description',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black38,
              ),
            ),
          ),
          SizedBox(height: 25.h),
          Text(
            'Select Tag',
            style: GoogleFonts.poppins(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              showTags(context);
            },
            label: Text(
              'Select Course Tags',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            icon: const Icon(Icons.arrow_drop_down),
            iconAlignment: IconAlignment.end,
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              backgroundColor: AppColor.primaryLight1,
            ),
          ),
          SizedBox(height: 10.h),
          Wrap(
            children: List.generate(selectedTagItems.length, (index) {
              final tag = selectedTagItems[index];
              return tagWidget(
                  tag: tag,
                  onPressed: () {
                    setState(() {
                      selectedTagItems.removeAt(index);
                      toggleTagMap.removeWhere((key, value) => key == tag);
                      txtTagName.clear();
                      txtTagDescription.clear();
                    });
                  });
            }),
          ),
          SizedBox(height: 20.h),
          Text(
            'Tag Name',
            style: GoogleFonts.poppins(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 5.h),
          myTextField(
            controller: txtTagName,
            hintText: 'Enter tag name',
          ),
          SizedBox(height: 15.h),
          Text(
            'Tag Description',
            style: GoogleFonts.poppins(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 5.h),
          myTextField(
            controller: txtTagDescription,
            hintText: 'Enter tag description',
          ),
          SizedBox(height: 25.h),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: ElevatedButton(
              onPressed: onSubmit,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: const BorderSide(
                    width: 0.9,
                    color: Colors.black45,
                  ),
                ),
                backgroundColor: AppColor.primary,
                foregroundColor: Colors.grey.shade200,
              ),
              child: Container(
                height: 45.h,
                width: double.infinity,
                alignment: Alignment.center,
                child: Text(
                  'Create',
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColor.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget myTextField({
    required String hintText,
    TextEditingController? controller,
    List<TextInputFormatter>? inputFormatters,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffixIcon,
    int maxLines = 1,
  }) {
    return TextFormField(
      cursorColor: AppColor.primary,
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      inputFormatters: inputFormatters,
      style: const TextStyle(
        fontFamily: 'poppins',
      ),
      maxLines: maxLines,
      decoration: InputDecoration(
        isDense: true,
        hintText: hintText,
        hintStyle: TextStyle(
          fontFamily: 'poppins',
          fontSize: 13.sp,
          color: Colors.black38,
        ),
        filled: true,
        suffixIcon: suffixIcon,
        fillColor: Colors.grey.shade100,
        border: const OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(
            color: Colors.black26,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(
            color: Colors.black26,
          ),
        ),
      ),
      validator: FormValidator.customField,
    );
  }

  Widget dropdownBtn({
    required String? value,
    required BuildContext context,
    required List<String> items,
    String? hint,
    void Function(String?)? onChanged,
  }) {
    return Card(
      color: AppColor.primaryLight1,
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          // dropdownColor: Colors.red.shade100,
          isDense: true,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          hint: Text(hint ?? ''),
          menuMaxHeight: MediaQuery.of(context).size.height * 0.5,
          value: value,

          items: items.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: TextStyle(fontSize: 12.sp),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  void showTags(
    BuildContext context,
  ) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter dialogueSetState) {
            return Dialog(
              child: Container(
                height: MediaQuery.sizeOf(context).height * 0.6,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  // shape: BoxShape.rectangle,
                  color: AppColor.primaryLight2,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 10),
                      blurRadius: 15,
                    ),
                  ],
                ),
                child: Column(
                  // mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: ListView.builder(
                        // shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        itemCount: categoryTags.length,
                        itemBuilder: (context, index) {
                          var tagHeader = '';
                          var tags = <String>[];
                          categoryTags[index].forEach((key, value) {
                            tagHeader = key;
                            tags = value;
                          });
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('* $tagHeader'),
                              SizedBox(height: 10.sp),
                              Padding(
                                padding: EdgeInsets.only(left: 8.w),
                                child: Wrap(
                                  children:
                                      List.generate(tags.length, (subIndex) {
                                    final tag = tags[subIndex];
                                    return myCheckBox(
                                      tag: tag,
                                      value: toggleTagMap[tag] ?? false,
                                      onChanged: (newValue) {
                                        dialogueSetState(() {
                                          toggleTagMap[tag] = newValue ?? false;

                                          if (newValue != null &&
                                              newValue == true) {
                                            if (!selectedTagItems
                                                .contains(tag)) {
                                              selectedTagItems.add(tag);
                                              txtTagName.text = tag;
                                              txtTagDescription.text = tag;
                                            }
                                          }

                                          if (newValue == false) {
                                            toggleTagMap.remove(tag);
                                            selectedTagItems.remove(tag);
                                          }
                                        });
                                        setState(() {});
                                      },
                                    );
                                  }),
                                ),
                              ),
                              const Divider(
                                color: Colors.black26,
                                thickness: 0.5,
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget myCheckBox({
    required String tag,
    required bool? value,
    required void Function(bool?)? onChanged,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
      padding: EdgeInsets.only(left: 5.w),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        border: Border.all(
          color: Colors.grey.shade400,
          width: 0.5,
        ),
        borderRadius: BorderRadius.circular(5.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            tag,
            style: TextStyle(fontSize: 12.sp),
          ),
          Checkbox(
            value: value,
            checkColor: Colors.white,
            activeColor: AppColor.primary,
            onChanged: onChanged,
            visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
          ),
        ],
      ),
    );
  }

  Widget tagWidget({required String tag, required void Function()? onPressed}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: ElevatedButton.icon(
        onPressed: null,
        label: Padding(
          padding: EdgeInsets.only(left: 7.w),
          child: Text(
            tag,
            style: TextStyle(
              fontSize: 11.sp,
              color: Colors.black87,
            ),
          ),
        ),
        icon: IconButton(
          onPressed: onPressed,
          icon: const Icon(
            Icons.close,
            color: Colors.red,
          ),
          visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
        ),
        iconAlignment: IconAlignment.end,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: Colors.grey.shade300,
        ),
      ),
    );
  }
}
