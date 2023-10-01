import 'package:flutter/material.dart' show BuildContext, ModalRoute;

extension GetArgument on BuildContext {
  // ignore: body_might_complete_normally_nullable
  T? getArgument<T>() {
    final modalRoute = ModalRoute.of(this);
    if (modalRoute != null) {
      final args = modalRoute.settings.arguments;
      if(args!=null&&args is T){
        return args as T;
      }
    } else {
      return null;
    }
  }
}
