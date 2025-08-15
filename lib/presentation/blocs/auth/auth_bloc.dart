import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:isp_app/core/di/service_locator.dart';
import 'package:isp_app/domain/repositories/auth_repository.dart';
import 'package:isp_app/domain/entities/user.dart';
import 'package:isp_app/domain/usecases/login_user.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUser loginUser;

  AuthBloc({required this.loginUser}) : super(AuthInitial()) {
    // Here is where you add auth events

    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<CheckAuthStatus>(_onCheckAuthStatus);
  }

  void _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final result = await loginUser(event.email, event.password);
      
      result.fold(
        (failure) => emit(AuthFailure(failure.message)),
        (user) => emit(AuthAuthenticated(user)),
      );
    } catch (e) {
      emit(AuthFailure('Authentication failed: $e'));
    }
  }

  void _onLogoutRequested(
  LogoutRequested event,
  Emitter<AuthState> emit,
) async {
  emit(AuthLoading());
  try {
    // Clean local data
    await getIt<AuthRepository>().logout();

    // Emit unaunthenticated state
    emit(AuthUnauthenticated());

    // Optional: clean other states if needed
    // context.read<UserBloc>().add(ClearUserData());    
  } catch (e) {
    emit(AuthFailure('Logout failed: $e'));
  }
}

  void _onCheckAuthStatus(
    CheckAuthStatus event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final result = await getIt<AuthRepository>().checkAuthStatus();
      result.fold(
        (failure) => emit(AuthUnauthenticated()),
        (user) => emit(AuthAuthenticated(user)),
      );
    } catch (e) {
      emit(AuthFailure('Session check failed: $e'));
    }
  }
}