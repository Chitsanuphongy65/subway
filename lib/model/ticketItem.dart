class TicketItem {
  int? keyID;
  String departureStation; // สถานีต้นทาง
  String destinationStation; // สถานีปลายทาง
  DateTime travelDate; // วันที่เดินทาง
  int numberOfPassengers; // จำนวนผู้โดยสาร
  String passengerName; // ชื่อผู้โดยสาร
  String phoneNumber; // เบอร์โทรศัพท์
  String paymentMethod; // วิธีการชำระเงิน (credit/debit)
  double totalPrice; // ราคารวม

  TicketItem({
    this.keyID,
    required this.departureStation,
    required this.destinationStation,
    required this.travelDate,
    required this.numberOfPassengers,
    required this.passengerName,
    required this.phoneNumber,
    required this.paymentMethod,
    required this.totalPrice,
  });
}