import 'package:flutter/material.dart';
import 'package:jobs_bloc/blocs/cubits/addJob/add_job_cubit.dart';
import 'package:jobs_bloc/blocs/job/job_bloc.dart';
import 'package:jobs_bloc/commons/elements/custom_primary_button.dart';
import 'package:jobs_bloc/commons/elements/reactive_input_field.dart';
import 'package:jobs_bloc/constants/app_router.dart';
import 'package:jobs_bloc/constants/style.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toast/toast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddScreen extends StatefulWidget {
  final Map arguments;
  AddScreen({this.arguments});

  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  ProgressDialog pr;

  final form = fb.group({
    'title': FormControl(
      validators: [
        Validators.required,
        Validators.maxLength(255),
      ],
    ),
    'location': FormControl(
      validators: [
        Validators.required,
        Validators.maxLength(255),
      ],
    ),
    'isFeatured': FormControl(),
    'id': FormControl(),
  });

  @override
  void initState() {
    this.form.control('isFeatured').value = false;
    super.initState();

    if (widget.arguments["isUpdated"] == true) {
      this.form.control('id').value = widget.arguments["jobData"].id;
      this.form.control('title').value = widget.arguments["jobData"].title;
      this.form.control('location').value =
          widget.arguments["jobData"].locationNames;

      var isFeatured =
          widget.arguments["jobData"].isFeatured == "1" ? true : false;
      this.form.control('isFeatured').value = isFeatured;
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isUpdated = widget.arguments["isUpdated"];

    return Scaffold(
      appBar: AppBar(
        title: isUpdated == true
            ? ReactiveForm(
                formGroup: form,
                child: ReactiveValueListenableBuilder(
                  formControlName: 'title',
                  builder: (context, control, child) {
                    return Text(this.form.control('title').value);
                  },
                ),
              )
            : Text('Add Job'),
      ),
      body: BlocConsumer<AddJobCubit, AddJobState>(
        listener: (context, state) async {
          pr = ProgressDialog(
            context,
            type: ProgressDialogType.Normal,
            isDismissible: false,
            showLogs: true,
          );

          pr.style(
            message: 'Saving please wait...',
            messageTextStyle: kTextBody.copyWith(
              fontSize: 18.ssp,
              fontWeight: FontWeight.bold,
            ),
            progressWidget: SpinKitRipple(
              color: kColorBlue,
              size: 50.0.ssp,
            ),
            borderRadius: 4.0,
          );

          if (state is AddJobSaving) {
            pr.show();
          } else if (state is AddJobSuccess) {
            Future.delayed(Duration(seconds: 1)).then((value) {
              pr.hide().whenComplete(() {
                Toast.show(
                  isUpdated
                      ? "Job Successfully Updated."
                      : "Job Successfully Added.",
                  context,
                  duration: 4,
                  gravity: Toast.BOTTOM,
                  backgroundRadius: 4,
                );
                BlocProvider.of<JobBloc>(context).add(JobListing());
                Navigator.pop(context);
              });
            });
          } else if (state is AddJobFailed) {
            if (pr.isShowing()) {
              await pr.hide();
              Toast.show(
                state.errorMessage,
                context,
                duration: 4,
                gravity: Toast.BOTTOM,
                backgroundRadius: 4,
              );
            } else {
              await Future.delayed(Duration(seconds: 1)).then((_) async {
                await pr.hide();
              });

              Toast.show(
                state.errorMessage,
                context,
                duration: 4,
                gravity: Toast.BOTTOM,
                backgroundRadius: 4,
              );
            }
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Container(
              child: ReactiveForm(
                formGroup: form,
                child: Column(
                  children: [
                    ReactiveInputField(
                      padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 10.h),
                      formControlName: 'title',
                      title: 'Title',
                      requiredField: true,
                      withBorder: true,
                      labelText: 'Enter job title',
                      validationMessages: (control) => {
                        'required': 'This field is required',
                        'maxLength':
                            'This field must not exceed to 255 characters',
                      },
                      onSubmitted: () => form.focus('location'),
                    ),
                    ReactiveInputField(
                      padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 10.h),
                      formControlName: 'location',
                      title: 'Location',
                      requiredField: true,
                      withBorder: true,
                      labelText: 'Enter job location',
                      validationMessages: (control) => {
                        'required': 'This field is required',
                        'maxLength':
                            'This field must not exceed to 255 characters',
                      },
                      onSubmitted: () => form.focus('isFeatured'),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.w, vertical: 10.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Is this a featured job?',
                            style: kTextBody.copyWith(color: kColorBlack),
                          ),
                          Row(
                            children: [
                              ReactiveSwitch.adaptive(
                                formControlName: 'isFeatured',
                                activeColor: kColorWhite,
                                activeTrackColor: kColorLightGreen,
                              ),
                              ReactiveValueListenableBuilder(
                                formControlName: 'isFeatured',
                                builder: (context, control, child) {
                                  return Flexible(
                                    child: Text(
                                      this.form.control('isFeatured').value
                                          ? "Yes, It's a featured job."
                                          : "No, it's not a featured job.",
                                      style: kTextBody,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    CustomPrimaryButton(
                      onPressed: () async {
                        context.bloc<AddJobCubit>().savedButtonPressed(
                            form: form, isUpdated: isUpdated);
                      },
                      minWidth: double.infinity,
                      height: 55.h,
                      padding: EdgeInsets.all(20.h),
                      buttonColor: Colors.blue,
                      child: Text('Save', style: kTextButton),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
