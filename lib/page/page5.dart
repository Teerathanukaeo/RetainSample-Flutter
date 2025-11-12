import 'package:flutter/material.dart';

import 'P3Search/P3Search.dart';

class Page5 extends StatelessWidget {
  final List<dynamic> data;

  const Page5({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff0f0f0), // 🔹 พื้นหลังเทาอ่อน
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
              // 🔹 แถวปุ่มย้อนกลับ + ชื่อหัวข้อ
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
                    "ตัวอย่างทั้งหมด",
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

              // 🔹 เนื้อหาหลัก (ListView)
              Expanded(
                child: data.isEmpty
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
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          final item = data[index];

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

                          return InkWell(
                            onTap: () {
                              // ✅ เมื่อกด ส่งข้อมูล item ไปหน้า Page3Body
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => Page3Body(selectedItem: item),
                                ),
                              );
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
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

                                    // 🧩 ประเภทสาร
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

                                    // 📅 วันที่ผลิต / หมดอายุ
                                    Row(
                                      children: [
                                        const Icon(Icons.calendar_today, size: 16, color: Colors.teal),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Builder(
                                            builder: (context) {
                                              String formatDate(String? rawDate) {
                                                if (rawDate == null || rawDate.isEmpty) return "-";
                                                try {
                                                  final d = DateTime.parse(rawDate);
                                                  final day = d.day.toString().padLeft(2, '0');
                                                  final month = d.month.toString().padLeft(2, '0');
                                                  final year = d.year.toString();
                                                  return "$day-$month-$year";
                                                } catch (_) {
                                                  return rawDate;
                                                }
                                              }

                                              final prod = formatDate(item["ProductionDate"]);
                                              final exp = formatDate(item["ExpireDate"]);

                                              return Text(
                                                "ผลิต: $prod   |   หมดอายุ: $exp",
                                                style: const TextStyle(fontSize: 13.5, color: Colors.black87),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 2),

                                    // 🔬 ทดสอบถัดไป
                                    Builder(
                                      builder: (context) {
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
                                          final dateStr = "$day-$month-$year";
                                          testLabel = "ทดสอบถัดไป: ${next.key} ($dateStr)";
                                        } else {
                                          testLabel = "ไม่มีการทดสอบที่รอดำเนินการ";
                                        }

                                        return Row(
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
                                        );
                                      },
                                    ),
                                    const SizedBox(height: 2),

                                    // 📍 ที่เก็บ
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

                                    // ⚠️ Uneg
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
