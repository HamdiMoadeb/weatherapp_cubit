import 'package:equatable/equatable.dart';

class CustomError extends Equatable{

  final String errMsg;

  const CustomError({
    this.errMsg = ''
  });

  @override
  String toString() {
    return 'CustomError{errMsg: $errMsg}';
  }

  @override
  List<Object> get props => [errMsg];
}
