import 'dart:math';

import 'package:sbig_app/src/resources/sharedpreference_helper.dart';

class LoaderList {
  static Random rnd;

  static Random getRandom() {
    if (rnd == null) {
      return new Random();
    }
    return rnd;
  }

  String getLoaderMessage() {
    var lst = prefsHelper.getLoaderMessages();
    if (lst != null) {
      if(lst.length == 0) return null;
      if(lst.length == 1) return lst[0];
      int index = getRandomIndex(lst.length);
      var element = lst[index];
      return element;
    }
    return null;
  }

  int getRandomIndex(int length) {
    int tempIndex = getRandom().nextInt(length);
    int loaderIndex = prefsHelper.getLoaderIndex();
    if (tempIndex == loaderIndex) {
      tempIndex = getRandom().nextInt(length);
      if(tempIndex == loaderIndex) {
        //Recursive loop to generate again a new index
        return getRandomIndex(length);
      }else{
        prefsHelper.setLoaderIndex(tempIndex);
        return tempIndex;
      }
    } else {
      prefsHelper.setLoaderIndex(tempIndex);
      return tempIndex;
    }
  }
}
