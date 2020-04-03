import 'package:rxdart/rxdart.dart';
import 'package:sbig_app/src/controllers/blocs/base_bloc.dart';
import 'package:sbig_app/src/controllers/blocs/home/banner/banner_api_provider.dart';
import 'package:sbig_app/src/models/api_models/home/banner/banner_api_models.dart';
import 'package:sbig_app/src/ui/widgets/statefulwidget_base.dart';

class BannerBloc extends BaseBloc {
  BannerApiProvider _bannerApiProvider = BannerApiProvider();
  BehaviorSubject<List<Banners>> _bannerImagesStreamController = BehaviorSubject.seeded([]);
  Observable<List<Banners>> get bannerImagesStream => _bannerImagesStreamController.stream;
  Function(List<Banners>) get bannerImagesSink => _bannerImagesStreamController.sink.add;
  List<Banners>  get bannerImagesLink => _bannerImagesStreamController.value;

  void callBannerApi() {
    try {
      _bannerApiProvider.bannersApiCall().then((parsedResponse) {
        if (parsedResponse.hasData) {
          if (parsedResponse.data.status == "success") {
            _bannerImagesStreamController.add(parsedResponse.data.data.banners);
          } else {
            _bannerImagesStreamController.addError("Error");
          }
        } else if (parsedResponse.hasError) {
          _bannerImagesStreamController.addError(parsedResponse.error.message);
        }
      });
    }catch(e){
      debugPrint(e.toString());
    }
  }
  @override
  void dispose() {
    _bannerImagesStreamController.close();
  }

}

//import 'package:rxdart/rxdart.dart';
//import 'package:sbig_app/src/controllers/blocs/base_bloc.dart';
//import 'package:sbig_app/src/controllers/blocs/home/banner/banner_api_provider.dart';
//import 'package:sbig_app/src/models/api_models/home/banner/banner_api_models.dart';
//
//class BannerBloc extends BaseBloc {
//  BannerApiProvider _bannerApiProvider = BannerApiProvider();
//  BehaviorSubject<List<Banners>> _bannerImagesStreamController = BehaviorSubject.seeded([]);
//  Observable<List<Banners>> get bannerImagesStream => _bannerImagesStreamController.stream;
//
//  void callBannerApi() {
//    _bannerApiProvider.bannersApiCall().then((parsedResponse) {
//      if(parsedResponse.hasData) {
//        if(parsedResponse.data.status == "success") {
//          _bannerImagesStreamController.add(parsedResponse.data.data.banners);
//        } else {
//          _bannerImagesStreamController.addError("Error");
//        }
//      } else if (parsedResponse.hasError) {
//        _bannerImagesStreamController.addError(parsedResponse.error.message);
//      }
//    });
//  }
//  @override
//  void dispose() {
//    _bannerImagesStreamController.close();
//  }
//
//}