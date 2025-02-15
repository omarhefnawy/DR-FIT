import 'package:dr_fit/features/profile/data/model/user_data.dart';

abstract class ProfileStates {}

// Initial state (when no action has been taken yet)
class ProfileInitial extends ProfileStates {}

// Loading state (when data is being fetched or updated)
class ProfileLoading extends ProfileStates {}

// Loaded state (when data is successfully fetched or updated)
class ProfileLoaded extends ProfileStates {
  final ProfileData profileData; // Pass the profile data model
  ProfileLoaded({required this.profileData});
}

// Fail state (when an error occurs)
class ProfileFail extends ProfileStates {
  final String message; // Pass the error message
  ProfileFail({required this.message});
}
