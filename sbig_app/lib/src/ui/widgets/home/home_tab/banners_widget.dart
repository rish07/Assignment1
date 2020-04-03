import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:sbig_app/src/controllers/blocs/base_bloc.dart';
import 'package:sbig_app/src/controllers/blocs/home/banner/banner_bloc.dart';
import 'package:sbig_app/src/controllers/routes/url_constants.dart';
import 'package:sbig_app/src/models/api_models/home/banner/banner_api_models.dart';
import 'package:sbig_app/src/models/api_models/home/banner/banner_list.dart';
import 'package:sbig_app/src/ui/widgets/common/common_widget.dart';
import 'package:sbig_app/src/ui/widgets/common/swiper_pagination.dart';
import 'package:sbig_app/src/utilities/screen_util.dart';

import '../../statefulwidget_base.dart';

class BannersWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SbiBlocProvider(
      bloc: BannerBloc(),
      child: _BannersWidgetInternal(),
    );
  }
}

class _BannersWidgetInternal extends StatefulWidgetBase {
  @override
  _BannersWidgetState createState() => _BannersWidgetState();
}

class _BannersWidgetState extends State<_BannersWidgetInternal>
    with CommonWidget {
  final SwiperController _swiperController = SwiperController();
  BannerBloc _bannerBloc;
  static bool isBannerAPICalled = false;

  final int _pageCount = 3;
  int _currentIndex = 0;

  @override
  void initState() {
    _bannerBloc = SbiBlocProvider.of<BannerBloc>(context);
    if (BannerList.bannersList == null || BannerList.bannersList.length == 0) {
      _bannerBloc.callBannerApi();
    } else {
      _bannerBloc.bannerImagesSink(BannerList.bannersList);
    }
    super.initState();
  }

  @override
  void dispose() {
    _bannerBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = ScreenUtil.getInstance(context).screenWidthDp;
    double height = screenWidth / 1.873;

    return SizedBox(
      height: isIPad(context) ? height : 210,
      child: Stack(
        children: <Widget>[
          Positioned.fill(
              child: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
            ColorConstants.pre_medical_gradient_color1,
            ColorConstants.pre_medical_gradient_color2
          ])))),
          StreamBuilder<List<Banners>>(
              stream: _bannerBloc.bannerImagesStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.length != 0) {
                    isBannerAPICalled = true;
                    BannerList.bannersList = _bannerBloc.bannerImagesLink;
                    return Swiper(
                      itemHeight: isIPad(context) ? height - 50 : 170,
                      containerHeight: isIPad(context) ? height - 50 : 170,
                      index: 0,
                      controller: _swiperController,
                      itemCount: snapshot.data.length,
                      autoplayDelay: 2000,
                      autoplay: true,
                      /*onIndexChanged: (index) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },*/
                      loop: true,
                      itemBuilder: (context, index) {
                        return _buildPage(icon: snapshot.data[index].imagepath);
                      },
                      pagination: SwiperPagination(
                          builder: CustomPaginationBuilder(
                              activeColor: Colors.white,
                              activeSize: Size(16.0, 8.0),
                              size: Size(12.0, 8.0),
                              color: Colors.grey.shade600.withOpacity(0.5))),
                    );
                  } else {
                    isBannerAPICalled = false;
                    return retryWidget(S.of(context).empty_banners);
                  }
                } else if (snapshot.hasError) {
                  isBannerAPICalled = false;
                  return retryWidget(S.of(context).no_internet_image_try);
                } else {
                  isBannerAPICalled = false;
                  return _progressBar();
                }
              }),
        ],
      ),
    );
  }

  Widget retryWidget(String message){
    return Stack(
      children: <Widget>[
        Center(
          child: Text(
            message,
            style: TextStyle(color: Colors.white),
          ),
        ),
        Center(
          child: RawMaterialButton(
            padding: const EdgeInsets.all(10.0),
            shape: CircleBorder(),
            elevation: 2.0,
            onPressed: () {
              _bannerBloc.callBannerApi();
            },
            child: CircleAvatar(
                backgroundColor: Colors.black.withOpacity(0.5),
                radius: 30.0,
                child: Icon(
                  Icons.refresh,
                  size: 40,
                  color: Colors.white,
                )),
          ),
        ),
      ],
    );
  }

  Widget _buildPage({String title, String icon}) {
    icon = UrlConstants.URL + icon;
//    return SizedBox.expand(
//        child: Image(
//      image: NetworkImage(icon),
//      fit: BoxFit.cover,
//    ));

//    return SizedBox.expand(
//        child: Image(
//          image: AssetImage(AssetConstants.ic_test),
//          fit: BoxFit.fill,
//        ));

    return SizedBox.expand(
        child: Image(
      image: NetworkImage(icon),
      fit: BoxFit.fill,
    ));
  }

  Widget _progressBar() {
    return Container(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
