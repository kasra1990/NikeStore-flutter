import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_flutter/data/model/ProductModel.dart';
import 'package:nike_flutter/data/repo/category_repository.dart';

part 'category_event.dart';

part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final ICategoryRepository repository;

  CategoryBloc(this.repository) : super(CategoryLoading()) {
    on<CategoryEvent>((event, emit) async {
      if (event is CategoryStarted) {
        emit(CategoryLoading());
        try {
          final products = await repository.gatCategory(
              event.userId, event.category);
          emit(CategorySuccess(products));
        } catch (e) {
          emit(CategoryError(e.toString()));
        }
      }else if(event is CategoryNoInternetConnection){
        emit(CategoryConnection());
      }
    });
  }
}
