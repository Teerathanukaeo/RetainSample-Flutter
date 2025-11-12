import 'package:flutter/material.dart';

class Page6 extends StatefulWidget {
  final List<dynamic> data;
  const Page6({Key? key, required this.data}) : super(key: key);

  @override
  State<Page6> createState() => _Page6State();
}

class _Page6State extends State<Page6> {
  late List<dynamic> dataList;

  @override
  void initState() {
    super.initState();
    // สร้าง copy ของ list เพื่อแก้ไขได้
    dataList = List.from(widget.data);
  }

  String formatDate(String? rawDate) {
    if (rawDate == null || rawDate.isEmpty) return "-";
    try {
      final d = DateTime.parse(rawDate);
      final day = d.day.toString().padLeft(2, '0');
      final month = d.month.toString().padLeft(2, '0');
      final year = d.year.toString();
      return "$day-$month-$year";
    } catch (_) {
      return rawDate ?? "-";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff0f0f0), // พื้นหลังเทาอ่อน
      body: Center(
        child: Container(
          width: 454,
          height: 1100,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                blurRadius: 15,
                spreadRadius: 2,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // แถวปุ่มย้อนกลับ + ชื่อหัวข้อ
              Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.blueGrey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.blueGrey,
                        size: 22,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    "ทิ้งวันนี้",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(thickness: 1, color: Colors.blueGrey),
              // เนื้อหาหลัก (ListView)
              Expanded(
                child: dataList.isEmpty
                    ? const Center(
                        child: Text(
                          "ไม่มีข้อมูล",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.blueGrey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.only(top: 8),
                        itemCount: dataList.length,
                        itemBuilder: (context, index) {
                          final item = dataList[index];
                          Color bgColor;
                          switch (item["ChemicalType"]) {
                            case "ทดสอบวันนี้":
                              bgColor = Colors.amber.shade100;
                              break;
                            case "ทิ้งวันนี้":
                              bgColor = Colors.red.shade100;
                              break;
                            default:
                              bgColor = Colors.blue.shade50;
                          }

                          // คำนวณวันทดสอบถัดไป
                          final now = DateTime.now();
                          final tests = <String, DateTime?>{};
                          for (int i = 1; i <= 4; i++) {
                            final raw = item["Test$i"];
                            if (raw != null && raw.toString().trim().isNotEmpty) {
                              try {
                                tests["Test$i"] = DateTime.parse(raw);
                              } catch (_) {}
                            }
                          }
                          final futureTests = tests.entries.where((e) => e.value != null && e.value!.isAfter(now)).toList()..sort((a, b) => a.value!.compareTo(b.value!));
                          String testLabel;
                          if (futureTests.isNotEmpty) {
                            final next = futureTests.first;
                            final day = next.value!.day.toString().padLeft(2, '0');
                            final month = next.value!.month.toString().padLeft(2, '0');
                            final year = next.value!.year.toString();
                            testLabel = "ทดสอบถัดไป: ${next.key} ($day-$month-$year)";
                          } else {
                            testLabel = "ทดสอบถัดไป: ไม่พบการทดสอบ";
                          }

                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            decoration: BoxDecoration(
                              color: bgColor,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: ListTile(
                              leading: const Icon(
                                Icons.science,
                                color: Colors.blueGrey,
                                size: 36,
                              ),
                              title: Text(
                                item["ProductName"] ?? "ไม่ทราบชื่อสาร",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueGrey,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(Icons.category, size: 16, color: Colors.blueGrey),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          "ประเภท: ${item["ChemicalType"] ?? "-"}",
                                          style: const TextStyle(fontSize: 14, color: Colors.black87),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Row(
                                    children: [
                                      const Icon(Icons.calendar_today, size: 16, color: Colors.teal),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          "ผลิต: ${formatDate(item["ProductionDate"])} | หมดอายุ: ${formatDate(item["ExpireDate"])}",
                                          style: const TextStyle(fontSize: 13.5, color: Colors.black87),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Row(
                                    children: [
                                      const Icon(Icons.science_outlined, size: 16, color: Colors.indigo),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          testLabel,
                                          style: const TextStyle(fontSize: 13.5, color: Colors.black87),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Row(
                                    children: [
                                      const Icon(Icons.location_on_outlined, size: 16, color: Colors.redAccent),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          "ที่เก็บ: ${item["LocationKeep"] ?? "-"}",
                                          style: const TextStyle(fontSize: 13.5, color: Colors.black87),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Row(
                                    children: [
                                      const Icon(Icons.warning_amber_rounded, size: 16, color: Colors.orange),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          "Uneg: ${item["Uneg"] ?? "-"}",
                                          style: const TextStyle(fontSize: 13.5, color: Colors.black87),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                                onPressed: () {
                                  setState(() {
                                    dataList.removeAt(index);
                                  });
                                },
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
