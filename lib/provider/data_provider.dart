import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:scroll_fun/app_constants.dart';
import 'package:scroll_fun/networks/dio/dio.dart';
import 'package:scroll_fun/networks/endpoints.dart';

import '../model/label.dart';
import '../model/resmodel.dart' hide Label;
import '../networks/exception_handler/data_source.dart';

class DataProvider extends ChangeNotifier {
  // List to store label data
  List<Label> chipValues = [];

  // TextEditingController for text input
  TextEditingController textController = TextEditingController();

  // List to store fetched issues
  List<Issue> issueList = [];

  // Current page number for pagination
  int page = 0;

  // Flag to track if more pages are available
  bool pagesRemaining = true;

  // Flag to track loading state
  bool isLoading = false;

  // Scroll controller for handling list scrolling
  ScrollController innerController = ScrollController();

  // Constructor to initialize the data provider
  DataProvider() {
    // Set up the scroll controller listener for pagination
    initController();

    // Fetch initial data from API
    fetchDataFromApi();

    // Fetch paginated data
    getPaginatedData();
  }

  // Initialize scroll controller listener
  void initController() {
    innerController.addListener(() {
      // Check if the end of the list is reached for pagination
      if (innerController.position.maxScrollExtent == innerController.offset) {
        getPaginatedData(textController.text);
      }
    });
  }

  // Fetch initial data from the API
  Future<void> fetchDataFromApi() async {
    try {
      // Make HTTP request to get labels
      Response response = await getHttp(
          Endpoints.getlabels(AppConstanst.owner, AppConstanst.repo));

      if (response.statusCode == 200) {
        // Parse and convert data to Label objects
        List data = response.data;
        List<Label> label = [];
        for (var element in data) {
          label.add(Label.fromJson(element));
        }

        // Update chipValues and notify listeners
        chipValues = label;
        notifyListeners();
      } else {
        // Handle HTTP error and throw corresponding failure
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (exception) {
      // Handle and throw general exception with failure details
      throw ErrorHandler.handle(exception).failure;
    }
  }

  // Fetch paginated data with optional filter
  Future<void> getPaginatedData([String? filter]) async {
    try {
      // Check if data is already loading
      if (isLoading == true) return;

      // Check if more pages are available
      if (pagesRemaining) {
        // Set loading flag to true and increment page number
        isLoading = true;
        page++;
        // Make HTTP request to get paginated issues
        Response response = await getHttp(Endpoints.getIssues(
            AppConstanst.owner,
            AppConstanst.repo,
            AppConstanst.perPage,
            page,
            filter ?? ""));
        isLoading = false;

        if (response.statusCode == 200) {
          // Parse and convert data to Issue objects
          List parsedData = response.data;
          for (var element in parsedData) {
            issueList.add(Issue.fromJson(element));
          }

          // Update pagesRemaining based on link header
          final linkHeader = response.headers["link"];
          pagesRemaining = linkHeader != null &&
              linkHeader.toString().contains('rel="next"');

          // Reset loading flag, notify listeners

          notifyListeners();
        } else {
          isLoading = false;
          // Handle HTTP error and throw corresponding failure
          throw DataSource.DEFAULT.getFailure();
        }
      }
    } catch (exception) {
      // Reset loading flag, notify listeners, and throw general exception with failure details
      isLoading = false;
      notifyListeners();
      throw ErrorHandler.handle(exception).failure;
    }
  }
}
