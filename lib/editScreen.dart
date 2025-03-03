import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:account/model/ticketItem.dart';
import 'package:account/provider/ticketProvider.dart';
import 'package:intl/intl.dart';

class EditScreen extends StatefulWidget {
  final TicketItem item;

  const EditScreen({super.key, required this.item});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passengerNameController = TextEditingController();
  final _phoneNumberController =
      TextEditingController(); // เพิ่ม controller สำหรับเบอร์โทร
  final _numberOfPassengersController = TextEditingController();
  final _cardNumberController = TextEditingController(); // สำหรับหมายเลขบัตร
  DateTime _travelDate = DateTime.now();
  double _totalPrice = 0.0;

  // สถานีต้นทางและปลายทาง
  String? _selectedDepartureStation;
  String? _selectedDestinationStation;

  // วิธีการชำระเงิน
  String? _selectedPaymentMethod;

  // รายชื่อสถานี (ตัวอย่าง)
  final List<String> _stations = [
    'สถานีหลักสี่',
    'สถานีบางซื่อ',
    'สถานีพหลโยธิน',
    'สถานีสวนจตุจักร',
    'สถานีกำแพงเพชร',
    'สถานีบางเขน',
    'สถานีทุ่งสองห้อง',
    'สถานีบางบัว',
    'สถานีสะพานใหม่',
    'สถานีดอนเมือง',
    'สถานีรังสิต',
    'สถานีวัดพระศรีมหาธาตุ',
    'สถานีมหาวิทยาลัยเกษตรศาสตร์',
    'สถานีเสนานิคม',
    'สถานีลาดพร้าว',
  ];

  @override
  void initState() {
    super.initState();
    _selectedDepartureStation = widget.item.departureStation;
    _selectedDestinationStation = widget.item.destinationStation;
    _travelDate = widget.item.travelDate;
    _numberOfPassengersController.text =
        widget.item.numberOfPassengers.toString();
    _passengerNameController.text = widget.item.passengerName;
    _phoneNumberController.text = widget.item.phoneNumber; // เพิ่ม phoneNumber
    _selectedPaymentMethod = widget.item.paymentMethod;
    _totalPrice = widget.item.totalPrice;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _travelDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _travelDate) {
      setState(() {
        _travelDate = picked;
      });
    }
  }

  void _calculateTotalPrice() {
    int numberOfPassengers =
        int.tryParse(_numberOfPassengersController.text) ?? 0;
    setState(() {
      _totalPrice = numberOfPassengers * 20.0; // ราคาตั๋วต่อคน 40 บาท
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('แก้ไขการจองรถไฟใต้ดิน'),
        backgroundColor: Colors.green[800], // สีเขียวเข้ม
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // เลือกสถานีต้นทาง
              DropdownButtonFormField<String>(
                value: _selectedDepartureStation,
                decoration: InputDecoration(
                  labelText: 'สถานีต้นทาง',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.green[50], // สีพื้นหลังฟิลด์
                ),
                items: _stations.map((String station) {
                  return DropdownMenuItem<String>(
                    value: station,
                    child: Text(station),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedDepartureStation = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณาเลือกสถานีต้นทาง';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              // เลือกสถานีปลายทาง
              DropdownButtonFormField<String>(
                value: _selectedDestinationStation,
                decoration: InputDecoration(
                  labelText: 'สถานีปลายทาง',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.green[50], // สีพื้นหลังฟิลด์
                ),
                items: _stations.map((String station) {
                  return DropdownMenuItem<String>(
                    value: station,
                    child: Text(station),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedDestinationStation = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณาเลือกสถานีปลายทาง';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              // เลือกวันที่เดินทาง
              InkWell(
                onTap: () => _selectDate(context),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'วันที่เดินทาง',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.green[50], // สีพื้นหลังฟิลด์
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(DateFormat('dd/MM/yyyy').format(_travelDate)),
                      Icon(Icons.calendar_today),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              // จำนวนผู้โดยสาร
              TextFormField(
                controller: _numberOfPassengersController,
                decoration: InputDecoration(
                  labelText: 'จำนวนผู้โดยสาร',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.green[50], // สีพื้นหลังฟิลด์
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) => _calculateTotalPrice(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณากรอกจำนวนผู้โดยสาร';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              // ชื่อ-นามสกุลผู้โดยสาร
              TextFormField(
                controller: _passengerNameController,
                decoration: InputDecoration(
                  labelText: 'ชื่อผู้โดยสาร',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.green[50], // สีพื้นหลังฟิลด์
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณากรอกชื่อ';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              // เบอร์โทรศัพท์
              TextFormField(
                controller: _phoneNumberController,
                decoration: InputDecoration(
                  labelText: 'เบอร์โทรศัพท์',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.green[50], // สีพื้นหลังฟิลด์
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณากรอกเบอร์โทรศัพท์';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              // วิธีการชำระเงิน
              DropdownButtonFormField<String>(
                value: _selectedPaymentMethod,
                decoration: InputDecoration(
                  labelText: 'วิธีการชำระเงิน',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.green[50], // สีพื้นหลังฟิลด์
                ),
                items:
                    ['บัตรเครดิต', 'บัตรเดบิต', 'เงินสด'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedPaymentMethod = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณาเลือกวิธีการชำระเงิน';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              // กรอกหมายเลขบัตร (แสดงเฉพาะเมื่อเลือกบัตรเครดิต/เดบิต)
              if (_selectedPaymentMethod == 'บัตรเครดิต' ||
                  _selectedPaymentMethod == 'บัตรเดบิต')
                TextFormField(
                  controller: _cardNumberController,
                  decoration: InputDecoration(
                    labelText: 'หมายเลขบัตร',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.green[50], // สีพื้นหลังฟิลด์
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if ((_selectedPaymentMethod == 'บัตรเครดิต' ||
                            _selectedPaymentMethod == 'บัตรเดบิต') &&
                        (value == null || value.isEmpty)) {
                      return 'กรุณากรอกหมายเลขบัตร';
                    }
                    return null;
                  },
                ),
              SizedBox(height: 16),
              // ราคารวม
              Text(
                'ราคารวม: ${_totalPrice.toStringAsFixed(2)} บาท',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 24),
              // ปุ่มบันทึกการแก้ไข
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    var provider =
                        Provider.of<TicketProvider>(context, listen: false);

                    TicketItem updatedTicket = TicketItem(
                      keyID: widget.item.keyID,
                      departureStation: _selectedDepartureStation!,
                      destinationStation: _selectedDestinationStation!,
                      travelDate: _travelDate,
                      numberOfPassengers:
                          int.parse(_numberOfPassengersController.text),
                      passengerName: _passengerNameController.text,
                      phoneNumber:
                          _phoneNumberController.text, // เพิ่ม phoneNumber
                      paymentMethod: _selectedPaymentMethod!,
                      totalPrice: _totalPrice,
                    );

                    provider.updateTicket(updatedTicket); // อัปเดตข้อมูล
                    Navigator.pop(context); // กลับไปยังหน้าหลัก
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[800], // สีเขียวเข้ม
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'บันทึกการแก้ไข',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
