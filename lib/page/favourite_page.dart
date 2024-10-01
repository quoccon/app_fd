import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

// Product model
class Product {
  final String id;
  final String productname;
  final String description;
  final String imageUrl;

  Product({
    required this.id,
    required this.productname,
    required this.description,
    required this.imageUrl,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'],
      productname: json['productname'],
      description: json['description'],
      imageUrl: json['imageUrl'],
    );
  }
}

// Cubit
enum ProductStatus { initial, loading, loaded, error }

class FavouriteCubit extends Cubit<FavouriteState> {
  FavouriteCubit() : super(FavouriteState());

  final Dio dio = Dio();

  Future<void> getFavorites() async {
    emit(state.copyWith(status: ProductStatus.loading));

    try {
      final response = await dio.get('http://10.0.2.2:3000/getWithList');

      if (response.statusCode == 200) {
        final List data = response.data;
        final List<Product> favorites = data
            .map((item) => Product.fromJson(item['productId']))
            .toList();

        emit(state.copyWith(
          status: ProductStatus.loaded,
          products: favorites,
        ));
      } else {
        emit(state.copyWith(
          status: ProductStatus.error,
          error: 'Failed to load favorites',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: ProductStatus.error,
        error: e.toString(),
      ));
    }
  }

  void addFavorite(String productId) {
    // Implement add to favorite logic here
  }
}

class FavouriteState {
  final ProductStatus status;
  final List<Product> products;
  final String error;

  FavouriteState({
    this.status = ProductStatus.initial,
    this.products = const [],
    this.error = '',
  });

  FavouriteState copyWith({
    ProductStatus? status,
    List<Product>? products,
    String? error,
  }) {
    return FavouriteState(
      status: status ?? this.status,
      products: products ?? this.products,
      error: error ?? this.error,
    );
  }
}

// UI
class FavouritePage extends StatelessWidget {
  const FavouritePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FavouriteCubit()..getFavorites(),
      child: const FavouriteView(),
    );
  }
}

class FavouriteView extends StatelessWidget {
  const FavouriteView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sản phẩm yêu thích"),
      ),
      body: BlocBuilder<FavouriteCubit, FavouriteState>(
        builder: (context, state) {
          if (state.status == ProductStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.status == ProductStatus.error) {
            return Center(child: Text(state.error));
          } else if (state.status == ProductStatus.loaded) {
            return ListView.builder(
              itemCount: state.products.length,
              itemBuilder: (context, index) {
                final product = state.products[index];
                return _buildProductItem(context, product);
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildProductItem(BuildContext context, Product product) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, right: 20, left: 20),
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 6,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {},
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                ),
                child: Image.network(
                  product.imageUrl,
                  width: 150,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.productname,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      product.description,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Color(0xff8c8c8c),
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            context.read<FavouriteCubit>().addFavorite(product.id);
                          },
                          child: const Icon(
                            CupertinoIcons.heart,
                            size: 30,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Icon(
                          CupertinoIcons.clock,
                          size: 30,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}