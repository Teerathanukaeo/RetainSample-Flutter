import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:newmaster/page/P2OverviewRetain/P2OverviewRetain.dart';
import 'package:newmaster/page/P3Search/P3Search.dart';

//-------------------------------------------
// Calendar Picker
Future<void> CalendaSelectDate(
  BuildContext context,
  DateTime selectedDate,
  Function(String) output,
) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: selectedDate,
    firstDate: DateTime(1900, 1),
    lastDate: DateTime(2101),

    // 🧩 เพิ่ม builder เพื่อตกแต่งธีม
    builder: (BuildContext context, Widget? child) {
      return Theme(
        data: ThemeData.light().copyWith(
          // 🎨 พื้นหลัง dialog
          dialogBackgroundColor: Colors.white,

          // 🎯 กำหนดชุดสีหลักของ date picker
          colorScheme: ColorScheme.light(
            primary: Colors.blueGrey.shade700, // ปุ่ม OK / วันที่เลือก
            onPrimary: Colors.white, // สีตัวอักษรบนปุ่ม
            surface: Colors.white, // สีพื้นหลังของปฏิทิน
            onSurface: Colors.black87, // สีข้อความวันปกติ
          ),

          // 🔘 ปุ่ม "ยกเลิก" / "ตกลง"
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: Colors.blueGrey.shade700, // สีข้อความของปุ่ม
              textStyle: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),

          // 🔡 ฟอนต์และลุคโดยรวม
          dialogTheme: const DialogTheme(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
          ),
        ),
        child: child!,
      );
    },
  );

  if (picked != null) {
    output(picked.toIso8601String().split('T')[0]);
  }
}

//-------------------------------------------
// MAIN PAGE
class Page1 extends StatelessWidget {
  const Page1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Page1Body();
  }
}

class Page1Body extends StatefulWidget {
  const Page1Body({Key? key}) : super(key: key);

  @override
  State<Page1Body> createState() => _Page1BodyState();
}

class _Page1BodyState extends State<Page1Body> {
  String chemicalName = "";
  String? selectedType;
  String? selectedPhysical;
  String selectedDate = "";
  String? selectedKeep;
  String? selectedUser;
  String calculatedExpireDate = "";
  String expireDate = "";
  String alertExpireDate = ""; // วัน Expire หลัก
  String LocationWaste = "";
  List<String> testDates = []; // วัน Test แต่ละตัว
  List<String> testOptions = ["90 Day", "180 Day", "270 Day", "365 Day"];
  List<String> selectedTests = [];
  List<String> alertTestDates = []; // วัน Alert Test แต่ละตัว
  int selectedIndex = 0;
  String? selectedPcs;
  String? generatedUneg;
  bool isSaving = false;

  // UI สำหรับแต่ละ Step
  // -----------------------------
// UI สำหรับแต่ละ Step (แก้ไขให้ระยะวงกลมเท่ากัน)
// -----------------------------
  Widget _buildStep(int stepNumber, String title, Widget content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10), // เพิ่มระยะห่างเท่ากันทุก step
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ===== วงกลมตัวเลข =====
          Column(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: Colors.blueGrey[700],
                child: Text(
                  stepNumber.toString(),
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              if (stepNumber < 7)
                Container(
                  width: 2,
                  height: 40, // ความสูงของเส้นแนวตั้งคงที่ทุก step
                  color: Colors.blueGrey[300],
                ),
            ],
          ),

          const SizedBox(
            width: 10,
          ),

