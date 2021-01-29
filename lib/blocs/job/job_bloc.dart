import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:bloc/bloc.dart';
import 'package:jobs_bloc/models/api_response.dart';
import 'package:jobs_bloc/models/job/job.dart';
import 'package:jobs_bloc/models/pagination.dart';
import 'package:jobs_bloc/repository/api/job.dart';
import 'package:jobs_bloc/repository/api_provider.dart';
import 'package:meta/meta.dart';

part 'job_event.dart';
part 'job_state.dart';

class JobBloc extends Bloc<JobEvent, JobState> {
  JobBloc() : super(JobInitial());

  @override
  Stream<JobState> mapEventToState(
    JobEvent event,
  ) async* {
    if (event is JobListing) {
      yield JobListLoading();

      try {
        final jobsRes = await getRawJobs();
        print(jobsRes);

        if (jobsRes.statusCode == 200) {
          ApiResponse apiResponse =
              ApiResponse.fromJson(jsonDecode(jobsRes.data));
          print(apiResponse);

          if (apiResponse.error == 0) {
            // //convert the datas into job model
            // final List data = jobsRes.data['datas'] as List;
            // data.map((e) => Job.fromJson(e)).toList();

            Pagination pagination = Pagination.fromJson(apiResponse.data);

            if (pagination.totalCount != "0") {
              if (pagination.nextPage != null) {
                JobNextPageLoading(isLoading: true);
              }

              var data = pagination.datas.map((e) => Job.fromJson(e)).toList();

              yield JobList(
                joblist: data,
                currentPage: pagination.currentPage,
                totalPage: pagination.totalPage,
              );
            } else {
              yield JobListEmpty();
            }
          } else {
            yield JobError(errorMessage: apiResponse.message);
          }
        }
      } on DioError catch (e) {
        if (e.type == DioErrorType.RESPONSE) {
          yield JobError(
            errorMessage: 'Something went wrong.[${e.response.statusCode}]',
          );
        } else if (e.type == DioErrorType.DEFAULT ||
            e.type == DioErrorType.CONNECT_TIMEOUT) {
          yield JobError(
            errorMessage: 'Please check your internet connection.',
          );
          if (e.type == DioErrorType.CONNECT_TIMEOUT) {
            ApiProvider().cancelRequest();
          }
        } else {
          yield JobError(
            errorMessage: 'Something went wrong.',
          );
        }
      }
    } else if (event is JobListingNextPage) {
      try {
        Response getNewsRes = await getRawJobs(
          page: event.page,
        );

        if (getNewsRes.statusCode == 200) {
          ApiResponse apiResponse = ApiResponse.fromJson(
            jsonDecode(getNewsRes.data),
          );

          if (apiResponse.error == 0) {
            Pagination pagination = Pagination.fromJson(apiResponse.data);

            if (pagination.totalCount != "0") {
              var data = pagination.datas.map((e) => Job.fromJson(e)).toList();

              yield JobList(
                joblist: data,
                currentPage: pagination.currentPage,
                totalPage: pagination.totalPage,
              );
            } else {
              yield JobListEmpty();
            }
          } else {
            yield JobError(
              errorMessage: apiResponse.message,
            );
          }
        }
      } on DioError catch (e) {
        if (e.type == DioErrorType.RESPONSE) {
          yield JobError(
              errorMessage: 'Something went wrong.[${e.response.statusCode}]');
        } else if (e.type == DioErrorType.DEFAULT ||
            e.type == DioErrorType.CONNECT_TIMEOUT) {
          yield JobError(
            errorMessage: 'Please check your internet connection.',
          );
          if (e.type == DioErrorType.CONNECT_TIMEOUT) {
            ApiProvider().cancelRequest();
          }
        } else {
          yield JobError(errorMessage: 'Something went wrong.');
        }
      }
    } else if (event is JobPressed) {
      yield JobListLoading();

      try {
        Job job = Job(
            id: event.state.joblist[event.index].id,
            title: event.state.joblist[event.index].title,
            locationNames: event.state.joblist[event.index].locationNames,
            isFeatured:
                event.state.joblist[event.index].isFeatured == "1" ? "0" : "1");

        final jobsRes = await getRawUpdatedJobs(job);
        print(jobsRes);

        if (jobsRes.statusCode == 200) {
          ApiResponse apiResponse =
              ApiResponse.fromJson(jsonDecode(jobsRes.data));
          print(apiResponse);

          if (apiResponse.error == 0) {
            var updatedDataIndex = Job.fromJson(apiResponse.data);
            event.state.joblist[event.index] = updatedDataIndex;

            yield JobList(
              joblist: event.state.joblist,
              currentPage: event.state.currentPage,
              totalPage: event.state.totalPage,
              isFeatured: true,
            );
          } else {
            yield JobError(errorMessage: apiResponse.message);
          }
        }
      } on DioError catch (e) {
        if (e.type == DioErrorType.RESPONSE) {
          yield JobError(
            errorMessage: 'Something went wrong.[${e.response.statusCode}]',
          );
        } else if (e.type == DioErrorType.DEFAULT ||
            e.type == DioErrorType.CONNECT_TIMEOUT) {
          yield JobError(
            errorMessage: 'Please check your internet connection.',
          );
          if (e.type == DioErrorType.CONNECT_TIMEOUT) {
            ApiProvider().cancelRequest();
          }
        } else {
          yield JobError(
            errorMessage: 'Something went wrong.',
          );
        }
      }
    } else if (event is JobDeleted) {
      yield JobListLoading();

      try {
        final jobsRes =
            await deleteJob(id: event.state.joblist[event.index].id);
        print(jobsRes);

        if (jobsRes.statusCode == 200) {
          ApiResponse apiResponse =
              ApiResponse.fromJson(jsonDecode(jobsRes.data));
          print(apiResponse);

          if (apiResponse.error == 0) {
            var itemId = apiResponse.data["id"];
            List list = event.state.joblist as List;
            list.removeWhere((element) => element.id == itemId);

            yield JobList(
              joblist: list,
              currentPage: event.state.currentPage,
              totalPage: event.state.totalPage,
              isDeleted: true,
            );
          } else {
            yield JobError(errorMessage: apiResponse.message);
          }
        }
      } on DioError catch (e) {
        if (e.type == DioErrorType.RESPONSE) {
          yield JobError(
            errorMessage: 'Something went wrong.[${e.response.statusCode}]',
          );
        } else if (e.type == DioErrorType.DEFAULT ||
            e.type == DioErrorType.CONNECT_TIMEOUT) {
          yield JobError(
            errorMessage: 'Please check your internet connection.',
          );
          if (e.type == DioErrorType.CONNECT_TIMEOUT) {
            ApiProvider().cancelRequest();
          }
        } else {
          yield JobError(
            errorMessage: 'Something went wrong.',
          );
        }
      }
    }
  }
}
