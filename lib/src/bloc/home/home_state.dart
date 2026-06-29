import '../../model/profile_model.dart';

abstract class HomeState {}

class HomeInitialState extends HomeState {}

class HomeLoadingState extends HomeState {}

class HomeSuccessState extends HomeState {
  final ProfileModel profile;
  final bool isCheckedInToday;
  HomeSuccessState({required this.profile, required this.isCheckedInToday});
}

class HomeErrorState extends HomeState {
  final String message;
  HomeErrorState({required this.message});
}
