import 'dart:io';
import 'package:account/model/ticketItem.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast_web/sembast_web.dart';
import 'package:flutter/foundation.dart';

class TicketDB {
  String dbName;

  TicketDB({required this.dbName});

  Future<Database> openDatabase() async {
    DatabaseFactory dbFactory;
    String dbLocation;

    if (kIsWeb) {
      dbFactory = databaseFactoryWeb;
      dbLocation = dbName;
    } else {
      Directory appDir = await getApplicationDocumentsDirectory();
      dbLocation = join(appDir.path, dbName);
      dbFactory = databaseFactoryIo;
    }

    Database db = await dbFactory.openDatabase(dbLocation);
    return db;
  }

  Future<int> insertTicket(TicketItem ticket) async {
    var db = await openDatabase();
    var store = intMapStoreFactory.store('tickets');

    Future<int> keyID = store.add(db, {
      'departureStation': ticket.departureStation,
      'destinationStation': ticket.destinationStation,
      'travelDate': ticket.travelDate.toIso8601String(),
      'numberOfPassengers': ticket.numberOfPassengers,
      'passengerName': ticket.passengerName,
      'phoneNumber': ticket.phoneNumber,
      'paymentMethod': ticket.paymentMethod,
      'totalPrice': ticket.totalPrice,
    });
    db.close();
    return keyID;
  }

  Future<List<TicketItem>> loadAllTickets() async {
    var db = await openDatabase();
    var store = intMapStoreFactory.store('tickets');

    var snapshot = await store.find(db,
        finder: Finder(sortOrders: [SortOrder('travelDate', false)]));

    List<TicketItem> tickets = [];

    for (var record in snapshot) {
      TicketItem ticket = TicketItem(
        keyID: record.key,
        departureStation: record['departureStation'].toString(),
        destinationStation: record['destinationStation'].toString(),
        travelDate: DateTime.parse(record['travelDate'].toString()),
        numberOfPassengers: int.parse(record['numberOfPassengers'].toString()),
        passengerName: record['passengerName'].toString(),
        phoneNumber: record['phoneNumber'].toString(), // เพิ่มฟิลด์ phoneNumber
        paymentMethod: record['paymentMethod'].toString(),
        totalPrice: double.parse(record['totalPrice'].toString()),
      );
      tickets.add(ticket);
    }
    db.close();
    return tickets;
  }

  deleteTicket(TicketItem ticket) async {
    var db = await openDatabase();
    var store = intMapStoreFactory.store('tickets');
    store.delete(db,
        finder: Finder(filter: Filter.equals(Field.key, ticket.keyID)));
    db.close();
  }

  updateTicket(TicketItem ticket) async {
    var db = await openDatabase();
    var store = intMapStoreFactory.store('tickets');

    store.update(
        db,
        {
          'departureStation': ticket.departureStation,
          'destinationStation': ticket.destinationStation,
          'travelDate': ticket.travelDate.toIso8601String(),
          'numberOfPassengers': ticket.numberOfPassengers,
          'passengerName': ticket.passengerName,
          'phoneNumber': ticket.phoneNumber,
          'paymentMethod': ticket.paymentMethod,
          'totalPrice': ticket.totalPrice,
        },
        finder: Finder(filter: Filter.equals(Field.key, ticket.keyID)));

    db.close();
  }
}
