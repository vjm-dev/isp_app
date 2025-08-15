import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:isp_app/domain/entities/user.dart';
import 'package:isp_app/domain/usecases/get_user_data.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final GetUserData getUserData;

  UserBloc({required this.getUserData}) : super(UserInitial()) {
    on<LoadUserData>(_onLoadUserData);
  }

  Future<void> _onLoadUserData(
    LoadUserData event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoading());
    try {
      final result = await getUserData(event.userId);
      result.fold(
        (failure) => emit(UserError(failure.message)),
        (user) => emit(UserLoaded(user)),
      );
    } catch (e) {
      emit(UserError('Unknown error _onLoadUserData: $e'));
    }
  }
}