import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'helper/date_formatter.dart';
import 'provider/data_provider.dart';
import '/helper/custom_loader.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        title: Text(title),
      ),
      body: SingleChildScrollView(
        controller: Provider.of<DataProvider>(context).innerController,
        scrollDirection: Axis.vertical,
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Widget displaying labels as chips
            LabelChipsWidget(),

            // Widget for searching and filtering issues
            SerachWidget(),

            // Widget displaying the list of issues
            IssueWidget(),
          ],
        ),
      ),
    );
  }
}

class IssueWidget extends StatelessWidget {
  const IssueWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: Provider.of<DataProvider>(context).myList.length + 1,
      itemBuilder: (context, index) {
        final dataProvider = Provider.of<DataProvider>(context, listen: false);
        if (index < dataProvider.myList.length) {
          // Display issue details
          return Container(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                        width: MediaQuery.of(context).size.width * .5,
                        child: Text(
                          dataProvider.myList[index].title,
                          maxLines: 1,
                        )),
                    Text(date12format(dataProvider.myList[index].createdAt)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .5,
                      child: Text(
                        dataProvider.myList[index].body,
                        maxLines: 1,
                      ),
                    ),
                    Text(dataProvider.myList[index].user.login),
                  ],
                ),
                Row(
                  children: [
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: dataProvider.myList[index].labels!.map((value) {
                        String colorCode = "FF" "${value.color!}";
                        Color myColor = Color(int.parse(colorCode, radix: 16));
                        // Display label as a chip
                        return InputChip(
                          padding: const EdgeInsets.all(0),
                          label: Text(value.name!),
                          backgroundColor: myColor,
                          onPressed: () {},
                        );
                      }).toList(),
                    ),
                  ],
                ),
                const Divider(),
              ],
            ),
          );
        } else {
          // Display loading indicator or no more issues message
          if (dataProvider.pagesRemaining) {
            return const Center(
                child: CupertinoActivityIndicator(
              radius: 10,
            ));
          } else {
            return const Center(child: Text("No more issues"));
          }
        }
      },
    );
  }
}

class SerachWidget extends StatelessWidget {
  const SerachWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: 'Filter By Labels',
          border: const OutlineInputBorder(),
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              // Clear text and reset pagination when clear button is pressed
              final dataProvider =
                  Provider.of<DataProvider>(context, listen: false);
              dataProvider.textController.clear();
              dataProvider.page = 0;
              dataProvider.pagesRemaining = true;
              dataProvider.myList.clear();
              dataProvider
                  .getPaginatedData(dataProvider.textController.text)
                  .customeThen(context);
            },
          ),
        ),
        controller: Provider.of<DataProvider>(context).textController,
        readOnly: false,
        onEditingComplete: () {
          // Perform filtering when editing is complete
          FocusScope.of(context).requestFocus(FocusNode());
          final dataProvider =
              Provider.of<DataProvider>(context, listen: false);
          dataProvider.page = 0;
          dataProvider.pagesRemaining = true;
          dataProvider.myList.clear();
          dataProvider
              .getPaginatedData(dataProvider.textController.text)
              .customeThen(context);
        },
      ),
    );
  }
}

class LabelChipsWidget extends StatelessWidget {
  const LabelChipsWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Wrap(
        spacing: 8.0,
        runSpacing: 8.0,
        children: Provider.of<DataProvider>(context).chipValues.map((value) {
          String colorCode = "FF" "${value.color!}";
          Color myColor = Color(int.parse(colorCode, radix: 16));
          // Display label as a chip
          return InputChip(
            label: Text(value.name!),
            backgroundColor: myColor,
            onPressed: () {
              // Add label to filter and reset pagination
              final dataProvider =
                  Provider.of<DataProvider>(context, listen: false);
              dataProvider.textController.text =
                  "${dataProvider.textController.text}${value.name!},";
              dataProvider.page = 0;
              dataProvider.pagesRemaining = true;
              dataProvider.myList.clear();
              dataProvider
                  .getPaginatedData(dataProvider.textController.text)
                  .customeThen(context);
            },
          );
        }).toList(),
      ),
    );
  }
}
