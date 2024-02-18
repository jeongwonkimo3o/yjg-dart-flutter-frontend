import "package:flutter/material.dart";
import "package:yjg/shared/widgets/base_appbar.dart";
import 'package:yjg/salon(admin)/presentation/widgets/booking_calendar.dart';
import "package:yjg/shared/widgets/bottom_navigation_bar.dart";

class AdminSalonBooking extends StatelessWidget {
  const AdminSalonBooking({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BaseAppBar(title: "예약 관리"),
      bottomNavigationBar: const CustomBottomNavigationBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 20),
              alignment: Alignment(-0.85, 0.2),
              child: const Text(
                '예약 날짜 선택',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
            ),
            BookingCalendar(),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
