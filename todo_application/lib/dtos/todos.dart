class Todo {
  bool checked = false;
  late String todo;
  Todo(this.todo, [this.checked = false]);
  @override
  String toString() {
    return "$checked,$todo";
  }
}
