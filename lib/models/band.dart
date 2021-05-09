class Band {
  String id;
  String name;
  int votes;
  Band({this.id, this.name, this.votes});

  // ignore: non_constant_identifier_names
  factory Band.FromMap(Map<String, dynamic> map) => Band(
      // id: map['id'], name: map['name'], votes: map['votes']
      id: map.containsKey('id') ? map['id'] : 'no-id',
      name: map.containsKey('name') ? map['name'] : 'no-name',
      votes: map.containsKey('votes') ? map['votes'] : 'no-votes');
}
