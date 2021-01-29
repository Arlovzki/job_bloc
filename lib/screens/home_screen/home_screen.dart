import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jobs_bloc/blocs/job/job_bloc.dart';
import 'package:jobs_bloc/constants/app_router.dart';
import 'package:toast/toast.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:giffy_dialog/giffy_dialog.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final RefreshController _refreshController = RefreshController();

  @override
  void initState() {
    BlocProvider.of<JobBloc>(context).add(JobListing());
    super.initState();
  }

  Future<bool> addEvent(state, index, type) async {
    if (type == "DELETED") {
      showDialog(
          context: context,
          builder: (_) => NetworkGiffyDialog(
                image: Image.network(
                  "https://images.squarespace-cdn.com/content/v1/51abe1dae4b08f6a770bf7d0/1569943355220-16CIDPEPYIKJX10EW2ZC/ke17ZwdGBToddI8pDm48kLxnK526YWAH1qleWz-y7AFZw-zPPgdn4jUwVcJE1ZvWEtT5uBSRWt4vQZAgTJucoTqqXjS3CfNDSuuf31e0tVH-2yKxPTYak0SCdSGNKw8A2bnS_B4YtvNSBisDMT-TGt1lH3P2bFZvTItROhWrBJ0/delete.gif",
                  fit: BoxFit.cover,
                ),
                entryAnimation: EntryAnimation.TOP_LEFT,
                title: Text(
                  'Delete this selected job?',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),
                ),
                description: Text(
                  'When you pressed OK, the selected job will be deleted forever. 😭',
                  textAlign: TextAlign.center,
                ),
                onOkButtonPressed: () {
                  BlocProvider.of<JobBloc>(context)
                      .add(JobDeleted(state: state, index: index));
                  Navigator.pop(context);
                },
              ));
    } else {
      BlocProvider.of<JobBloc>(context)
          .add(JobPressed(state: state, index: index));
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        heroTag: "job",
        onPressed: () {
          var mapData = {"isUpdated": false};
          Navigator.pushNamed(context, AppRouter.addScreen, arguments: mapData);
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text('Jobs'),
      ),
      body: Center(
        child: BlocConsumer<JobBloc, JobState>(
          listener: (context, state) {
            if (state is JobList) {
              if (state.isFeatured) {
                Toast.show(
                  "Featured successfully changed.",
                  context,
                  duration: 2,
                  gravity: Toast.BOTTOM,
                  backgroundRadius: 4,
                );
              } else if (state.isDeleted) {
                Toast.show(
                  "Job deleted sucessfully.",
                  context,
                  duration: 2,
                  gravity: Toast.BOTTOM,
                  backgroundRadius: 4,
                );
              }
            }
          },
          builder: (context, state) {
            Widget _widget = SizedBox.shrink();

            if (state is JobListLoading) {
              _widget = CircularProgressIndicator();
            } else if (state is JobList) {
              _widget = SmartRefresher(
                header: MaterialClassicHeader(),
                controller: _refreshController,
                onRefresh: () =>
                    BlocProvider.of<JobBloc>(context).add(JobListing()),
                child: state.joblist.length > 0
                    ? buildListView(state)
                    : Text("Job list is empty."),
              );
            } else if (state is JobError) {
              _widget = SmartRefresher(
                  header: MaterialClassicHeader(),
                  controller: _refreshController,
                  onRefresh: () =>
                      BlocProvider.of<JobBloc>(context).add(JobListing()),
                  child: Center(child: Text(state.errorMessage)));
            }

            return _widget;
          },
        ),
      ),
    );
  }

  Widget buildListView(JobList state) {
    return ListView.builder(
      itemCount: state.joblist.length,
      shrinkWrap: true,
      physics: BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      itemBuilder: (context, index) {
        final job = state.joblist[index];
        return Dismissible(
          confirmDismiss: (DismissDirection dismissDirection) async {
            switch (dismissDirection) {
              case DismissDirection.endToStart:
                return await addEvent(state, index, "FEATURED");

              case DismissDirection.startToEnd:
                return await addEvent(state, index, "DELETED");
              case DismissDirection.horizontal:
              case DismissDirection.vertical:
              case DismissDirection.up:
              case DismissDirection.down:
                assert(false);
            }
            return false;
          },
          secondaryBackground: Card(
            child: Container(
              color: Colors.orangeAccent,
              child: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Icon(
                    job.isFeatured != "1" ? Icons.star : Icons.star_border,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          background: Card(
            child: Container(
              color: Colors.red,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Icon(
                    Icons.delete_outline,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          key: Key(job.id),
          child: Card(
            child: ListTile(
              key: Key(job.id),
              leading: Icon(Icons.location_city),
              title: Text(job.title),
              trailing: Icon(
                job.isFeatured == "1" ? Icons.star : Icons.star_border,
                color: Colors.orangeAccent,
              ),
              subtitle:
                  job.locationNames != null ? Text(job.locationNames) : null,
              onTap: () {
                BlocProvider.of<JobBloc>(context)
                    .add(JobPressed(state: state, index: index));
              },
              onLongPress: () {
                var mapData = {"isUpdated": true, "jobData": job};
                Navigator.pushNamed(context, AppRouter.addScreen,
                    arguments: mapData);
              },
            ),
          ),
        );
      },
    );
  }
}
