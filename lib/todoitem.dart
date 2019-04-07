class TodoItem extends Comparable {
  int id;
  final String title;
  bool done;

  TodoItem({this.title, this.done = false});
  
  TodoItem.fromMap(Map<String, dynamic> map)
  : id = map["id"],
    title = map["name"],
    done = map["isComplete"] == 1;  

  @override
  int compareTo(other) {
    if (this.done && !other.done) {
      return 1;
    } else if (!this.done && other.done) {
      return -1;
    } else {
      return this.id.compareTo(other.id);
    }
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      "name": title,
      "isComplete": done ? 1 : 0
    };
    // Allow for auto-increment
    if (id != null) {
      map["id"] = id;
    }
    return map;
  }
}