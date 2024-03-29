import 'dart:math';

import 'package:aht_dimigo/screens/register_exam_screen_first.dart';
import 'package:flutter/material.dart';
import 'package:aht_dimigo/themes/color_theme.dart';
import '../firebase/exam.dart';
import '../firebase/instance.dart';
import '../widgets/custom_text.dart';
import 'package:aht_dimigo/widgets/subject_selection_box.dart';
import 'package:aht_dimigo/widgets/main_exam_box.dart';
import 'package:get/get.dart';

Instance _instance = Get.find<Instance>();

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, dynamic> _userInfo = _instance.userInfo;
  List<Exam> exams = _instance.exams;
  List<String> subjectList = [];
  String? selected;
  List<Exam> results = [];
  String newsubject = '';

  Future<void> searchExam(String? subject) async {
    results = [];
    for (Exam exam in exams) {
      if (subject == exam.subject || subject == null) {
        results.add(exam);
      }
    }

    results.sort(
      (a, b) => a.dates.last.compareTo(b.dates.last),
    );
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _instance = Get.find<Instance>();
    _userInfo = _instance.userInfo;
    exams = _instance.exams;
    subjectList = _instance.subjects;
    searchExam(null);
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        foregroundColor: Colors.white,
        backgroundColor: AhtColors.Main_Color,
        elevation: 7,
        child: GestureDetector(
          onTap: () async {
            await Get.to(() => const RegisterExamScreen());
            setState(() {
              exams = _instance.exams;
              searchExam(selected);
            });
          },
          child: const Icon(Icons.add),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: SizedBox(
        height: screenHeight,
        width: screenWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: screenWidth,
              height: screenHeight / 844 * 144,
              decoration: const BoxDecoration(
                color: AhtColors.Main_Color,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
              ),
              child: Column(
                children: [
                  SizedBox(height: screenHeight / 844 * 70),
                  SizedBox(
                    height: screenHeight / 844 * 40,
                    width: screenWidth,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(width: screenWidth / 390 * 16),
                              Container(
                                width: 36,
                                height: 36,
                                decoration: ShapeDecoration(
                                  color: Colors.white,
                                  image: DecorationImage(
                                    image: MemoryImage(
                                      _userInfo['image'],
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                  shape: const OvalBorder(),
                                ),
                              ),
                              SizedBox(width: screenWidth / 390 * 14),
                              CustomText(
                                text:
                                    '${_userInfo['school']['name']} \n${_userInfo['school']['grade']}학년 ${_userInfo['school']['class']}반',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w700,
                                  height: 1.4,
                                ),
                              )
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            InkWell(
                              onTap: () {},
                              child: const Icon(
                                Icons.notifications_outlined,
                                color: Colors.white,
                                size: 26,
                              ),
                            ),
                            SizedBox(width: screenWidth / 390 * 28),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight / 844 * 16),
            Row(
              children: [
                SizedBox(width: screenWidth / 390 * 28),
                SizedBox(
                  height: screenHeight / 844 * 31,
                  child: Row(
                    children: [
                      SizedBox(
                        width: screenWidth / 390 * 283,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: subjectList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () async {
                                if (selected == subjectList[index]) {
                                  selected = null;
                                } else {
                                  selected = subjectList[index];
                                }
                                setState(() {});
                                await searchExam(selected);
                                setState(() {});
                              },
                              child: SubjectSelectionBox(
                                subjectList[index],
                                selected: selected == subjectList[index],
                              ),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) =>
                              SizedBox(
                            width: screenWidth / 390 * 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: screenWidth / 390 * 5),
                GestureDetector(
                  onTap: () {
                    Get.dialog(
                      Dialog(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              screenWidth / 390 * 10,
                            ),
                            color: Colors.white,
                          ),
                          padding: EdgeInsets.only(
                            top: screenHeight / 844 * 24,
                            bottom: screenHeight / 844 * 20,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const CustomText(
                                text: '새로운 과목 추가',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: screenHeight / 844 * 4),
                              SizedBox(
                                width: screenWidth / 390 * 200,
                                child: CustomTextField(
                                  maxLines: 1,
                                  textInputAction: TextInputAction.done,
                                  onChanged: (n) {
                                    setState(() {
                                      newsubject = n;
                                    });
                                  },
                                  keyboardType: TextInputType.text,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w700,
                                    height: 0,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: '최대 3글자',
                                    hintStyle: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black.withOpacity(0.3),
                                    ),
                                    contentPadding: EdgeInsets.only(
                                      top: 0,
                                      bottom: screenHeight / 844 * 8,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: screenHeight / 844 * 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Get.back();
                                    },
                                    child: Container(
                                      width: screenWidth / 390 * 84,
                                      height: screenHeight / 844 * 35,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                          color: const Color(0xFFDCDCDC),
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          screenWidth / 390 * 4,
                                        ),
                                      ),
                                      child: const Center(
                                        child: CustomText(
                                          text: '취소',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontFamily: 'Pretendard',
                                            fontWeight: FontWeight.w700,
                                            height: 1,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: screenWidth / 390 * 20,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      () async {
                                        bool uploaded =
                                            await Exam.setSubject(newsubject);
                                        if (uploaded) {
                                          await _instance.getExams();
                                          subjectList = _instance.subjects;
                                          setState(() {});
                                          Get.back();
                                        }
                                      }();
                                    },
                                    child: Container(
                                      width: screenWidth / 390 * 84,
                                      height: screenHeight / 844 * 35,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          screenWidth / 390 * 4,
                                        ),
                                        color: AhtColors.Main_Color,
                                      ),
                                      child: const Center(
                                        child: CustomText(
                                          text: '추가',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontFamily: 'Pretendard',
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: screenWidth / 390 * 45,
                    height: screenHeight / 844 * 25,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Center(
                      child: CustomText(
                        text: '+',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: const Color(0xFf898989).withOpacity(0.8),
                          fontSize: 20,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w100,
                          height: 0.5,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: screenWidth / 390 * 28),
              ],
            ),
            SizedBox(height: screenHeight / 844 * 12),
            Row(
              children: [
                SizedBox(width: screenWidth / 390 * 16),
                const CustomText(
                  text: '수행평가 목록',
                  style: TextStyle(
                    color: AhtColors.Main_Color,
                    fontSize: 18,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w700,
                    height: 1.25,
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight / 844 * 18),
            Expanded(
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: screenWidth / 390 * 16),
                child: MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: ListView.separated(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: false,
                    itemCount: results.length,
                    itemBuilder: (BuildContext context, int index) {
                      return MainExamBox(results[index]);
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        SizedBox(
                      height: screenHeight / 844 * 25,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
