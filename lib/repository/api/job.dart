import 'package:jobs_bloc/repository/api_provider.dart';
import 'package:jobs_bloc/repository/repository_constants.dart';

class GetJobsRequestFailure implements Exception {}

//* queries

Future getRawJobs({int page = 1}) async {
  return await ApiProvider().makeRequest(
    urlPath: urls['get_job-list'],
    jsonData: {
      "page": page,
    },
    method: GET_METHOD,
  );
}

Future getRawUpdatedJobs(job) async {
  return await ApiProvider().makeRequest(
    urlPath: urls['update_job'],
    jsonData: {
      "id": job.id,
      "title": job.title,
      "location": job.locationNames,
      "isFeatured": job.isFeatured,
    },
    method: POST_METHOD,
  );
}

Future deleteJob({id}) async {
  return await ApiProvider().makeRequest(
    urlPath: urls['delete_job'],
    jsonData: {
      "id": id,
    },
    method: POST_METHOD,
  );
}

Future addJob(Map job) async {
  return await ApiProvider().makeRequest(
    urlPath: urls['add_job'],
    jsonData: {
      "title": job["title"],
      "location": job["location"],
      "isFeatured": job["isFeatured"],
    },
    method: POST_METHOD,
  );
}
