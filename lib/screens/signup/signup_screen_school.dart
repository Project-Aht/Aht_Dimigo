import 'dart:typed_data';
import 'package:aht_dimigo/functions/call_api.dart';
import 'package:aht_dimigo/screens/signup/signup_screen_grade.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../themes/color_theme.dart';
import '../../themes/text_theme.dart';
import '../../widgets/custom_text.dart';

class SignUpScreenSchool extends StatefulWidget {
  final String email, pw;
  final Uint8List? image;
  const SignUpScreenSchool({
    Key? key,
    required this.email,
    required this.pw,
    required this.image,
  }) : super(key: key);

  @override
  State<SignUpScreenSchool> createState() => _SignUpScreenSchoolState();
}

class _SignUpScreenSchoolState extends State<SignUpScreenSchool> {
  late API api;
  String schoolName = '';
  int? maxGrade;
  FocusNode focus = FocusNode();
  final TextEditingController _controller = TextEditingController();
  bool selected = false;
  late bool loading;

  List<Map<String, String>> results = [];

  void updateResults(String input) {
    results = api.schools
        .where((school) =>
            school['name']!.toLowerCase().contains(input.toLowerCase()))
        .toList();
  }

  @override
  void initState() {
    super.initState();
    api = Get.find<API>();
    loading = api.loading;
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(
          left: screenWidth / 390 * 32,
          right: screenWidth / 390 * 32,
          bottom: screenHeight / 844 * 43,
        ),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: screenHeight / 844 * 72,
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Icon(
                      Icons.arrow_back,
                      size: screenWidth / 390 * 32,
                    ),
                  ),
                  SizedBox(
                    height: screenHeight / 844 * 22,
                  ),
                  const CustomText(
                    text: '학교 설정',
                    style: AhtTextTheme.SignUpHeadline,
                  ),
                  SizedBox(
                    height: screenHeight / 844 * 8,
                  ),
                  const CustomText(
                    text: '사용자님이 재학중인 학교를\n선택해주세요.',
                    style: AhtTextTheme.SignUpText,
                  ),
                  SizedBox(
                    height: screenHeight / 844 * 35,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          child: CustomTextField(
                            maxLines: 1,
                            textInputAction: TextInputAction.done,
                            onChanged: (p0) async {
                              schoolName = p0;
                              selected = false;
                              if (schoolName.isEmpty) {
                                results = [];
                                setState(() {});
                              } else {
                                updateResults(schoolName);
                                setState(() {});
                              }
                            },
                            controller: _controller,
                            focusNode: focus,
                            style: AhtTextTheme.SignUpSchoolSearch,
                            decoration: const InputDecoration(
                              hintText: '학교를 검색해주세요',
                              hintStyle: AhtTextTheme.LoginHintText,
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(bottom: 15),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth / 390 * 11,
                        ),
                        child: GestureDetector(
                          child: Icon(
                            Icons.search,
                            size: screenWidth / 390 * 21,
                            color: (selected)
                                ? Colors.black
                                : const Color(0xFFCCCCCC),
                          ),
                        ),
                      )
                    ],
                  ),
                  Container(
                    height: screenHeight / 844 * 2,
                    color: (selected) ? Colors.black : const Color(0xFFD7D7D7),
                  ),
                  SizedBox(
                    height: screenHeight / 844 * 19,
                  ),
                  SizedBox(
                    height: screenHeight / 844 * 400,
                    child: GetBuilder<API>(
                      builder: (_) {
                        api = _;
                        if (api.loading) {
                          if (schoolName.isEmpty) {
                            return const SizedBox();
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        } else {
                          if (loading) {
                            loading = false;
                            updateResults(schoolName);
                          }
                          return ListView.separated(
                            padding: EdgeInsets.zero,
                            itemBuilder: (context, index) => Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: screenWidth / 390 * 4,
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    schoolName = results[index]['name']!;
                                    _controller.text = schoolName;
                                    maxGrade =
                                        int.parse(results[index]['maxGrade']!);
                                    results = [results[index]];
                                    focus.unfocus();
                                    selected = true;
                                  });
                                },
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CustomText(
                                          text: results[index]['name']!,
                                          style: AhtTextTheme.SignUpSchool,
                                        ),
                                        CustomText(
                                          text: results[index]['address']!,
                                          style:
                                              AhtTextTheme.SignUpSchoolAddress,
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Icon(
                                          Icons.outlined_flag_rounded,
                                          color: const Color(0xFF8B8C8B),
                                          size: screenWidth / 390 * 24,
                                        ),
                                        SizedBox(
                                            height: screenHeight / 844 * 5),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            separatorBuilder: (context, index) => Column(
                              children: [
                                /*SizedBox(
                                height: screenHeight / 844 * 26,
                              ),*/
                                Container(
                                  height: screenHeight / 844 * 20,
                                  width: screenWidth / 390 * 20,
                                  decoration:
                                      const BoxDecoration(color: Colors.red),
                                )
                              ],
                            ),
                            itemCount: results.length,
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            if (!focus.hasFocus)
              GestureDetector(
                onTap: () async {
                  if (selected) {
                    Get.to(
                      () => SignUpScreenGrade(
                        email: widget.email,
                        pw: widget.pw,
                        school: schoolName,
                        image: widget.image,
                        maxGrade: maxGrade!,
                      ),
                      duration: Duration.zero,
                    );
                  } else {
                    Get.snackbar(
                      '',
                      '학교를 선택해주세요.',
                    );
                  }
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      height: screenHeight / 844 * 52,
                      decoration: BoxDecoration(
                        color: AhtColors.Main_Color,
                        borderRadius:
                            BorderRadius.circular(screenHeight / 844 * 10),
                      ),
                      child: Center(
                        child: CustomText(
                          text: '다음',
                          style: AhtTextTheme.ButtonText.copyWith(fontSize: 16),
                        ),
                      ),
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
