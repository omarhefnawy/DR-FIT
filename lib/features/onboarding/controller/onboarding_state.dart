part of 'onboarding_cubit.dart';

@immutable
sealed class OnboardingState {}

final class OnboardingInitial extends OnboardingState {}

final class OnboardingPageState extends OnboardingState {}

final class OnboardingNextSuccessPage extends OnboardingState {}

final class OnboardingNextErrorPage extends OnboardingState {}

final class OnboardingSkipSuccessPage extends OnboardingState {}

final class OnboardingSkipErrorPage extends OnboardingState {}

final class OnboardingStartSuccessPage extends OnboardingState {}

final class OnboardingStartErrorPage extends OnboardingState {}
