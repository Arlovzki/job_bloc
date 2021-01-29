part of 'add_job_cubit.dart';

@immutable
abstract class AddJobState {}

class AddJobInitial extends AddJobState {}

class AddJobSaving extends AddJobState {}

class AddJobSuccess extends AddJobState {}

class AddJobFailed extends AddJobState {
  final String errorMessage;
  AddJobFailed({this.errorMessage});
}
