import 'package:flutter/foundation.dart';
import 'package:account/model/ticketItem.dart';
import 'package:account/database/ticketDB.dart';

class TicketProvider with ChangeNotifier {
  List<TicketItem> tickets = [];

  List<TicketItem> getTickets() {
    return tickets;
  }

  void initData() async {
    var db = TicketDB(dbName: 'tickets.db');
    tickets = await db.loadAllTickets();
    notifyListeners();
  }

  void addTicket(TicketItem ticket) async {
    var db = TicketDB(dbName: 'tickets.db');
    await db.insertTicket(ticket);
    tickets = await db.loadAllTickets();
    notifyListeners();
  }

  void deleteTicket(TicketItem ticket) async {
    var db = TicketDB(dbName: 'tickets.db');
    await db.deleteTicket(ticket);
    tickets = await db.loadAllTickets();
    notifyListeners();
  }

  void updateTicket(TicketItem ticket) async {
    var db = TicketDB(dbName: 'tickets.db');
    await db.updateTicket(ticket);
    tickets = await db.loadAllTickets();
    notifyListeners(); // แจ้งเตือนการเปลี่ยนแปลง
  }
}