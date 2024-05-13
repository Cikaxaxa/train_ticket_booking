import 'dart:async';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class Train {
  final int id;
  final String name;


  Train({required this.id, required this.name});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }
}


class DatabaseHelper {
  static Database? _database;
  static final DatabaseHelper instance = DatabaseHelper._();

  DatabaseHelper._();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, 'train.db');
    return await openDatabase(path, version: 1, onCreate: _createDb);
  }

  Future<void> open() async {
    _database = await openDatabase(
      'path_to_your_database.db',
      version: 1,
      onCreate: (Database db, int version) async {
        // Database creation logic goes here
      },
    );
  }

  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY,
        username TEXT,
        password TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE bookings (
        id INTEGER PRIMARY KEY,
        username TEXT,
        origin TEXT,
        destination TEXT,
        departureDate TEXT,
        returnDate TEXT,
        numberOfPassengers INTEGER,
        trainId INTEGER,
        coachNumber INTEGER,
        seatNumber INTEGER,
        totalprice DOUBLE
      )
    ''');

    await db.execute('''
      CREATE TABLE trains (
        id INTEGER PRIMARY KEY,
        name TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE coaches (
        id INTEGER PRIMARY KEY,
        trainId INTEGER,
        coachNumber INTEGER,
        FOREIGN KEY(trainId) REFERENCES trains(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE seats (
        id INTEGER PRIMARY KEY,
        coachId INTEGER,
        seatNumber INTEGER,
        isBooked INTEGER DEFAULT 0,
        FOREIGN KEY(coachId) REFERENCES coaches(id)
      )
    ''');


  }

  Future<int> insertUser(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert('users', row);
  }

  Future<List<Map<String, dynamic>>> queryUser(String username) async {
    Database db = await instance.database;
    return await db.query(
        'users', where: 'username = ?', whereArgs: [username]);
  }

  Future<int> insertBooking(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert('bookings', row);
  }

  Future<List<Map<String, dynamic>>> queryBookings(String username) async {
    Database db = await instance.database;
    return await db.query(
        'bookings', where: 'username = ?', whereArgs: [username]);
  }

  Future<int> insertTrain(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert('trains', row);
  }



  Future<int> insertCoach(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert('coaches', row);
  }

  Future<int> insertSeat(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert('seats', row);
  }

  Future<List<Map<String, dynamic>>> queryAvailableSeats(int coachId) async {
    Database db = await instance.database;
    return await db.query('seats', where: 'coachId = ? AND isBooked = ?',
        whereArgs: [coachId, 0]);
  }


  Future<List<Map<String, dynamic>>> queryCoach(int trainId,
      int coachNumber) async {
    await open();
    return await _database!.rawQuery('''
      select coachNumber
      FROM coaches 
      LEFT JOIN trains ON coaches.trainId = trains.id
      where trainId = ?  
    ''', [trainId]);
  }

  Future<List<Map<String, dynamic>>> queryTrain() async {
    await open();
    return await _database!.rawQuery('''
      select name
      from trains 
    ''');
  }

  Future<List<Map<String, dynamic>>> querySeats(int trainId,
      int coachNumber) async {
    await open();
    return await _database!.rawQuery('''
      SELECT seatNumber
      FROM seats 
      LEFT JOIN coaches ON seats.coachId = coaches.id
      LEFT JOIN trains ON coaches.trainId = trains.id
      WHERE trainId = ? AND coachNumber = ?
    ''', [trainId, coachNumber]);
  }

  Future<List<Map<String, dynamic>>> getTrainData() async {
    try {
      Database db = await database;
      return await db.query('trains');
    } catch (e) {
      print('Error fetching train data: $e');
      return []; // Return an empty list in case of error
    }
  }

  Future<List<String>> getTrainNames() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
        'trains', columns: ['name']);
    return List.generate(maps.length, (i) => maps[i]['name'] as String);
  }

  Future<List<Train>> fetchTrains() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('trains');
    return List.generate(maps.length, (i) {
      return Train(
        id: maps[i]['id'],
        name: maps[i]['name'],

      );
    });
  }

  Future<List<int>> fetchCoachNumbers(int trainId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'coaches',
      where: 'trainId = ?',
      whereArgs: [trainId],
    );
    return List.generate(maps.length, (i) {
      return maps[i]['coachNumber'];
    });
  }

  Future<List<int>> fetchSeatNumbers(int coachId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'seats',
      where: 'coachId = ? AND isBooked = ?',
      whereArgs: [coachId, 0],
    );
    return List.generate(maps.length, (i) {
      return maps[i]['seatNumber'];
    });
  }

  Future<void> insertBookingSeat({
    required int trainId,
    required String username,
    required int coachNumber,
    required List<int> seatNumbers,
    required double totalPrice,
    required String origin ,
    required String destination ,
    required String departureDate,
    required String returnDate ,
    required int numberOfPassengers ,
  }) async {
    final db = await database;
    Batch batch = db.batch();

    for (int seatNumber in seatNumbers) {
      batch.insert('bookings', {
        'trainId': trainId,
        'username': username,
        'coachNumber': coachNumber,
        'seatNumber': seatNumber,
        'totalPrice': totalPrice,
        'origin ': origin ,
        'destination': destination,
        'departureDate': departureDate,
        'returnDate': returnDate,
        'numberOfPassengers': numberOfPassengers// Assuming 'totalPrice' column is added in the table
      });
    }

    await batch.commit();
  }


  Future<void> updateSeatStatus({
    required List<int> selectedSeatNumbers, // Change to named argument
    required int coachNumber,
    required int seatNumber,
    required int isBooked,
  }) async {
    final db = await database;
    await db.update(
      'seats',
      {'isBooked': isBooked},
      where: 'coachId = ? AND seatNumber = ?',
      whereArgs: [coachNumber, seatNumber],
    );
  }

  Future<List<Map<String, dynamic>>> queryTrainSeat(String username) async {
    Database db = await instance.database;
    return await db.query(
        'bookingseat', where: 'username = ?', whereArgs: [username]);
  }

  Future<void> addTestData() async {
    // Check if test data already exists
    final List<Train> existingTrains = await fetchTrains();
    if (existingTrains.isNotEmpty) {
      print('Test data already exists.');
      return;
    }

    // Add 3 trains
    for (int i = 1; i <= 3; i++) {
      int trainId = await insertTrain({'name': 'Train $i'});
      // Add coaches for each train
      for (int j = 1; j <= 6; j++) {
        int coachId = await insertCoach({'trainId': trainId, 'coachNumber': j});
        // Add seats for each coach
        for (int k = 1; k <= 20; k++) {
          await insertSeat({'coachId': coachId, 'seatNumber': k});
        }
      }
    }
  }

}

