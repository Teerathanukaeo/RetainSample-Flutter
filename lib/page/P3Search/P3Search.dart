import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:newmaster/page/P1MainRetain/P1MainRetain.dart';
import 'package:newmaster/page/P2OverviewRetain/P2OverviewRetain.dart';
import 'package:table_calendar/table_calendar.dart';

class Page3 extends StatelessWidget {
  const Page3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => const Page3Body();
}

class Page3Body extends StatefulWidget {
  final Map<String, dynamic>? selectedItem;

  const Page3Body({Key? key, this.selectedItem}) : super(key: key);

  @override
  State<Page3Body> createState() => _Page3BodyState();
}

class _Page3BodyState extends State<Page3Body> {
  final TextEditingController _searchController = TextEditingController();
  int selectedIndex = 2;
  List<dynamic> DetailUneq = [];
  String Uneq = "";

  @override
  void initState() {
    super.initState();
    if (widget.selectedItem != null) {
      DetailUneq = [widget.selectedItem!];
      Uneq = widget.selectedItem!["Uneg"] ?? "";
      _searchController.text = Uneq;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff6f6f6),
      body: Center(
        child: Container(
          width: 454,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.25),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),

          // ⭐⭐⭐ ให้ทั้งหน้าเลื่อนได้ ⭐⭐⭐
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // 🔸 ส่วนหัวค้นหา
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 25),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFFC107), Color(0xFFFFB300)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "ค้นหาตัวอย่าง",
                              style: TextStyle(
                                fontSize: 26,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 5,
                                    offset: const Offset(0, 2),
                                  )
                                ],
                              ),
                              child: Row(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(left: 14, right: 8),
                                    child: Icon(Icons.search, color: Colors.grey),
                                  ),
                                  Expanded(
                                    child: TextField(
                                      controller: _searchController,
                                      decoration: const InputDecoration(
                                        hintText: "พิมพ์รหัส Unique",
                                        border: InputBorder.none,
                                        hintStyle: TextStyle(color: Colors.grey),
                                      ),
                                      onChanged: (value) async {
                                        setState(() => Uneq = value);
                                        if (value.isEmpty) {
                                          setState(() => DetailUneq = []);
                                          return;
                                        }

                                        try {
                                          final response = await Dio().get(
                                            "http://172.23.10.168:3006/GETUNEG",
                                            queryParameters: {"Uneq": Uneq},
                                          );

                                          setState(() {
                                            DetailUneq = (response.data is List && response.data.isNotEmpty) ? response.data : [];
                                          });
                                        } catch (e) {
                                          print("Error: $e");
                                        }
                                      },
                                    ),
                                  ),
                                  if (_searchController.text.isNotEmpty)
                                    IconButton(
                                      icon: const Icon(Icons.close, color: Colors.grey),
                                      onPressed: () {
                                        setState(() {
                                          _searchController.clear();
                                          DetailUneq = [];
                                        });
                                      },
                                    )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // 🔸 ส่วนข้อมูลรายละเอียด
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: DetailUneq.isEmpty
                            ? const Padding(
                                padding: EdgeInsets.only(top: 100),
                                child: Text(
                                  "🔍 กรุณาพิมพ์เพื่อค้นหาข้อมูล",
                                  style: TextStyle(color: Colors.grey, fontSize: 16),
                                ),
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Image.asset(
                                          'assets/images/${DetailUneq[0]['ChemicalPhysic']}.png',
                                          height: 260,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        flex: 3,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            infoText("Unique", DetailUneq[0]['Uneg'], icon: Icons.qr_code),
                                            infoText("ชื่อสารเคมี", DetailUneq[0]['ProductName'], icon: Icons.science_outlined),
                                            infoText("ประเภทเคมี", DetailUneq[0]['ChemicalType'], icon: Icons.category_outlined),
                                            infoText("วันผลิต", DetailUneq[0]['ProductionDate'], icon: Icons.date_range_outlined),
                                            infoText("วันหมดอายุ", DetailUneq[0]['ExpireDate'], icon: Icons.schedule_outlined),
                                            infoText("ทดสอบ1", DetailUneq[0]['Test1'], icon: Icons.analytics_outlined),
                                            infoText("ทดสอบ2", DetailUneq[0]['Test2'], icon: Icons.analytics_outlined),
                                            infoText("ทดสอบ3", DetailUneq[0]['Test3'], icon: Icons.analytics_outlined),
                                            infoText("ทดสอบ4", DetailUneq[0]['Test4'], icon: Icons.analytics_outlined),
                                            infoText("สถานที่จัดเก็บ", DetailUneq[0]['LocationKeep'], icon: Icons.location_on_outlined),
                                            infoText("จัดเก็บโดย", DetailUneq[0]['InputData'], icon: Icons.person_outline),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 15),
                                  const Divider(thickness: 1.2),
                                  const Text(
                                    "📍 สถานที่ทิ้ง",
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Container(
                                    height: 208,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.blueGrey[700],
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          blurRadius: 6,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    clipBehavior: Clip.antiAlias,
                                    child: (DetailUneq[0]['LocationWaste'] != null && DetailUneq[0]['LocationWaste'].toString().isNotEmpty)
                                        ? Image.asset(
                                            'assets/images/${DetailUneq[0]['LocationWaste']}.png',
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) => const Center(
                                              child: Text(
                                                'โหลดรูปภาพไม่สำเร็จ',
                                                style: TextStyle(color: Colors.white, fontSize: 16),
                                              ),
                                            ),
                                          )
                                        : const Center(
                                            child: Text(
                                              'ไม่พบข้อมูล',
                                              style: TextStyle(color: Colors.white, fontSize: 16),
                                            ),
                                          ),
                                  ),
                                  const SizedBox(height: 40),
                                ],
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      // ===== แถบล่าง =====
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
            bottomNavItem(Icons.dashboard_outlined, "ภาพรวม", 1, context, const Page2()),
            bottomNavItem(Icons.search, "ค้นหา", 2, context, null),
          ],
        ),
      ),
    );
  }

  // 🔹 Widget แสดงข้อมูลแบบมีไอคอน
  Widget infoText(String label, String? value, {IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1.4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon ?? Icons.label_outline, size: 18, color: Colors.blueGrey.shade600),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 15, color: Colors.black87, height: 1.3),
                children: [
                  TextSpan(text: "$label: ", style: const TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: value ?? "-"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 Bottom Navigation
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
