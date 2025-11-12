import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newmaster/page/P1MainRetain/P1MainRetain.dart';
import 'package:newmaster/page/P3Search/P3Search.dart';
import 'package:newmaster/page/page4.dart';
import 'package:newmaster/page/page5.dart';
import 'package:newmaster/page/page6.dart';
import 'package:table_calendar/table_calendar.dart';

class Page2 extends StatelessWidget {
  const Page2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Page2Body();
  }
}

class Page2Body extends StatefulWidget {
  const Page2Body({Key? key}) : super(key: key);

  @override
  State<Page2Body> createState() => _Page2BodyState();
}

class _Page2BodyState extends State<Page2Body> {
  String selectedType = ""; // ตัวแปรเก็บค่าที่จะอัปเดต
  int VolumeAll = 0;
  int VolumeTest = 0;
  int VolumeWaste = 0;
  List<dynamic> sampleAllData = [];
  List<dynamic> sampleTestData = [];
  List<dynamic> sampleWasteData = [];
  int selectedIndex = 1; // หน้า "ภาพรวม"
  Map<DateTime, List<String>> _events = {};

  @override
  void initState() {
    super.initState();
    _fetchData(); // เรียกฟังก์ชันยิง API ตอนเริ่มต้น
  }

  Map<DateTime, List<String>> generateEventsFromApi(List<dynamic> data) {
    final Map<DateTime, List<String>> events = {};

    DateTime today = DateTime.now();
    DateTime todayDateOnly = DateTime.utc(today.year, today.month, today.day);

    DateTime dateOnly(DateTime d) => DateTime.utc(d.year, d.month, d.day);

    for (var item in data) {
      // ✅ 1) ExpireDate → ทิ้งวันนี้ (แสดงทั้งอนาคตและอดีต)
      if (item["ExpireDate"] != null && item["ExpireDate"] != "") {
        DateTime expire = dateOnly(DateTime.parse(item["ExpireDate"]));
        events.putIfAbsent(expire, () => []);
        events[expire]!.add("ทิ้งวันนี้");
      }

      // ✅ 2) ดึง Test1–4 ทั้งหมด → แยกเป็น "Test ที่ผ่านมาแล้ว" และ "Test อนาคต"
      List<DateTime> pastTests = [];
      List<DateTime> futureTests = [];

      for (int i = 1; i <= 4; i++) {
        String key = "Test$i";
        if (item[key] != null && item[key] != "") {
          DateTime testDate = dateOnly(DateTime.parse(item[key]));
          if (testDate.isBefore(todayDateOnly)) {
            pastTests.add(testDate); // ✅ เก็บไว้แสดงย้อนหลัง
          } else {
            futureTests.add(testDate); // ✅ ใช้เลือกวันทดสอบหลัก
          }
        }
      }

      // ✅ 3) แสดง Test ที่ผ่านมาแล้ว (แถบเหลืองย้อนหลัง)
      for (var past in pastTests) {
        events.putIfAbsent(past, () => []);
        events[past]!.add("ทดสอบวันนี้");
      }

      // ✅ 4) ถ้ามี Test ของอนาคต — เลือกอันที่ใกล้ที่สุดเป็น “ทดสอบวันนี้”
      if (futureTests.isNotEmpty) {
        futureTests.sort();
        DateTime nearest = futureTests.first;
        events.putIfAbsent(nearest, () => []);
        events[nearest]!.add("ทดสอบวันนี้");
      }
    }

    return events;
  }

