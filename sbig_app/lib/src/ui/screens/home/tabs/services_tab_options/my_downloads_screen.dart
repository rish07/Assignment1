import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sbig_app/src/models/api_models/home/services_tab/policies_services_details/my_downloads_model.dart';
import 'package:sbig_app/src/ui/widgets/common/common_widget.dart';
import 'package:sbig_app/src/ui/widgets/statefulwidget_base.dart';
import 'package:shimmer/shimmer.dart';

class MyDownloadsScreen extends StatefulWidget {
  static const ROUTE_NAME = "/services_tab/my_downlods_screen";

  String policyNumber;

  MyDownloadsScreen(this.policyNumber);

  @override
  _MyDownloadsScreenState createState() => _MyDownloadsScreenState();
}

class _MyDownloadsScreenState extends State<MyDownloadsScreen>
    with CommonWidget {

  @override
  void initState() {
    //getFilesList(widget.policyNumber);
    super.initState();
  }

  Future<List<MyDownloadsModel>> getFilesList(String policyId) async {
    try {
      Directory rootDir;
      if (Platform.isAndroid) {
        rootDir = await getApplicationSupportDirectory();
      } else {
        rootDir = await getApplicationDocumentsDirectory();
      }
      debugPrint("getDirectoryPath:  ${rootDir.path}");
      Directory downloadDirectory =
          Directory('${rootDir.path}$directoryPath/$policyId');
      bool exists = await downloadDirectory.exists();
      List<MyDownloadsModel> myDownloads = List();
      if (exists) {
        downloadDirectory.list().toList().then((files) {
          for (FileSystemEntity file in files) {
            print("file path: " + file.path);
            Uri uri = file.uri;
            List<String> split = file.path.split('/');
            
            String lastString = split.last;
            List<String> splitName = lastString.split('_');
            String name = splitName.first;
            String date = splitName.last.split('.').first;
            
            MyDownloadsModel myDownloadsModel =
                MyDownloadsModel(name: name, date: date, path: file.path);
            myDownloads.add(myDownloadsModel);
          }
        });
        return myDownloads;
      } else {
        print("NO FILES");
      }
      return myDownloads;
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorConstants.faqs_bg,
        appBar: getAppBar(context, S.of(context).my_downloads.toUpperCase()),
        body: SafeArea(
          child: FutureBuilder(
            future: getFilesList(widget.policyNumber),
            builder: (context, snapshot) {
              List<MyDownloadsModel> myDownloads = snapshot.data;
              switch (snapshot.connectionState) {
                case ConnectionState.active:
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return _getLoader();
                case ConnectionState.done:
                  if (myDownloads == null || myDownloads.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          S.of(context).downloads_empty,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: ColorConstants.greyish_77,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    );
                  }
                  return Scrollbar(
                    child: Column(
                      children: <Widget>[
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: myDownloads.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                  left: 20.0, right: 20.0, bottom: 5.0),
                              child: Card(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            myDownloads[index].name,
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          SizedBox(height: 5,),
                                          Text(
                                            myDownloads[index].date,
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      )
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: OutlineButton(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0)),
                                        borderSide: BorderSide(
                                            color: ColorConstants
                                                .critical_illness_blue),
                                        onPressed: () {
                                          if (null != myDownloads[index].path) {
                                            OpenFile.open(
                                                myDownloads[index].path);
                                          }
                                        },
                                        child: Text(
                                          S.of(context).view,
                                          style: TextStyle(
                                              color: ColorConstants
                                                  .critical_illness_blue,
                                              fontSize: 14.0),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        )
                      ],
                    ),
                  );
              }
              return _getLoader();
            },
          ),
        ));
  }

  _getLoader(){
    return ListView.builder(
      shrinkWrap: true,
      itemCount: 2,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.only(
              left: 15.0, right: 15.0, bottom: 10.0),
          child: Card(
            elevation: 5.0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _getLoadingContainer(double.infinity),
                  SizedBox(height: 10),
                  _getLoadingContainer(100),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  _getLoadingContainer(double width) {
    return Container(
        child: Shimmer.fromColors(
      baseColor: Colors.grey[300],
      highlightColor: Colors.grey[100],
      child: Container(
        width: width,
        height: 16,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          border: Border.all(color: Colors.grey.shade300),
        ),
      ),
    ));
  }
}
