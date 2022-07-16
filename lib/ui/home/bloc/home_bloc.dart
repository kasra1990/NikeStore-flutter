import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:nike_flutter/data/model/HomeDataModel.dart';
import 'package:nike_flutter/data/repo/home_data_repository.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final IHomeDataRepository repository;


  HomeBloc(this.repository) : super(HomeLoading()) {
    on<HomeEvent>((event, emit) async {
      if (event is HomeStarted) {
        try {
          emit(HomeLoading());
          final response = await repository.getHomeData();
          emit(HomeSuccess(homeDataModel: response));
        } catch (e) {
          emit(HomeError(error: e.toString()));
        }
      } else if (event is HomeNoInternetConnection) {
        emit(HomeConnection());
      }
    });
  }

}
