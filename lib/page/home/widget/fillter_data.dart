import 'package:app_food/blocs/product/product_cubit.dart';
import 'package:app_food/page/home/widget/respone_fillter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FillterData extends StatefulWidget {
  const FillterData({super.key});

  @override
  State<FillterData> createState() => _FillterDataState();
}

class _FillterDataState extends State<FillterData> {
  TextEditingController minPrice = TextEditingController();
  TextEditingController maxPrice = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductCubit(),
      child: BlocConsumer<ProductCubit, ProductState>(
        listener: (context, state) {
          switch (state.status) {
            case ProductStatus.initial:
              break;
            case ProductStatus.loading:
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) =>
                    const Center(child: CircularProgressIndicator()),
              );
              break;
            case ProductStatus.loaded:
              Navigator.of(context).pop();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ResponeFillter(data: state.products)));
              break;
            case ProductStatus.error:
              Navigator.of(context).pop();

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error ?? "Đã xảy ra lỗi")),
              );
              break;
          }
        },
        builder: (context, state) {
          return Container(
            height: 300,
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.filter_list,
                        size: 30,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Lọc sản phẩm",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "Lọc theo giá",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 60,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Color(0xffc8c8c8),
                    ),
                    child: TextField(
                      controller: minPrice,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Gía từ",
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 20.0),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 60,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Color(0xffc8c8c8),
                    ),
                    child: TextField(
                      controller: maxPrice,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Đến giá",
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 20.0),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      final minPriceValue = int.tryParse(minPrice.text);
                      final maxPriceValue = int.tryParse(maxPrice.text);

                      if (minPriceValue != null &&
                          maxPriceValue != null &&
                          minPriceValue <= maxPriceValue) {
                        context
                            .read<ProductCubit>()
                            .filterByPrice(minPriceValue, maxPriceValue);
                        print('ok');
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Vui lòng nhập giá trị hợp lệ")),
                        );
                        print('Lỗi');
                      }
                    },
                    child: Container(
                      height: 60,
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: Colors.black),
                      child: const Center(
                        child: Text(
                          "Áp dùng",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
