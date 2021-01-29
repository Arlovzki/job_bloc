import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'wrapper_state.dart';

class WrapperCubit extends Cubit<WrapperState> {
  WrapperCubit() : super(WrapperInitial());
}
