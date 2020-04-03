
import 'package:flutter/material.dart';

enum DownloadFileStatus{
   DONE, IN_PROGRESS, SUCCESS, FAILED, CANCEL
}

class DownloadStatusModel{
  DownloadFileStatus status;
  String currentStatus;
  IconData currentStatusIcon;
  String buttonString;
  String path;

  DownloadStatusModel({this.status, this.currentStatus, this.currentStatusIcon,
      this.buttonString, this.path});


}