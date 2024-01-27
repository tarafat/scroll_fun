import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../networks/exception_handler/data_source.dart';

extension Loader on Future {
  Future<bool> customeThen(BuildContext context) async {
    showDialog(
        context: context,
        builder: (context) => const Center(
                child: CupertinoActivityIndicator(
              color: Colors.black,
              radius: 50,
            )));
    bool retunValue = await then(
      (value) async {
        Navigator.of(context).pop();

        return true;
      },
      onError: (value) {
        Navigator.of(context).pop();
        Failure failureresponse = value as Failure;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(failureresponse.responseMessage),
          ),
        );
        return false;
      },
    );
    return retunValue;
  }
}
