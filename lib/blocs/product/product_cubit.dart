import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/product.dart';

part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  ProductCubit() : super(const ProductState());

  Dio dio = Dio();
  List<Product> allData = [];

  Future<void> getListProduct() async {
    try {
      final response = await dio.get("http://10.0.2.2:3000/getProduct");
      if (response.statusCode == 200) {
        final List<dynamic> product = response.data;
        final List<Product> productList =
            product.map((json) => Product.fromJson(json)).toList();
        allData = productList;
        print('data == $productList');
        emit(state.copyWith(
            status: ProductStatus.loaded, products: productList));
      } else {
        emit(state.copyWith(
            status: ProductStatus.error,
            error: "Không lấy được danh sách sản phẩm"));
        print('Lỗi : ${response.statusMessage}');
      }
    } catch (e) {
      emit(state.copyWith(status: ProductStatus.error, error: e.toString()));
      print('Đã có lỗi khi lấy danh sách sản phẩm : $e');
    }
  }

  void filterByPrice(int minPrice, int maxPrice) {
    if (allData.isNotEmpty) {
      final filteredProducts = allData.where((product) {
        return product.price! >= minPrice && product.price! <= maxPrice;
      }).toList();
      print('data fillter == $filteredProducts');
      emit(state.copyWith(
          status: ProductStatus.loaded, products: filteredProducts));
    } else {
      print('Rỗng');
    }
  }

  Future<void> searchProduct(String productname) async {
    try {
      final response = await dio.get("http://10.0.2.2:3000/findProduct",
          data: {'productname': productname});
      if (response.statusCode == 200) {
        final List<Product> data = (response.data as List)
            .map((json) => Product.fromJson(json))
            .toList();
        emit(state.copyWith(status: ProductStatus.loaded, products: data));
      } else {
        emit(state.copyWith(
            status: ProductStatus.error,
            error: "Không có sản phẩm nào phù hợp"));
        print('Lỗi : ${response.statusMessage}');
      }
    } catch (e) {
      print('Lỗi tìm kiếm : $e');
    }
  }

  void clearSearch() {
    emit(state.copyWith(status: ProductStatus.initial));
  }

  Future<void> addFavorite(String productId) async {
    try {
      final response = await dio.post("http://10.0.2.2:3000/addToWithList",
          data: {'productId': productId});
      if (response.statusCode == 200) {
        final newFavorite = Product.fromJson(response.data);
        final updatedList = [...state.products, newFavorite];
        emit(state.copyWith(
            status: ProductStatus.loaded, products: updatedList));
      }
    } catch (e) {
      emit(state.copyWith(
          status: ProductStatus.error,
          error: "Lỗi thêm sản phẩm vào danh sách yêu thích : $e"));
    }
  }

  // Phương thức để lấy danh sách sản phẩm yêu thích
  Future<void> getFavorites() async {
    emit(state.copyWith(status: ProductStatus.loading));

    try {
      final response = await dio.get('http://10.0.2.2:3000/getWithList');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        final List<Product> favorites = data.map((item) => Product.fromJson(item['productId'])).toList();

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

}
