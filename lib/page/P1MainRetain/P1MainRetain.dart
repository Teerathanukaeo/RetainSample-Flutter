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
  String test90 = "";
  String alertTest90 = "";
  String test180 = "";
  String alertTest180 = "";
  String test270 = "";
  String alertTest270 = "";
  String test365 = "";
  String alertTest365 = "";
  String remark = "";
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
    return IntrinsicHeight(
      // ให้ Row ปรับความสูงตามเนื้อหา
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch, // ให้เต็มความสูง
        children: [
          // ===== วงกลมตัวเลข + เส้น =====
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
                Expanded(
                  child: Container(
                    width: 2,
                    color: Colors.blueGrey[300],
                  ),
                ),
            ],
          ),

          const SizedBox(width: 10),

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
                  Column(
                    children: [
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
                      const SizedBox(height: 12),
                      // 🔹 ช่องหมายเหตุ
                      TextField(
                        decoration: InputDecoration(
                          labelText: "หมายเหตุ",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            remark = value; // เก็บค่าไว้ในตัวแปร remark
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
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
                          items: ["Acid", "Alkaline", "Chrom", "Nox Rust"].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                          onChanged: (val) {
                            setState(() {
                              selectedType = val;

                              // ---------- ตั้งค่า selectedPhysical อัตโนมัติ ----------
                              if (val == "Acid" || val == "Chrom") {
                                selectedPhysical = "Liquid";
                              } else if (val == "Nox Rust") {
                                selectedPhysical = "Noxrust";
                              } else if (val == "Alkaline") {
                                selectedPhysical = null;
                              }

                              // ---------- LocationWaste ----------
                              if (val == "Acid") {
                                LocationWaste = "Gutter at Liquid plant for Acid";
                              } else if (val == "Chrom") {
                                LocationWaste = "Gutter at reaction tank No.17";
                              } else if (val == "Nox Rust") {
                                LocationWaste = "IBC for Used Oil";
                              } else if (val == "Alkaline") {
                                LocationWaste = "Gutter at Liquid plant for Alkaline";
                              } else {
                                LocationWaste = "";
                              }
                            });
                          },
                        ),
                      ),

                      const SizedBox(width: 12),

                      // 🔒 🔒 ล็อก dropdown ถ้าเป็น Acid / Chrom / Nox Rust
                      Expanded(
                        child: IgnorePointer(
                          ignoring: selectedType != "Alkaline", // ถ้าไม่ใช่ Alkaline → กดไม่ได้
                          child: Opacity(
                            opacity: selectedType != "Alkaline" ? 0.5 : 1, // ทำให้ดูจางๆ ตอนกดไม่ได้
                            child: DropdownButtonFormField<String>(
                              value: selectedPhysical,
                              decoration: InputDecoration(
                                labelText: "รูปแบบสาร",
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              items: (selectedType == "Alkaline" ? ["Liquid", "Powder"] : ["Liquid", "Powder", "Noxrust"]).map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                              onChanged: (val) {
                                setState(() {
                                  selectedPhysical = val;

                                  if (selectedType == "Alkaline" && val == "Liquid") {
                                    LocationWaste = "Gutter at Liquid plant for Alkaline";
                                  } else if (selectedType == "Alkaline" && val == "Powder") {
                                    LocationWaste = "IBC for Powder";
                                  }
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
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
                const SizedBox(height: 20),
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

                                // Reset ทุกตัวแปรก่อน
                                test90 = "";
                                test180 = "";
                                test270 = "";
                                test365 = "";
                                alertTest90 = "";
                                alertTest180 = "";
                                alertTest270 = "";
                                alertTest365 = "";

                                // ========================
                                //   เก็บ Test แยกตามประเภท
                                // ========================
                                if (selectedTests.contains("90 Day")) {
                                  DateTime d = prodDate.add(const Duration(days: 90));
                                  test90 = "${d.toLocal()}".split(' ')[0];

                                  DateTime ad = d.subtract(const Duration(days: 3));
                                  alertTest90 = "${ad.toLocal()}".split(' ')[0];
                                }

                                if (selectedTests.contains("180 Day")) {
                                  DateTime d = prodDate.add(const Duration(days: 180));
                                  test180 = "${d.toLocal()}".split(' ')[0];

                                  DateTime ad = d.subtract(const Duration(days: 3));
                                  alertTest180 = "${ad.toLocal()}".split(' ')[0];
                                }

                                if (selectedTests.contains("270 Day")) {
                                  DateTime d = prodDate.add(const Duration(days: 270));
                                  test270 = "${d.toLocal()}".split(' ')[0];

                                  DateTime ad = d.subtract(const Duration(days: 3));
                                  alertTest270 = "${ad.toLocal()}".split(' ')[0];
                                }

                                if (selectedTests.contains("365 Day")) {
                                  DateTime d = prodDate.add(const Duration(days: 365));
                                  test365 = "${d.toLocal()}".split(' ')[0];

                                  DateTime ad = d.subtract(const Duration(days: 3));
                                  alertTest365 = "${ad.toLocal()}".split(' ')[0];
                                }

                                // ========================
                                // Expire Date
                                // ========================
                                DateTime defaultExpire = prodDate.add(const Duration(days: 365));

                                // ถ้าเลือก 365 วัน → +14 วัน
                                if (selectedTests.contains("365 Day")) {
                                  defaultExpire = prodDate.add(const Duration(days: 365 + 14));
                                }

                                expireDate = "${defaultExpire.toLocal()}".split(' ')[0];
                                alertExpireDate = "${defaultExpire.subtract(const Duration(days: 3)).toLocal()}".split(' ')[0];
                              } else {
                                // ถ้าไม่มีวันที่ผลิต
                                test90 = "";
                                test180 = "";
                                test270 = "";
                                test365 = "";
                                alertTest90 = "";
                                alertTest180 = "";
                                alertTest270 = "";
                                alertTest365 = "";
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
                const SizedBox(height: 20),
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
                const SizedBox(height: 20),
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
                const SizedBox(height: 20),
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
                                    "Test1": test90 ?? "",
                                    "AlertTest1": alertTest90 ?? "",
                                    "Test2": test180 ?? "",
                                    "AlertTest2": alertTest180 ?? "",
                                    "Test3": test270 ?? "",
                                    "AlertTest3": alertTest270 ?? "",
                                    "Test4": test365 ?? "",
                                    "AlertTest4": alertTest365 ?? "",
                                    "Remark": remark ?? "",
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
                          isSaving ? "กำลังบันทึก..." : "บันทึก",
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
