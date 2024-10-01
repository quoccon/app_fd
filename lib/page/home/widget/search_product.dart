import 'dart:async';

import 'package:app_food/blocs/product/product_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../details_product.dart';

class SearchWidget extends StatelessWidget {
  const SearchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => ProductCubit(),
        child: const SearchProduct(),
      ),
    );
  }
}

class SearchProduct extends StatefulWidget {
  const SearchProduct({super.key});

  @override
  State<SearchProduct> createState() => _SearchProductState();
}

class _SearchProductState extends State<SearchProduct> {
  TextEditingController searchController = TextEditingController();
  Timer? debounce;

  @override
  void initState() {
    super.initState();
    searchController.addListener(_onSearch);
  }

  void _onSearch() {
    if (debounce?.isActive ?? false) debounce!.cancel();
    debounce = Timer(const Duration(milliseconds: 500), () {
      final query = searchController.text;
      if (query.isNotEmpty) {
        context.read<ProductCubit>().searchProduct(query);
      } else {
        context.read<ProductCubit>().clearSearch();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 60,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color(0xffc8c8c8)),
              child: TextField(
                controller: searchController,
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Tìm kiếm ở đây...",
                    contentPadding:
                    EdgeInsets.symmetric(vertical: 20, horizontal: 20)),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: BlocBuilder<ProductCubit, ProductState>(
                builder: (context, state) {
                  switch(state.status){
                    case ProductStatus.initial:
                      return const Center(child: Text(""),);
                    case ProductStatus.loading:
                      return const Center(child: CircularProgressIndicator(),);
                    case ProductStatus.loaded:
                    return ListView.builder(
                      itemCount: state.products.length,
                      itemBuilder: (context, index) {
                        final product = state.products[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) =>  DetailsProduct(product: product,)));
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
                                        product.imageproduct??"",
                                        width: 150,
                                        height: 200,
                                        fit: BoxFit.cover,
                                      )),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.all(12.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        children: [
                                          Text(
                                            product.productname??"",
                                            style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            product.description??"",
                                            style: const TextStyle(
                                                fontSize: 15,
                                                color: Color(0xff8c8c8c)),
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          const Row(
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
                    );
                    case ProductStatus.error:
                      return Center(child: Text("Lỗi rồi :${state.error}"),);
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
