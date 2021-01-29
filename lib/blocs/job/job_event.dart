part of 'job_bloc.dart';

@immutable
abstract class JobEvent {}

class JobListing extends JobEvent {
  JobListing();
}

class JobListingNextPage extends JobEvent {
  final int page;

  JobListingNextPage({this.page});
}

class JobPressed extends JobEvent {
  final dynamic state;
  final int index;
  JobPressed({this.state, this.index});
}

class JobDeleted extends JobEvent {
  final dynamic state;
  final int index;
  JobDeleted({this.state, this.index});
}
