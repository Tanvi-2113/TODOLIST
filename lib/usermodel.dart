class TableValues {
    int? id;
    final String task;

    TableValues({
       this.id,
        required this.task,
    });

    factory TableValues.fromJson(Map<String, dynamic> json) => TableValues(
        id: json["id"],
        task: json["task"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "task": task,
    };
}