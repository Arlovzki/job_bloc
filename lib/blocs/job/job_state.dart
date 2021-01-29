part of 'job_bloc.dart';

@immutable
abstract class JobState {}

class JobInitial extends JobState {}

class JobListLoading extends JobState {}

class JobListEmpty extends JobState {}

class JobList extends JobState {
  final dynamic joblist;
  final int currentPage;
  final int totalPage;
  final bool isFeatured;
  final bool isDeleted;

  JobList({
    this.joblist,
    this.currentPage,
    this.totalPage,
    this.isDeleted = false,
    this.isFeatured = false,
  });
}

class JobError extends JobState {
  final String errorMessage;
  JobError({this.errorMessage});
}

class JobNextPageLoading extends JobState {
  final bool isLoading;

  JobNextPageLoading({
    this.isLoading = false,
  });
}
