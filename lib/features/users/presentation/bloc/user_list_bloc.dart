import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/user.dart';
import '../../domain/usecases/get_users.dart';

// Events

abstract class UserListEvent {}

class UserListRequested extends UserListEvent {}

// States

abstract class UserListState {}

class UserListInitial extends UserListState {}

class UserListLoading extends UserListState {}

class UserListSuccess extends UserListState {
  final List<User> users;

  UserListSuccess(this.users);
}

class UserListFailure extends UserListState {
  final String message;

  UserListFailure(this.message);
}

// BLoC

class UserListBloc extends Bloc<UserListEvent, UserListState> {
  final GetUsers getUsers;

  UserListBloc({required this.getUsers})
      : super(UserListInitial()) {
    on<UserListRequested>((event, emit) async {
      emit(UserListLoading());

      try {
        final users = await getUsers();

        emit(UserListSuccess(users));
      } catch (e) {
        emit(
          UserListFailure(
            e.toString().replaceFirst('Exception: ', ''),
          ),
        );
      }
    });
  }
}