  Future<void> _fetchData() async {
    DateTime today = DateTime.now();
    DateTime todayDateOnly = DateTime.utc(today.year, today.month, today.day);

    try {
      final response = await Dio().get("http://172.23.10.168:3006/GETSAMP1");

      if (response.data != null && response.data.length > 0) {
        setState(() {
          sampleAllData = response.data;
          VolumeAll = response.data.length;

          // สร้าง events
          _events = generateEventsFromApi(sampleAllData);

          // นับรายการที่ ExpireDate == วันนี้ → อัปเดต VolumeWaste
          VolumeWaste = sampleAllData
              .where((item) =>
                  item["ExpireDate"] != null &&
                  item["ExpireDate"] != "" &&
                  DateTime.parse(item["ExpireDate"]).year == today.year &&
                  DateTime.parse(item["ExpireDate"]).month == today.month &&
                  DateTime.parse(item["ExpireDate"]).day == today.day)
              .length;
        });
      } else {
        setState(() {
          sampleAllData = [];
          VolumeAll = 0;
          _events = {};
          VolumeWaste = 0;
        });
      }
    } catch (e) {
      print("Error: $e");
    }
    try {
      final response = await Dio().get(
        "http://172.23.10.168:3006/GETSAMP2",
      );

      print("Response: ${response.data}");

      if (response.data != null && response.data.length > 0) {
        setState(() {
          VolumeTest = response.data.length; // เปลี่ยนค่าสำหรับใช้ใน UI
          sampleTestData = response.data;
        });
      } else {
        setState(() {
          sampleTestData = [];
          VolumeTest = 0;
        });
      }
    } catch (e) {
      print("Error: $e");
    }
    try {
      final response = await Dio().get(
        "http://172.23.10.168:3006/GETSAMP3",
      );

      print("Response: ${response.data}");

      if (response.data != null && response.data.length > 0) {
        setState(() {
          VolumeWaste = response.data.length; // เปลี่ยนค่าสำหรับใช้ใน UI
          sampleWasteData = response.data;
        });
      } else {
        setState(() {
          sampleWasteData = [];
          VolumeWaste = 0;
        });
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  Widget _buildDashboardCard({
    required Color color,
    required String number,
    required String label,
    required IconData icon,
    VoidCallback? onTap,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click, // เปลี่ยนเคอร์เซอร์ให้รู้ว่ากดได้
      child: Material(
        color: Colors.transparent, // ให้ InkWell ทำงานได้
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          splashColor: Colors.white.withOpacity(0.3), // เอฟเฟกต์คลื่นตอนกด
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeOut,
            padding: const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 16,
            ),
            margin: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        number,
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        label,
                        style: const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Icon(icon, color: Colors.white, size: 80),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    DateTime _focusedDay = DateTime.now();
    DateTime? _selectedDay;

    return Scaffold(
      backgroundColor: const Color(0xfff0f0f0), // สีพื้นหลังเทาอ่อน
      body: Center(
        child: Container(
          width: 454,
          height: 1100,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white, // การ์ดสีขาว
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                blurRadius: 15,
                spreadRadius: 2,
                offset: const Offset(0, 5), // เงาลอยลง
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TableCalendar(
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },
                  calendarFormat: CalendarFormat.month,
                  eventLoader: (day) {
                    return _events[DateTime.utc(day.year, day.month, day.day)] ?? [];
                  },
                  calendarBuilders: CalendarBuilders(
                    defaultBuilder: (context, day, focusedDay) {
                      final events = _events[DateTime.utc(day.year, day.month, day.day)] ?? [];
                      return Container(
                        margin: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: events.isEmpty ? Colors.white : Colors.transparent,
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Stack(
                          children: [
                            if (events.contains("ทดสอบวันนี้"))
                              Positioned(
                                top: 2,
                                left: 4,
                                right: 4,
                                height: 10,
                                child: Container(
                                  color: Colors.amber[400],
                                ),
                              ),
                            if (events.contains("ทิ้งวันนี้"))
                              Positioned(
                                top: 30,
                                left: 4,
                                right: 4,
                                height: 10,
                                child: Container(
                                  color: Colors.red[400],
                                ),
                              ),
                            Center(
                              child: Text(
                                '${day.day}',
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  calendarStyle: const CalendarStyle(
                    markerDecoration: BoxDecoration(), // ปิด decoration ของ marker
                    markersMaxCount: 0, // ปิดจุด event default
                  ),
                  headerStyle: const HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                  ),
                ),

                const Divider(thickness: 1, color: Colors.blueGrey),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    "แดชบอร์ด",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey,
                    ),
                  ),
                ),

                // ===== การ์ดแสดงข้อมูล =====
                _buildDashboardCard(
                  color: Colors.blue[400]!,
                  number: VolumeAll.toString(),
                  label: "ตัวอย่างทั้งหมด",
                  icon: Icons.science,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => Page4(data: sampleAllData), // ✅ ส่งข้อมูลมาที่หน้า Page4
                      ),
                    );
                  },
                ),

                _buildDashboardCard(
                  color: Colors.amber[400]!,
                  number: VolumeTest.toString(),
                  label: "ทดสอบวันนี้",
                  icon: Icons.task,
                  onTap: () {
                    final today = DateTime.now();
                    final todayOnly = DateTime.utc(today.year, today.month, today.day);

                    // กรองข้อมูล Test1–4 ที่ตรงกับวันนี้
                    final dataToday = sampleAllData.where((item) {
                      for (int i = 1; i <= 4; i++) {
                        final testRaw = item["Test$i"];
                        if (testRaw == null || testRaw == "") continue;
                        final d = DateTime.parse(testRaw);
                        final dOnly = DateTime.utc(d.year, d.month, d.day);
                        if (dOnly == todayOnly) return true;
                      }
                      return false;
                    }).toList();

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => Page5(data: dataToday),
                      ),
                    );
                  },
                ),

                _buildDashboardCard(
                  color: Colors.red[400]!,
                  number: VolumeWaste.toString(),
                  label: "ทิ้งวันนี้",
                  icon: Icons.delete,
                  onTap: () {
                    final today = DateTime.now();
                    final todayOnly = DateTime.utc(today.year, today.month, today.day);

                    // กรองข้อมูล ExpireDate == วันนี้
                    final dataToday = sampleAllData.where((item) {
                      if (item["ExpireDate"] == null || item["ExpireDate"] == "") return false;
                      final d = DateTime.parse(item["ExpireDate"]);
                      final dOnly = DateTime.utc(d.year, d.month, d.day);
                      return dOnly == todayOnly;
                    }).toList();

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => Page6(data: dataToday),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),

      // ===== แถบล่าง (Navigation Bar) =====
      bottomNavigationBar: Container(
        height: 65,
        margin: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.25),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            bottomNavItem(Icons.assignment_add, "ลงทะเบียน", 0, context, const Page1()),
            bottomNavItem(Icons.dashboard_outlined, "ภาพรวม", 1, context, null),
            bottomNavItem(Icons.search, "ค้นหา", 2, context, const Page3()),
          ],
        ),
      ),
    );
  }

  Widget bottomNavItem(IconData icon, String label, int index, BuildContext context, Widget? page) {
    bool selected = selectedIndex == index;
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: page != null ? () => Navigator.push(context, MaterialPageRoute(builder: (_) => page)) : null,
        child: Container(
          decoration: BoxDecoration(
            color: selected ? Colors.blueGrey.withOpacity(0.15) : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 26, color: Colors.blueGrey[700]),
              const SizedBox(height: 4),
              Text(label, style: const TextStyle(fontSize: 13, color: Colors.blueGrey)),
            ],
          ),
        ),
      ),
    );
  }
}
