import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:nike_flutter/data/model/AddToCartModel.dart';
import 'package:nike_flutter/data/model/MessageModel.dart';
import 'package:nike_flutter/data/repo/product_repository.dart';

part 'product_event.dart';

part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository repository;

  ProductBloc(this.repository) : super(ProductInitial()) {
    on<ProductEvent>((event, emit) async {
      if (event is ProductAddToCart) {
        emit(ProductLoading());
        try {
          final response = await repository.addToCart(
              event.model.userId, event.model.productId, event.model.shoesSize);
          emit(ProductAddedSuccess(response));
        } catch (e) {
          emit(ProductError(e.toString()));
        }
      }else if(event is ProductNoInternetConnection){
        emit(ProductConnection());
      }
    });
  }
}
