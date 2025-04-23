part of 'favorite_cubit.dart';

@immutable
sealed class FavoriteState {}

final class FavoriteInitial extends FavoriteState {}
final class FavoriteUpdated extends FavoriteState {}
final class FavoriteError extends FavoriteState {
  String errorMessage;
  FavoriteError(this.errorMessage);
}
