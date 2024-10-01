import 'package:app_food/blocs/product/product_cubit.dart';
import 'package:app_food/model/product.dart';
import 'package:app_food/page/home/details_product.dart';
import 'package:app_food/page/home/widget/fillter_data.dart';
import 'package:app_food/page/home/widget/search_product.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: BlocProvider(
        create: (context) => ProductCubit(),
        child: const HomePage(),
      ),
    );
  }
}


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isFavorite = false;


  @override
  Widget build(BuildContext context) {
    context.read<ProductCubit>().getListProduct();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("Danh sách"),
        actions:  [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchWidget()));
                },
                  child: Icon(Icons.search)
              ),
              SizedBox(
                width: 10,
              ),
              GestureDetector(
                onTap: (){
                  showMaterialModalBottomSheet(context: context, builder: (context) => const FillterData());
                },
                  child: Icon(Icons.filter_list)
              )
            ],
          )
        ],
      ),
      body: BlocBuilder<ProductCubit, ProductState>(
        builder: (context, state) {
          switch(state.status){
            case ProductStatus.initial:
              return const Center(child: Text("Không có sản phẩm nào"),);
            case ProductStatus.loading:
              return const Center(child: CircularProgressIndicator(),);
            case ProductStatus.loaded:
            return ListView.builder(
              itemCount: state.products.length,
              itemBuilder: (context, index) {
                Product product = state.products[index];
                return Padding(
                  padding:
                  const EdgeInsets.only(top: 10.0, right: 20.0, left: 20.0),
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
                        GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => DetailsProduct(product: product)));
                          },
                          child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                              ),
                              child: Image.network(product?.imageproduct??"",width: 150,height: 200,fit: BoxFit.cover,)
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product?.productname??"",
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  product?.description??"",
                                  style: const TextStyle(
                                      fontSize: 15, color: Color(0xff8c8c8c)),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap:(){
                                        setState(() {
                                          context.read<ProductCubit>().addFavorite(product.id!);
                                        });
                                      },
                                      child: const Icon(
                                        CupertinoIcons.heart,
                                        size: 30,
                                      )
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    const Icon(
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
                );
              },
            );
            case ProductStatus.error:
              return Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Danh sách trống : ${state.error}"),
                    GestureDetector(
                      onTap: (){
                        context.read<ProductCubit>().getListProduct();
                      },
                      child: Container(
                        width: 100,
                        height: 60,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: Colors.black
                        ),
                        child: const Center(child: Text("Tải lại",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.white),),),
                      ),
                    )
                  ],
                ),
              );
          }
        },
      ),
    );
  }
}
