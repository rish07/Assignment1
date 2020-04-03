import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class CounterStorage {

  init(){
    _localPath;
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/sbig_log.txt');
  }

  Future<String> readData() async {
    try {
      final file = await _localFile;

      // Read the file
      String contents = await file.readAsString();

      return contents;
    } catch (e) {
      // If encountering an error, return 0
      print(e.toString());
      return e.toString();
    }
  }

  Future<File> writeData(String data) async {
    final file = await _localFile;
    final previousData = await readData();
    // Write the file
    return file.writeAsString('$previousData\n$data');
  }
}