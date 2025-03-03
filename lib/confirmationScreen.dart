import 'package:flutter/material.dart';
import 'package:account/model/ticketItem.dart';
import 'package:intl/intl.dart';

class ConfirmationScreen extends StatelessWidget {
  final TicketItem ticket;

  const ConfirmationScreen({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 187, 223, 191),
      appBar: AppBar(
        title: const Text('ยืนยันการจองรถไฟใต้ดิน'),
        backgroundColor: const Color.fromARGB(255, 23, 127, 26),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ส่วนหัวตั๋ว
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 23, 127, 26),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'รถไฟใต้ดิน',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Icon(
                              Icons.train,
                              color: Colors.white,
                              size: 40,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16),
                      // ข้อมูลตั๋ว
                      Text(
                        'สถานีต้นทาง: ${ticket.departureStation}',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'สถานีปลายทาง: ${ticket.destinationStation}',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'วันที่เดินทาง: ${DateFormat('dd/MM/yyyy').format(ticket.travelDate)}',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'จำนวนผู้โดยสาร: ${ticket.numberOfPassengers} คน',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'ชื่อผู้โดยสาร: ${ticket.passengerName}',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'เบอร์โทรศัพท์: ${ticket.phoneNumber}', // เพิ่มการแสดงเบอร์โทร
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'วิธีการชำระเงิน: ${ticket.paymentMethod}',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'ราคารวม: ${ticket.totalPrice.toStringAsFixed(2)} บาท',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24),
              // ปุ่มกลับหน้าหลัก
              ElevatedButton(
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'กลับหน้าหลัก',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