          // ===== เนื้อหาแต่ละ Step =====
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey,
                  ),
                ),
                const SizedBox(height: 8),
                content,
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff0f0f0), // พื้นหลังของหน้าจอ
      body: Center(
        child: Container(
          width: 454,
          height: 1100,
          padding: const EdgeInsets.all(24),
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
              children: [
                // const Text(
                //   "ลงทะเบียนจัดเก็บสารเคมี",
                //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueGrey),
                // ),
                // const SizedBox(height: 24),
                // --- ส่วน Step ต่างๆ คงเดิม ---
                _buildStep(
                  1,
                  "ชื่อสารเคมี",
                  TextField(
                    decoration: InputDecoration(
                      labelText: "กรอกชื่อสารเคมี",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onChanged: (value) async {
                      setState(() {
                        chemicalName = value;
                        selectedType = null; // รีเซ็ต Dropdown
                        selectedPhysical = null;
                        generatedUneg = null;
                      });
                      if (value.isNotEmpty) {
                        generatedUneg = "UNEG${DateTime.now().millisecondsSinceEpoch}";
                      }
                      try {
                        final response = await Dio().get(
                          "http://172.23.10.168:3006/GETNAME",
                          queryParameters: {"Name": value},
                        );
                        print("Response: ${response.data}");
                        if (response.data != null && response.data.length > 0) {
                          setState(() {
                            selectedType = "Chrom";
                            selectedPhysical = "Liquid";
                          });
                        }
                      } catch (e) {
                        print("Error: $e");
                      }
                    },
                  ),
                ),

                // Step 2
                _buildStep(
                  2,
                  "เลือกประเภทสารเคมี",
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          dropdownColor: Colors.white,
                          value: selectedType,
                          decoration: InputDecoration(
                            labelText: "ประเภทสาร",
                            filled: true,
                            fillColor: selectedType == "Chrom" ? Colors.red[200] : Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          items: ["Acid", "Alkaline", "Chrom", "Nox Rust"]
                              .map(
                                (e) => DropdownMenuItem(value: e, child: Text(e)),
                              )
                              .toList(),
                          onChanged: (val) {
                            setState(() {
                              selectedPhysical = null;
                              selectedType = val;
                              // เงื่อนไขสำหรับ LocationWaste ตาม selectedType
                              if (val == "Acid") {
                                LocationWaste = "Gutter at Liquid plant";
                                selectedPhysical = "Liquid";
                              } else if (val == "Chrom") {
                                LocationWaste = "Gutter at reaction tank No.17";
                                selectedPhysical = "Liquid";
                              } else if (val == "Nox Rust") {
                                LocationWaste = "IBC for Used Oil";
                                selectedPhysical = "Noxrust";
                              } else if (val == "Powder") {
                                LocationWaste = "IBC for Powder";
                              } else if (val == "Alkaline") {
                                LocationWaste = "Gutter at Liquid plant";
                              } else {
                                LocationWaste = "";
                              }
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 12), // เว้นระยะระหว่าง Dropdown
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          dropdownColor: Colors.white,
                          value: selectedPhysical,
                          decoration: InputDecoration(
                            labelText: "รูปแบบสาร",
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          items: (selectedType == "Alkaline" || selectedType == "Acid" || selectedType == "Chrom"
                                  ? ["Liquid", "Powder"] // ถ้าเป็น Alkaline ให้แค่ 2 ตัวเลือก
                                  : ["Liquid", "Powder", "Noxrust"])
                              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                              .toList(),
                          onChanged: (val) {
                            setState(() {
                              selectedPhysical = val;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                // Step 3
                _buildStep(
                  3,
                  "เลือกวันที่ผลิต",
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          selectedDate.isEmpty ? "ยังไม่ได้เลือกวันผลิต" : "วันที่ผลิต: $selectedDate",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () async {
                          await CalendaSelectDate(
                            context,
                            DateTime.now(),
                            (String date) {
                              setState(() {
                                selectedDate = date;

                                // ----- คำนวณ Expire และ AlertExpire ทันที -----
                                if (selectedDate.isNotEmpty) {
                                  DateTime prodDate = DateTime.parse(selectedDate);

                                  // วัน Expire = วันผลิต + 365 วัน
                                  DateTime defaultExpire = prodDate.add(const Duration(days: 364));
                                  expireDate = "${defaultExpire.toLocal()}".split(' ')[0];

                                  // วัน AlertExpire (3 วันก่อน Expire)
                                  DateTime alertExpire = defaultExpire.subtract(const Duration(days: 3));
                                  alertExpireDate = "${alertExpire.toLocal()}".split(' ')[0];
                                }
                              });
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),

                // Step 4
                _buildStep(
                  4,
                  "การทดสอบ",
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: testOptions.map((test) {
                      final isChecked = selectedTests.contains(test);
                      return Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: FilterChip(
                          selectedColor: Colors.blueGrey[200],
                          backgroundColor: Colors.white,
                          label: Text(
                            test,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 10),
                          ),
                          selected: isChecked,
                          onSelected: (bool selected) {
                            setState(() {
                              if (selected) {
                                selectedTests.add(test);
                              } else {
                                selectedTests.remove(test);
                              }

                              if (selectedDate.isNotEmpty) {
                                DateTime prodDate = DateTime.parse(selectedDate);

                                // ----- วัน Test และ AlertTest -----
                                if (selectedTests.isNotEmpty) {
                                  testDates = selectedTests.map((t) {
                                    int days = int.parse(t.split(" ")[0]);
                                    DateTime testDate = prodDate.add(Duration(days: days));
                                    return "${testDate.toLocal()}".split(' ')[0];
                                  }).toList();

                                  alertTestDates = testDates.map((d) {
                                    DateTime testDate = DateTime.parse(d);
                                    DateTime alertDate = testDate.subtract(const Duration(days: 3));
                                    return "${alertDate.toLocal()}".split(' ')[0];
                                  }).toList();

                                  // ----- Expire และ AlertExpire เมื่อเลือก Test -----
                                  DateTime defaultExpire = prodDate.add(const Duration(days: 365));
                                  if (selectedTests.any((t) => t.contains("365"))) {
                                    defaultExpire = prodDate.add(const Duration(days: 365 + 14));
                                  }
                                  expireDate = "${defaultExpire.toLocal()}".split(' ')[0];
                                  alertExpireDate = "${defaultExpire.subtract(const Duration(days: 3)).toLocal()}".split(' ')[0];
                                } else {
                                  // ----- Expire และ AlertExpire เมื่อไม่เลือก Test หรือยกเลิกทั้งหมด -----
                                  testDates = [];
                                  alertTestDates = [];
                                  DateTime defaultExpire = prodDate.add(const Duration(days: 364));
                                  expireDate = "${defaultExpire.toLocal()}".split(' ')[0];
                                  alertExpireDate = "${defaultExpire.subtract(const Duration(days: 3)).toLocal()}".split(' ')[0];
                                }
                              } else {
                                testDates = [];
                                alertTestDates = [];
                                expireDate = "";
                                alertExpireDate = "";
                              }
                            });
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
                _buildStep(
                  5,
                  "จำนวน",
                  DropdownButtonFormField<String>(
                    dropdownColor: Colors.white,
                    value: selectedPcs,
                    decoration: InputDecoration(
                      labelText: "เลือกจำนวน",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    items: ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                    onChanged: (val) {
                      setState(() => selectedPcs = val);
                    },
                  ),
                ),
                // Step 5
                _buildStep(
                  6,
                  "สถานที่จัดเก็บสารเคมี",
                  DropdownButtonFormField<String>(
                    dropdownColor: Colors.white,
                    value: selectedKeep,
                    decoration: InputDecoration(
                      labelText: "เลือกสถานที่จัดเก็บ",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    items: ["Retain Room", "Oven", "Cool Room"].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                    onChanged: (val) {
                      setState(() => selectedKeep = val);
                    },
                  ),
                ),
                // Step 6
                _buildStep(
                  7,
                  "จัดเก็บโดย",
                  DropdownButtonFormField<String>(
                    dropdownColor: Colors.white,
                    value: selectedUser,
                    decoration: InputDecoration(
                      labelText: "ผู้จัดเก็บ",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    items: ["Krongkarn", "Mantana"].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                    onChanged: (val) {
                      setState(() => selectedUser = val);
                    },
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueGrey,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          elevation: 3,
                        ),
                        onPressed: isSaving
                            ? null
                            : () async {
                                setState(() => isSaving = true);

                                final response = await Dio().post(
                                  "http://172.23.10.168:3006/SENTDATA",
                                  data: {
                                    "Uneg": generatedUneg ?? "",
                                    "ProductName": chemicalName,
                                    "ChemicalType": selectedType ?? "",
                                    "ChemicalPhysic": selectedPhysical ?? "",
                                    "ProductionDate": selectedDate,
                                    "Alert": alertExpireDate,
                                    "ExpireDate": expireDate,
                                    "LocationKeep": selectedKeep ?? "",
                                    "LocationWaste": LocationWaste,
                                    "Pcs": selectedPcs ?? "",
                                    "InputData": selectedUser ?? "",
                                    "Test1": testDates.length > 0 ? testDates[0] : "",
                                    "AlertTest1": alertTestDates.length > 0 ? alertTestDates[0] : "",
                                    "Test2": testDates.length > 1 ? testDates[1] : "",
                                    "AlertTest2": alertTestDates.length > 1 ? alertTestDates[1] : "",
                                    "Test3": testDates.length > 2 ? testDates[2] : "",
                                    "AlertTest3": alertTestDates.length > 2 ? alertTestDates[2] : "",
                                    "Test4": testDates.length > 3 ? testDates[3] : "",
                                    "AlertTest4": alertTestDates.length > 3 ? alertTestDates[3] : "",
                                    "Status": "Inprocess",
                                  },
                                  options: Options(validateStatus: (status) => true),
                                );

                                if (response.statusCode == 200 || response.statusCode == 201) {
                                  // ✅ เคลียร์ข้อมูลทั้งหมด
                                  setState(() {
                                    chemicalName = "";
                                    selectedType = null;
                                    selectedPhysical = null;
                                    selectedDate = "";
                                    selectedKeep = null;
                                    selectedUser = null;
                                    expireDate = "";
                                    alertExpireDate = "";
                                    testDates.clear();
                                    alertTestDates.clear();
                                    selectedTests.clear();
                                    selectedPcs = null;
                                    generatedUneg = null;
                                  });

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("บันทึกสำเร็จ ✅"),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("บันทึกไม่สำเร็จ (Error ${response.statusCode}) ❌"),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }

                                setState(() => isSaving = false);
                              },
                        icon: isSaving
                            ? const SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                              )
                            : const Icon(Icons.save, color: Colors.white),
                        label: Text(
                          isSaving ? "กำลังบันทึก..." : "บันทึกและพิมพ์",
                          style: const TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[400],
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          elevation: 3,
                        ),
                        onPressed: () {
                          // --- CLEAR DATA CODE ---
                          setState(() {
                            chemicalName = "";
                            selectedType = null;
                            selectedDate = "";
                            selectedKeep = null;
                            selectedUser = null;
                            expireDate = "";
                            alertExpireDate = "";
                            LocationWaste = "";
                            testDates = [];
                            selectedTests = [];
                            alertTestDates = [];
                            selectedPcs = null;
                            selectedPhysical = null;
                            chemicalName = "";
                          });
                        },
                        icon: const Icon(Icons.clear, color: Colors.white),
                        label: const Text(
                          "Clear",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
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
            bottomNavItem(Icons.assignment_add, "ลงทะเบียน", 0, context, null),
            bottomNavItem(Icons.dashboard_outlined, "ภาพรวม", 1, context, const Page2()),
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
