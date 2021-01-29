import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jobs_bloc/blocs/bloc_providers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jobs_bloc/screens/home_screen/home_screen.dart';

import 'blocs/cubits/wrapper/wrapper_cubit.dart';
import 'constants/app_router.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: multipleProviders,
      child: MaterialApp(
        title: 'Jobs App',
        debugShowCheckedModeBanner: false,
        onGenerateRoute: AppRouter.generateRoute,
        theme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: BlocConsumer<WrapperCubit, WrapperState>(
          listener: (context, state) {},
          builder: (context, state) {
            ScreenUtil.init(
              context,
              designSize: Size(441.4, 774.9),
              allowFontScaling: true,
            );
            return HomeScreen();
          },
        ),
      ),
    );
  }
}
