import 'dart:convert';
import 'package:dio/dio.dart';

import 'package:bloc/bloc.dart';
import 'package:jobs_bloc/models/job/job.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:jobs_bloc/models/api_response.dart';
import 'package:jobs_bloc/repository/api/job.dart';
import 'package:jobs_bloc/repository/api_provider.dart';
import 'package:meta/meta.dart';

part 'add_job_state.dart';

class AddJobCubit extends Cubit<AddJobState> {
  AddJobCubit() : super(AddJobInitial());

  void savedButtonPressed({FormGroup form, bool isUpdated = false}) async {
    emit(AddJobSaving());

    var formData = {
      // "id": form.control('id').value,
      "title": form.control('title').value,
      "location": form.control('location').value,
      "isFeatured": form.control('isFeatured').value == true ? "1" : "0",
    };

    Job job = Job(
        id: form.control('id').value,
        title: form.control('title').value,
        locationNames: form.control('location').value,
        isFeatured: form.control('isFeatured').value == true ? "1" : "0");

    try {
      var response;
      isUpdated == true
          ? response = await getRawUpdatedJobs(job)
          : response = await addJob(formData);

      if (response.statusCode == 200) {
        ApiResponse apiResponse =
            ApiResponse.fromJson(jsonDecode(response.data));
        if (apiResponse.error == 0) {
          emit(AddJobSuccess());
        } else {
          emit(AddJobFailed(
              errorMessage: "Something went wrong! ${apiResponse.message}"));
        }
      } else {
        emit(AddJobFailed(
            errorMessage: "Something went wrong! [${response.statusCode}] "));
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.RESPONSE) {
        emit(AddJobFailed(
          errorMessage: 'Something went wrong.[${e.response.statusCode}]',
        ));
      } else if (e.type == DioErrorType.DEFAULT ||
          e.type == DioErrorType.CONNECT_TIMEOUT) {
        emit(AddJobFailed(
          errorMessage: 'Please check your internet connection.',
        ));
        if (e.type == DioErrorType.CONNECT_TIMEOUT) {
          ApiProvider().cancelRequest();
        }
      } else {
        emit(AddJobFailed(errorMessage: "Something went wrong! "));
      }
    }
  }
}
