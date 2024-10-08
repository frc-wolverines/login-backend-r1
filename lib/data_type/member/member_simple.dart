class SimpleMember {
  SimpleMember({required this.name, required this.id});

  final String name;
  final int id;
  bool removed = false;

  factory SimpleMember.from(Map<String, dynamic> map) {
    final name = map['name'];
    final id = map['id'];
    return SimpleMember(name: name, id: id);
  }

  void remove() {
    removed = true;
  }

  Map<String, dynamic> map() {
    return {
      'name': name,
      'id': id,
      'removed': removed
    };
  }
}