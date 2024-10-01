import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../model/product.dart';

class DetailsProduct extends StatefulWidget {
  final Product product;

  const DetailsProduct({super.key, required this.product});

  @override
  _DetailsProductState createState() => _DetailsProductState();
}

class _DetailsProductState extends State<DetailsProduct> {
  bool _isExpanded = false;
  int quantity = 1;

  void increment() {
    setState(() {
      quantity++;
    });
  }

  void decrement() {
    setState(() {
      if (quantity > 1) {
        quantity--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chi tiết sản phẩm"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  child: Image.network(
                    widget.product.imageproduct ?? "",
                    width: MediaQuery.of(context).size.width,
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                ),
                const Positioned(
                  bottom: 10,
                  right: 10,
                  child: Row(
                    children: [
                      Icon(
                        CupertinoIcons.heart,
                        size: 30,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(
                        CupertinoIcons.clock,
                        size: 30,
                      )
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.productname ?? "",
                    style: const TextStyle(fontSize: 25),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "${widget.product.price} vnđ",
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.product.description ?? "",
                    style: const TextStyle(
                      fontSize: 20,
                      color: Color(0xff8c8c8c),
                    ),
                    maxLines: _isExpanded ? null : 3,
                    overflow: _isExpanded ? null : TextOverflow.ellipsis,
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _isExpanded = !_isExpanded;
                      });
                    },
                    child: Text(
                      _isExpanded ? "Thu gọn" : "Xem thêm",
                      style: const TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                IconButton(
                    onPressed: decrement, icon: const Icon(Icons.remove)),
                Text(quantity.toString()),
                IconButton(onPressed: increment, icon: const Icon(Icons.add)),
              ],
            )
          ],
        ),
      ),
      // bottomNavigationBar: BottomAppBar(
      //   child: ,
      // ),
    );
  }
}
