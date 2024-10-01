import 'package:app_food/model/product.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ResponeFillter extends StatefulWidget {
  final List<Product> data;
  const ResponeFillter({super.key, required this.data});

  @override
  State<ResponeFillter> createState() => _ResponeFillterState();
}

class _ResponeFillterState extends State<ResponeFillter> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView.builder(
        itemCount: 2,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              // Navigator.push(context, MaterialPageRoute(builder: (context) =>  DetailsProduct(product: product,)));
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 3,
                          blurRadius: 6,
                          offset: const Offset(0, 3))
                    ]),
                child: Row(
                  children: [
                    ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                        ),
                        child: Image.network(
                          "https://photo.znews.vn/w660/Uploaded/qhj_yvobvhfwbv/2018_07_18/Nguyen_Huy_Binh1.jpg",
                          width: 150,
                          height: 200,
                          fit: BoxFit.cover,
                        )),
                    const Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment
                              .start,
                          children: [
                            Text(
                             "fsdfdjk",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "sdgusd",
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Color(0xff8c8c8c)),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
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
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
