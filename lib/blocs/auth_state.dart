part of 'auth_cubit.dart';

class AuthState extends Equatable {
  final bool isLoading;
  final User? user;
  final String? error;

  const AuthState._({this.isLoading = false, this.user, this.error});

  const AuthState.unknown() : this._();
  const AuthState.loading() : this._(isLoading: true);
  const AuthState.authenticated(User user) : this._(user: user);
  const AuthState.unauthenticated() : this._();
  const AuthState.failure(String message) : this._(error: message);

  @override
  List<Object?> get props => [isLoading, user, error];
}
