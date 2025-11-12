import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:newmaster/page/P3Search/P3Search.dart';

class Page4 extends StatelessWidget {
  final List<dynamic> data;

  const Page4({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff0f0f0),
      body: Center(
        child: Container(
          width: 454,
          height: 1100,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Colors.white, Color(0xfff7f9fb)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.25),
                blurRadius: 20,
                spreadRadius: 3,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 แถวปุ่มย้อนกลับ + หัวข้อ
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
              // 🔹 รายการข้อมูล
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
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // 🔹 ด้านซ้าย (รายละเอียดสาร)
                                Expanded(
                                  child: InkWell(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      bottomLeft: Radius.circular(12),
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => Page3Body(selectedItem: item),
                                        ),
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              _buildImageIcon(item),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      item["ProductName"] ?? "ไม่ทราบชื่อสาร",
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.blueGrey,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 4),
                                                    _buildSubtitle(item),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 6),
                                          const Divider(
                                            height: 1,
                                            color: Colors.black26,
                                            thickness: 0.8,
                                          ),
                                          const SizedBox(height: 3),
                                          _buildDateInfo(item),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                // 🔹 ปุ่มเครื่องพิมพ์
                                _PrintButton(item: item),
                              ],
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

  Widget _buildImageIcon(Map<String, dynamic> item) {
    final imageName = item["ChemicalPhysic"] ?? "default";
    return Container(
      alignment: Alignment.topCenter,
      margin: const EdgeInsets.only(top: 2, right: 6),
      child: SizedBox(
        width: 50,
        height: 100,
        child: Transform.scale(
          scale: 1.15,
          child: Image.asset(
            'assets/images/$imageName.png',
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => const Icon(
              Icons.image_not_supported,
              size: 45,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSubtitle(Map<String, dynamic> item) {
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

    String testLabel = "ไม่มีการทดสอบที่รอดำเนินการ";
    DateTime? soonest;
    String? soonestLabel;

    for (final entry in tests.entries) {
      final d = entry.value;
      if (d != null && d.isAfter(now)) {
        if (soonest == null || d.isBefore(soonest)) {
          soonest = d;
          soonestLabel = entry.key;
        }
      }
    }

    if (soonest != null) {
      testLabel = "ทดสอบถัดไป: $soonestLabel (${soonest!.day.toString().padLeft(2, '0')}-${soonest!.month.toString().padLeft(2, '0')}-${soonest!.year})";
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
        Row(
          children: [
            const Icon(Icons.qr_code_rounded, size: 16, color: Colors.orange),
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
    );
  }

  Widget _buildDateInfo(Map<String, dynamic> item) {
    String formatDate(String? rawDate) {
      if (rawDate == null || rawDate.isEmpty) return "-";
      try {
        final d = DateTime.parse(rawDate);
        return "${d.day.toString().padLeft(2, '0')}-${d.month.toString().padLeft(2, '0')}-${d.year}";
      } catch (_) {
        return rawDate;
      }
    }

    final prod = formatDate(item["ProductionDate"]);
    final exp = formatDate(item["ExpireDate"]);

    return Row(
      children: [
        const SizedBox(width: 65),
        const Icon(Icons.calendar_today, size: 16, color: Colors.teal),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            "ผลิต: $prod   |   หมดอายุ: $exp",
            style: const TextStyle(fontSize: 13.5, color: Colors.black87),
          ),
        ),
      ],
    );
  }
}

/// 🔹 ปุ่ม Print ที่สร้าง QR Code จาก Uneg แล้วส่ง ZPL ไปเครื่อง Zebra
class _PrintButton extends StatefulWidget {
  final Map<String, dynamic> item;
  const _PrintButton({required this.item});

  @override
  State<_PrintButton> createState() => _PrintButtonState();
}

class _PrintButtonState extends State<_PrintButton> {
  bool _pressed = false;

  Future<String> _generateQrZpl(String data, {int size = 250}) async {
    final qrValidationResult = QrValidator.validate(
      data: data,
      version: QrVersions.auto,
      errorCorrectionLevel: QrErrorCorrectLevel.Q,
    );
    if (qrValidationResult.status != QrValidationStatus.valid) {
      throw Exception('Invalid QR data');
    }

    final qrCode = qrValidationResult.qrCode!;
    final painter = QrPainter.withQr(
      qr: qrCode,
      color: const Color(0xFF000000),
      emptyColor: const Color(0xFFFFFFFF),
      gapless: true,
    );

    // ใช้ toImageData แทน toImage
    final picData = await painter.toImageData(size.toDouble(), format: ui.ImageByteFormat.rawRgba);
    if (picData == null) throw Exception("Failed to get image bytes");

    final bytes = picData.buffer.asUint8List();

    // สร้าง ZPL ASCII
    StringBuffer sb = StringBuffer();
    sb.write('^GFA,${size * size},${size * size},$size,');
    for (int i = 0; i < bytes.length; i += 4) {
      final r = bytes[i];
      final g = bytes[i + 1];
      final b = bytes[i + 2];
      sb.write((r + g + b) ~/ 3 < 128 ? '1' : '0');
    }

    return sb.toString();
  }

  Future<void> _sendToPrinter(Map<String, dynamic> item) async {
    final printerIp = '172.26.20.4';
    final printerPort = 9100;

    final uneq = item["Uneg"] ?? "-";
    final product = item["ProductName"] ?? "-";
    final type = item["ChemicalType"] ?? "-";
    final prodDate = item["ProductionDate"] ?? "-";
    final expDate = item["ExpireDate"] ?? "-";
    final keep = item["LocationKeep"] ?? "-";
    final waste = item["LocationWaste"] ?? "-";
    final input = item["InputData"] ?? "-";

    try {
      final qrZpl = await _generateQrZpl(uneq, size: 250);

      final zpl = '''
^XA
^PW1100
^LL780
^CF0,45
^FO40,40^FDProduct:^FS
^FO250,40^FD$product^FS
^FO40,100^FDChemical:^FS
^FO250,100^FD$type^FS
^FO40,160^FDProd Date:^FS
^FO250,160^FD$prodDate^FS
^FO40,220^FDExpire:^FS
^FO250,220^FD$expDate^FS
^FO40,280^FDKeep:^FS
^FO250,280^FD$keep^FS
^FO40,340^FDWaste:^FS
^FO250,340^FD$waste^FS
^FO40,400^FDInput:^FS
^FO250,400^FD$input^FS
^FO40,460^FDUneq:^FS
^FO250,460^FD$uneq^FS
^FO750,100
$qrZpl
^XZ
''';

      final socket = await Socket.connect(printerIp, printerPort, timeout: const Duration(seconds: 5));
      socket.write(zpl);
      await socket.flush();
      await socket.close();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("✅ ส่งข้อมูลไปที่เครื่องพิมพ์: $uneq"),
          duration: const Duration(seconds: 1),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("❌ ไม่สามารถพิมพ์ได้: $e"),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        _sendToPrinter(widget.item);
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        height: 150,
        width: 55,
        alignment: Alignment.center,
        transform: Matrix4.identity()..scale(_pressed ? 0.92 : 1.0),
        decoration: BoxDecoration(
          color: _pressed ? Colors.blueGrey.withOpacity(0.3) : Colors.blueGrey.withOpacity(0.15),
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(12),
            bottomRight: Radius.circular(12),
          ),
        ),
        child: const Icon(
          Icons.print,
          color: Colors.blueGrey,
          size: 26,
        ),
      ),
    );
  }
}
