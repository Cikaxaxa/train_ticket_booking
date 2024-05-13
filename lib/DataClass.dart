import 'dart:math';

class Train {
  final String id;
  final String name;
  final List<Coach> coaches;

  Train({required this.id, required this.name, required this.coaches});

  factory Train.generate(String id, String name) {
    List<Coach> coaches = List.generate(6, (index) {
      return Coach.generate('$id${index + 1}');
    });
    return Train(id: id, name: name, coaches: coaches);
  }
}

class Coach {
  final String id;
  final List<Seat> seats;

  Coach({required this.id, required this.seats});

  factory Coach.generate(String id) {
    List<Seat> seats = List.generate(20, (index) {
      return Seat(id: '$id${index + 1}');
    });
    return Coach(id: id, seats: seats);
  }
}

class Seat {
  final String id;

  Seat({required this.id});
}

void main() {
  List<Train> trains = List.generate(3, (index) {
    return Train.generate('T${index + 1}', 'Train ${index + 1}');
  });

  // Print details of each train
  for (var train in trains) {
    print('Train: ${train.name}, Coaches: ${train.coaches.length}');
    for (var coach in train.coaches) {
      print('  Coach: ${coach.id}, Seats: ${coach.seats.length}');
    }
  }
}