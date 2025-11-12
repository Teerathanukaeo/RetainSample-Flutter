import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

//-------------------------------------------
// Calendar Picker
Future<void> CalendaSelectDate(BuildContext context, DateTime selectedDate, Function output) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: selectedDate,
    firstDate: DateTime(1900, 8),
    lastDate: DateTime(2101),
  );
  if (picked != null && picked != selectedDate) {
    selectedDate = picked;
    output("${selectedDate.toLocal()}".split(' ')[0]);
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
              if (stepNumber < 6)
                Container(
                  width: 2,
                  height: 50, // ความสูงของเส้นแนวตั้งคงที่ทุก step
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
      backgroundColor: const Color(0xfffafafa),
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          width: 454,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Text(
                  "ลงทะเบียนจัดเก็บสารเคมี",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueGrey),
                ),
                const SizedBox(height: 24),

                // Step 1
                _buildStep(
                  1,
                  "ชื่อสารเคมี",
                  TextField(
                    decoration: InputDecoration(
                      labelText: "กรอกชื่อสารเคมี",
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onChanged: (value) async {
                      setState(() {
                        chemicalName = value;
                        selectedType = null; // รีเซ็ต Dropdown
                      });

                      try {
                        final response = await Dio().get(
                          "http://127.0.0.1:3006/GETNAME",
                          queryParameters: {"Name": value},
                        );
                        print("Response: ${response.data}");

                        // ถ้า response.data.length > 0 ให้กำหนด selectedType
                        if (response.data != null && response.data.length > 0) {
                          setState(() {
                            selectedType = "Chrom"; // อัปเดต Dropdown
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
                  "ประเภทสารเคมี",
                  DropdownButtonFormField<String>(
                    value: selectedType,
                    decoration: InputDecoration(
                      labelText: "เลือกประเภท",
                      filled: true,
                      fillColor: selectedType == "Chrom" ? Colors.red[200] : Colors.grey[100], // ถ้า Chrom = แดง
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    items: ["Acid", "Alkaline", "Chrom", "Nox Rust", "Powder "].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                    onChanged: (val) {
                      setState(() {
                        selectedType = val;

                        // ----- เงื่อนไขสำหรับ LocationWaste -----
                        if (val == "Acid") {
                          LocationWaste = "Gutter at Liquid plant";
                        } else if (val == "Alkaline") {
                          LocationWaste = "Gutter at Liquid plant";
                        } else if (val == "Chrom") {
                          LocationWaste = "Gutter at reaction tank No.17";
                        } else if (val == "Nox Rust") {
                          LocationWaste = "IBC for Used Oil ";
                        } else if (val == "Powder ") {
                          LocationWaste = "'IBC for Powder";
                        } else {
                          LocationWaste = ""; // รีเซ็ตหรือค่าเริ่มต้น
                        }
                      });
                    },
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
                                  DateTime defaultExpire = prodDate.add(const Duration(days: 365));
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
                                  DateTime defaultExpire = prodDate.add(const Duration(days: 365));
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

                // Step 5
                _buildStep(
                  5,
                  "สถานที่จัดเก็บสารเคมี",
                  DropdownButtonFormField<String>(
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
                  6,
                  "จัดเก็บโดย",
                  DropdownButtonFormField<String>(
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
                          elevation: 3, // เพิ่มเงาเล็กน้อย
                        ),
                        onPressed: () async {
                          // --- POST DATA CODE ---
                          final response = await Dio().post(
                            "http://127.0.0.1:3006/SENTDATA",
                            data: {
                              "ProductName": chemicalName.isNotEmpty ? chemicalName : "",
                              "ChemicalType": selectedType ?? "",
                              "ProductionDate": selectedDate.isNotEmpty ? selectedDate : "",
                              "Alert": alertExpireDate.isNotEmpty ? alertExpireDate : "",
                              "ExpireDate": expireDate.isNotEmpty ? expireDate : "",
                              "LocationKeep": selectedKeep ?? "",
                              "LocationWaste": LocationWaste ?? "",
                              "TestType": "",
                              "InputData": selectedUser ?? "",
                              "Test1": testDates.length > 0 ? testDates[0] : "",
                              "AlertTest1": alertTestDates.length > 0 ? alertTestDates[0] : "",
                              "Test2": testDates.length > 1 ? testDates[1] : "",
                              "AlertTest2": alertTestDates.length > 1 ? alertTestDates[1] : "",
                              "Test3": testDates.length > 2 ? testDates[2] : "",
                              "AlertTest3": alertTestDates.length > 2 ? alertTestDates[2] : "",
                              "Test4": testDates.length > 3 ? testDates[3] : "",
                              "AlertTest4": alertTestDates.length > 3 ? alertTestDates[3] : "",
                            },
                            options: Options(
                              validateStatus: (status) => true, // ไม่ throw exceptions
                            ),
                          );

                          print("Status Code: ${response.statusCode}");
                          print("Response: ${response.data}");
                        },
                        icon: const Icon(Icons.save, color: Colors.white),
                        label: const Text(
                          "บันทึกและพิมพ์",
                          style: TextStyle(color: Colors.white, fontSize: 16),
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
    );
  }
}
