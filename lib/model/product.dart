class Product {
  Product({
    required this.id,
    required this.productname,
    required this.description,
    required this.price,
    required this.imageproduct,
    required this.category,
  });

  final String? id;
  final String? productname;
  final String? description;
  final int? price;
  final String? imageproduct;
  final String? category;

  factory Product.fromJson(Map<String, dynamic> json){
    return Product(
      id: json["_id"],
      productname: json["productname"],
      description: json["description"],
      price: json["price"],
      imageproduct: json["imageproduct"],
      category: json["category"],
    );
  }

}
