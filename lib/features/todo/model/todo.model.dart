class TodoModel {
  final String id;
  final String title;
  final String description;
  late final bool status;
  final String createdby;

  TodoModel({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.createdby,
  });
}
