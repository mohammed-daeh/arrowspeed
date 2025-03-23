// ignore_for_file: prefer_interpolation_to_compose_strings, avoid_print, deprecated_member_use
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:arrowspeed/core/app_colors/app_colors.dart';
import 'package:arrowspeed/core/translation/translation.dart';
import 'package:arrowspeed/featuers/booking/data/models/ticket_model.dart';
import 'package:arrowspeed/sheard/widgets/custom_header_screens_widget.dart';
import 'package:arrowspeed/featuers/home/presentation/screens/widgets/dotted_line_with_icon.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

class TicketDetails extends StatelessWidget {
  final TicketModel ticketData;

  TicketDetails({super.key, required this.ticketData});


  final ScreenshotController screenshotController = ScreenshotController();
  String encryptTicketData(TicketModel data) {
    final key = encrypt.Key.fromUtf8('16charSecretKey!'); 
    final iv = encrypt.IV.fromLength(16); 
    final encrypter = encrypt.Encrypter(encrypt.AES(key));

    String ticketJson = jsonEncode(data.toJson());

    final encrypted = encrypter.encrypt(ticketJson, iv: iv);
    return base64.encode(iv.bytes) + ":" + encrypted.base64; 
  }
  
  Future<void> _exportToPDF() async {
    try {
      var status = await Permission.storage.request();
      if (!status.isGranted) {
        print("❌ لم يتم منح إذن التخزين!");
        return;
      }
      await Future.delayed(
          Duration(milliseconds: 1000)); 

      final imageBytes = await screenshotController.capture();
      if (imageBytes == null) {
        print("❌ فشل التقاط لقطة الشاشة!");
        return;
      }

      final pdf = pw.Document();
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Image(
                pw.MemoryImage(imageBytes),
                fit: pw.BoxFit.contain,
              ),
            );
          },
        ),
      );

      final directory = (await getExternalStorageDirectory())!;
      if (!directory.existsSync()) {
        print("❌ مجلد Downloads غير موجود!");
        return;
      }
      final filePath = '${directory.path}/ticket_export.pdf';

      final file = File(filePath);
      await file.writeAsBytes(await pdf.save());
      print('✅ تم حفظ ملف PDF في: $filePath');

      OpenFile.open(filePath);
    } catch (e) {
      print("❌ خطأ أثناء التصدير إلى PDF: $e");
    }
  }

  Future<void> _shareScreenshotOnWhatsApp() async {
    try {
      final Uint8List? imageBytes = await screenshotController.capture();
      if (imageBytes == null) {
        print("⚠️ فشل التقاط لقطة الشاشة!");
        return;
      }

      final tempDir = await getTemporaryDirectory();
      final filePath = "${tempDir.path}/ticket_screenshot.png";
      final file = File(filePath);
      await file.writeAsBytes(imageBytes);

      await Share.shareXFiles([XFile(filePath)], text: "📸 هذه تذكرتي!");
    } catch (e) {
      print("❌ خطأ أثناء مشاركة لقطة الشاشة: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    String encryptedData = encryptTicketData(ticketData); // ✅ تشفير البيانات
    DateTime dateFrom = ticketData.dateFrom;
    DateTime dateTo = ticketData.dateTo;

    return Screenshot(
      controller: screenshotController,
      child: Scaffold(
        body: Column(
          children: [
            HeaderScreensInItemsProfile(
              height: 100,
              title: Utils.localize('TicketDetails'),
            ),
            Expanded(
              child: Stack(
                children: [
                  Positioned(
                    bottom: 10,
                    left: -10,
                    child: SvgPicture.asset(
                      'assets/logo/logo_blue.svg',
                      width: 100,
                      height: 100,
                      color: AppColors.greyHintForm,
                    ),
                  ),
                  Positioned(
                    top: 20,
                    bottom: 0,
                    right: 35,
                    left: 35,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 15, bottom: 25),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 35.0),
                                        child: Row(
                                          children: [
                                            CircleAvatar(
                                              backgroundColor: AppColors.white,
                                              maxRadius: 25,
                                              child: Image.asset(
                                                  'assets/logo/logo_color.png'),
                                            ),
                                            SizedBox(width: 18),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  ticketData.name,
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w500,
                                                    color: AppColors.oxfordBlue,
                                                  ),
                                                ),
                                                Text(
                                                  ' ${Utils.localize('ATrip')} ${ticketData.from} - ${ticketData.to}',
                                                  style: TextStyle(
                                                    color: AppColors.greyborder,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              children: [
                                                Text(
                                                  ticketData.from,
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    color: AppColors.oxfordBlue,
                                                  ),
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      DateFormat('yyyy-MM-dd')
                                                          .format(dateFrom),
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        color: AppColors
                                                            .greyborder,
                                                      ),
                                                    ),
                                                    Text(
                                                      DateFormat('HH:mm')
                                                          .format(dateFrom),
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        color: AppColors
                                                            .greyborder,
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                          DottedLineWithIcons(
                                            middleIconPath:
                                                'assets/icons/bas_icon.svg',
                                          ),
                                          Expanded(
                                            child: Column(
                                              children: [
                                                Text(
                                                  ticketData.to,
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    color: AppColors.oxfordBlue,
                                                  ),
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      DateFormat('yyyy-MM-dd')
                                                          .format(
                                                              dateTo), 
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        color: AppColors
                                                            .greyborder,
                                                      ),
                                                    ),
                                                    Text(
                                                      DateFormat('HH:mm').format(
                                                          dateTo),
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        color: AppColors
                                                            .greyborder,
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 15.0),
                                        child: CustomPaint(
                                          painter: DashedLinePainter(),
                                          size: const Size(double.infinity, 3),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15.0),
                                        child: IntrinsicHeight(
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              Expanded(
                                                flex: 3,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      Utils.localize(
                                                          'Passengers'),
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: AppColors
                                                            .greyIconForm,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          ticketData
                                                              .passengersCount,
                                                          style: TextStyle(
                                                              color: AppColors
                                                                  .prussianBlue,
                                                              fontSize: 12),
                                                        ),
                                                        SizedBox(width: 5),
                                                        Text(
                                                          Utils.localize(
                                                              'Person'),
                                                          style: TextStyle(
                                                              color: AppColors
                                                                  .prussianBlue,
                                                              fontSize: 12),
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      Utils.localize('SeatNo'),
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: AppColors
                                                            .greyIconForm,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    Text(
                                                      textAlign: TextAlign.left,
                                                      ticketData.seatNumbers,
                                                      style: TextStyle(
                                                          color: AppColors
                                                              .prussianBlue,
                                                          fontSize: 12),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      Utils.localize(
                                                          'TicketNo'),
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: AppColors
                                                            .greyIconForm,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    Text(
                                                      ticketData.ticketNumber,
                                                      style: TextStyle(
                                                          color: AppColors
                                                              .prussianBlue,
                                                          fontSize: 12),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 25,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15.0),
                                        child: IntrinsicHeight(
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              Expanded(
                                                flex: 3,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      Utils.localize(
                                                          'PassengersName'),
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: AppColors
                                                            .greyIconForm,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    Text(
                                                      ticketData
                                                          .passengersNames,
                                                      style: TextStyle(
                                                          color: AppColors
                                                              .prussianBlue,
                                                          fontSize: 12),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      Utils.localize(
                                                          'TicketFare'),
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: AppColors
                                                            .greyIconForm,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    Text(
                                                      '${ticketData.ticketFare} \$',
                                                      style: TextStyle(
                                                          color: AppColors
                                                              .prussianBlue,
                                                          fontSize: 12),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      Utils.localize(
                                                          'TicketNo'),
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: AppColors
                                                            .greyIconForm,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    Text(
                                                      ticketData.info,
                                                      style: TextStyle(
                                                          color: AppColors
                                                              .prussianBlue,
                                                          fontSize: 12),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        'Ticket Status: CONFIRMED',
                                        style: TextStyle(
                                          color: AppColors.prussianBlue,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        Utils.localize('Showthis'),
                                        style: TextStyle(
                                            color: AppColors.grey1,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      BarcodeWidget(
                                        color: AppColors.oxfordBlue,
                                        barcode: Barcode
                                            .pdf417(), 
                                        data:
                                            encryptedData, 
                                        width: 210,
                                        height: 80,
                                        drawText:
                                            false, 
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                left: -15,
                                right: -15,
                                bottom: 120,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: 40,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColors.greyback,
                                      ),
                                    ),
                                    Flexible(
                                      child: CustomPaint(
                                        painter: DashedLinePainter(),
                                        size: const Size(double.infinity, 3),
                                      ),
                                    ),
                                    Container(
                                      width: 40,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColors.greyback,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                right: Get.locale?.languageCode == 'ar'
                                    ? null
                                    : 15,
                                left: Get.locale?.languageCode == 'ar'
                                    ? 15
                                    : null,
                                top: 15,
                                child: PopupMenuButton<String>(
                                  onSelected: (String result) {
                                    if (result == "whatsapp") {
                                      _shareScreenshotOnWhatsApp();
                                      print("تم اختيار واتساب");
                                    } else if (result == "export") {
                                      _exportToPDF();
                                    }
                                  },
                                  itemBuilder: (BuildContext context) => [
                                    PopupMenuItem<String>(
                                      value: "whatsapp",
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(
                                            'assets/icons/whatsapp.svg',
                                            width: 15,
                                            height: 15,
                                            color: AppColors.prussianBlue,
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            Utils.localize('ShareWhatsApp'),
                                            style: TextStyle(
                                                color: AppColors.prussianBlue,
                                                fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ),
                                    PopupMenuItem<String>(
                                      value: "export",
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(
                                            'assets/icons/download.svg',
                                            width: 15,
                                            height: 15,
                                            color: AppColors.prussianBlue,
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            Utils.localize('PDFexport'),
                                            style: TextStyle(
                                                color: AppColors.prussianBlue,
                                                fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                  child: SvgPicture.asset(
                                    'assets/icons/share.svg',
                                    width: 15,
                                    height: 15,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            height: 600,
                            color: Colors.transparent,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}



// String decryptTicketData(String encryptedData) {
//   final key = encrypt.Key.fromUtf8('16charSecretKey!'); // نفس المفتاح المستخدم في التشفير
//   final encrypter = encrypt.Encrypter(encrypt.AES(key));

//   List<String> parts = encryptedData.split(":");
//   final iv = encrypt.IV.fromBase64(parts[0]);
//   final encryptedText = encrypt.Encrypted.fromBase64(parts[1]);

//   final decrypted = encrypter.decrypt(encryptedText, iv: iv);
//   return decrypted;
// }
