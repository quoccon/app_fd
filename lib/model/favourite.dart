import 'package:app_food/model/product.dart';

class WithList {
  WithList({
    required this.id,
    required this.productId,
    required this.quantity,
    required this.v,
  });

  final String? id;
  final Product? productId;
  final int? quantity;
  final int? v;

  factory WithList.fromJson(Map<String, dynamic> json){
    return WithList(
      id: json["_id"],
      productId: json["productId"] == null ? null : Product.fromJson(json["productId"]),
      quantity: json["quantity"],
      v: json["__v"],
    );
  }

}

