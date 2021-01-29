import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jobs_bloc/blocs/cubits/addJob/add_job_cubit.dart';
import 'cubits/wrapper/wrapper_cubit.dart';
import 'job/job_bloc.dart';

final multipleProviders = [
  BlocProvider<JobBloc>(
    create: (context) => JobBloc(),
  ),
  BlocProvider<WrapperCubit>(
    create: (context) => WrapperCubit(),
  ),
  BlocProvider<AddJobCubit>(
    create: (context) => AddJobCubit(),
  ),
];
