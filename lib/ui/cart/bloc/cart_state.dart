part of 'cart_bloc.dart';

@immutable
abstract class CartState {}

class CartLoading extends CartState{}

class CartSuccess extends CartState{
  final List<CartDataModel> carts;
  final String totalPayment;
  CartSuccess(this.carts, this.totalPayment);
}

class CartConnection extends CartState{}

class CartEmpty extends CartState{}
class CartNotAuthentication extends CartState{}

class CartError extends CartState{
  final String error;
  CartError(this.error);
}



