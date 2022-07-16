import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:nike_flutter/data/model/CartDataModel.dart';
import 'package:nike_flutter/data/repo/cart_repository.dart';

part 'cart_event.dart';

part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository repository;

  CartBloc(this.repository) : super(CartLoading()) {
    on<CartEvent>((event, emit) async {
      if (event is CartStarted) {
        emit(CartLoading());
        try {
          final response = await repository.getCarts(event.userId);
          if (response.isNotEmpty) {
            emit(CartSuccess(response, totalPayment(response)));
          } else {
            emit(CartEmpty());
          }
        } catch (e) {
          debugPrint("Error: $e");
          emit(CartError(e.toString()));
        }
      } else if (event is CartNoInternetConnection) {
        emit(CartConnection());
      } else if (event is CartAuth) {
        emit(CartNotAuthentication());
      } else if (event is CartDecreaseCount) {
        if (state is CartSuccess) {
          var successState = (state as CartSuccess);
          final index = successState.carts
              .indexWhere((element) => element.cartId == event.cartItemId);
          if (int.parse(successState.carts[index].count) < 5) {
            String count =
                (int.parse(successState.carts[index].count) + 1).toString();
            successState.carts[index].count = count;
            emit(CartSuccess(
                successState.carts, totalPayment(successState.carts)));
            await repository.changeCount(
                successState.carts[index].cartId, count);
          }
        }
      } else if (event is CartIncreaseCount) {
        if (state is CartSuccess) {
          var successState = (state as CartSuccess);
          final index = successState.carts
              .indexWhere((element) => element.cartId == event.cartItemId);
          if (int.parse(successState.carts[index].count) > 1) {
            String count =
                (int.parse(successState.carts[index].count) - 1).toString();
            successState.carts[index].count = count;
            emit(CartSuccess(
                successState.carts, totalPayment(successState.carts)));
            await repository.changeCount(
                successState.carts[index].cartId, count);
          }
        }
      } else if (event is CartDeleteProducts) {
        if (state is CartSuccess) {
          var successState = (state as CartSuccess);
          successState.carts
              .removeWhere((element) => element.cartId == event.cartId);
          if (successState.carts.isNotEmpty) {
            emit(CartSuccess(
                successState.carts, totalPayment(successState.carts)));
          } else {
            emit(CartEmpty());
          }
          await repository.deleteProduct(event.cartId);
        }
      }
    });
  }

  String totalPayment(List<CartDataModel> carts) {
    double total = 0;
    for (var element in carts) {
      total +=
          double.parse(element.product.price) * double.parse(element.count);
    }
    return total.toString();
  }
}
