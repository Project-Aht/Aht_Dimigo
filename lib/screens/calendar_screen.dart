import 'package:cell_calendar/cell_calendar.dart';
import 'package:flutter/material.dart';
import 'dart:core';

import 'package:get/get.dart';

import '../firebase/exam.dart';
import '../firebase/instance.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

Map<String, Color> colors = {
  '수학': const Color(0xFF02CC5B).withOpacity(0.15),
};

class _CalendarScreenState extends State<CalendarScreen> {
  final cellCalendarPageController = CellCalendarPageController();
  List<CalendarEvent> events = [
    for (Exam exam in Get.find<Instance>().exams)
      for (DateTime date in exam.dates)
        CalendarEvent(
          eventName: exam.title,
          eventDate: date,
          eventTextStyle: TextStyle(
            fontFamily: 'Pretendard',
            fontSize: const TextScaler.linear(1).scale(10),
            fontWeight: FontWeight.w600,
            letterSpacing: -0.2,
          ),
          eventBackgroundColor: colors[exam.subject] ??
              const Color.fromARGB(255, 103, 2, 204).withOpacity(0.15),
        ),
  ];

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth / 390 * 16),
        child: Column(
          children: [
            SizedBox(height: screenHeight / 844 * 74),
            Expanded(
              child: SizedBox(
                width: screenWidth / 390 * 358,
                child: CellCalendar(
                  events: events,
                  cellCalendarPageController: cellCalendarPageController,
                  todayMarkColor: const Color(0xFF38498E),
                  todayTextColor: Colors.white,
                  dateTextStyle: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: const TextScaler.linear(1).scale(12),
                    fontWeight: FontWeight.w500,
                    height: 0,
                    letterSpacing: -0.24,
                  ),
                  onCellTapped: (date) {
                    print("$date is tapped !");
                  },
                  daysOfTheWeekBuilder: (dayIndex) {
                    final labels = ["일", "월", "화", "수", "목", "금", "토"];
                    return Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: screenHeight / 844 * 16),
                      child: Text(
                        labels[dayIndex],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Pretendard',
                          fontSize: 16,
                          color: _getColorForDayIndex(dayIndex),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    );
                  },
                  monthYearLabelBuilder: (datetime) {
                    final year = datetime?.year.toString();
                    final month = datetime?.month.toString();
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: SizedBox(
                            width: screenWidth / 390 * 174,
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.center, //!Icon 생성시 이거 삭제
                              children: [
                                /*Icon(
                            Icons.arrow_back_ios_sharp,
                            size: screenWidth / 390 * 22,
                            color: Colors.black,
                          ),
                                SizedBox(width: screenWidth / 390 * 30),*/
                                Text(
                                  "$year.$month",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    height: 1.25,
                                  ),
                                ),

                                /*SizedBox(width: screenWidth / 390 * 25),
                                Icon(
                            Icons.arrow_forward_ios_sharp,
                            size: screenWidth / 390 * 22,
                            color: Colors.black,
                          ),*/
                              ],
                            ),
                          ),
                        ),
                        Container(
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                width: 0.5,
                                strokeAlign: BorderSide.strokeAlignCenter,
                                color: Colors.black.withOpacity(0.1),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            Container(
              width: screenWidth / 390 * 358,
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 0.5,
                    strokeAlign: BorderSide.strokeAlignCenter,
                    color: Colors.black.withOpacity(0.1),
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

Color _getColorForDayIndex(int dayIndex) {
  if (dayIndex == 0) {
    return const Color(0xFFD20000);
  } else if (dayIndex == 6) {
    return const Color(0xFF5000FC);
  } else {
    return Colors.black;
  }
}
