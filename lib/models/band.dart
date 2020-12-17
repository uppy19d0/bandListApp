class Band {
  String id;
  String name;
  int votes;
  Band({this.id, this.name, this.votes});

  factory Band.FromMap(Map<String, dynamic> map) =>
      Band(id: map['id'], name: map['name'], votes: map['votes']);
}
