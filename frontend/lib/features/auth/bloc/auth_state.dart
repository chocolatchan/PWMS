import 'package:equatable/equatable.dart';
import '../models/auth_models.dart';

abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class AuthSuccess extends AuthState {
  final LoginResponse user;
  const AuthSuccess(this.user);
  @override
  List<Object?> get props => [user];
}
class AuthFailure extends AuthState {
  final String error;
  const AuthFailure(this.error);
  @override
  List<Object?> get props => [error];
}
