class Medicine {
  String? id;
  String? name;
  int? container;
  int? quantity;

  Medicine({
    required this.id,
    required this.name,
    required this.container,
    required this.quantity,
  });
  factory Medicine.fromJson(Map<String, dynamic> json) {
    return Medicine(
      id: json['_id'],
      name: json['name'],
      container: json['container'],
      quantity: json['quantity'],
    );
  }
}
