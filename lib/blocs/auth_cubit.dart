import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthService _authService;
  Stream<User?>? _authStateChanges;
  late final StreamSubscription<User?> _authSub;

  AuthCubit(this._authService) : super(const AuthState.unknown()) {
    _authStateChanges = FirebaseAuth.instance.authStateChanges();
    _authSub = _authStateChanges!.listen((user) {
      if (user != null) {
        emit(AuthState.authenticated(user));
      } else {
        emit(const AuthState.unauthenticated());
      }
    });
  }

  Future<void> signIn(String email, String password) async {
    try {
      emit(const AuthState.loading());
      final cred = await _authService.signIn(email, password);
      final user = cred.user;
      if (user != null) {
        emit(AuthState.authenticated(user));
      } else {
        emit(const AuthState.unauthenticated());
      }
    } catch (e) {
      emit(AuthState.failure(e.toString()));
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
    emit(const AuthState.unauthenticated());
  }

  @override
  Future<void> close() {
    _authSub.cancel();
    return super.close();
  }
}
