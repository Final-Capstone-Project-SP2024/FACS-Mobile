import 'package:facs_mobile/core/utils/image_constant.dart';
import 'package:facs_mobile/core/utils/size_utils.dart';
import 'package:facs_mobile/pages/NavigationBar/SubPage/location_detail_page.dart';
import 'package:facs_mobile/services/location_services.dart';
import 'package:facs_mobile/themes/app_decoration.dart';
import 'package:facs_mobile/themes/theme_helper.dart';
import 'package:facs_mobile/widgets/app_bar/custom_app_bar.dart';
import 'package:facs_mobile/widgets/custom_image_view.dart';
import 'package:flutter/material.dart';

class LocationListShow extends StatefulWidget {
  LocationListShow({Key? key}) : super(key: key);

  @override
  _LocationAll createState() => _LocationAll();
}

class _LocationAll extends State<LocationListShow> {
  GlobalKey<NavigatorState> navigatorKey = GlobalKey();
  List<dynamic> locationData = [];
  @override
  void initState() {
    super.initState();
    fetchLocationData();
  }

  Future<void> fetchLocationData() async {
    dynamic data = await LocationServices.getLocation();
    setState(() {
      locationData = data != null ? data['data'] : [];
    });
    print(locationData);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: SizedBox(
            width: double.maxFinite,
            child: Column(
              children: [
                SizedBox(height: 50.v),
                // CustomImageView(
                //   imagePath: ImageConstant.imageLocationRectangle2,
                //   height: 260.v,
                //   width: 375.h,
                // ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: locationData.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        // Adding condition to show CustomImageView
                        CustomImageView(
                          imagePath:
                              "https://firebasestorage.googleapis.com/v0/b/final-capstone-project-f8bdd.appspot.com/o/locationImage%2F${locationData[index]['locationImage']}?alt=media&token=eb9237b2-5a76-48ba-ad3d-c4783ef415e9",
                          height: 260.v,
                          width: 375.h,
                        ),
                        _locationElement(
                          context,
                          locationName: locationData[index]["locationName"],
                          locationId: locationData[index]["locationId"],
                          imageLocation: locationData[index]['locationImage'],
                          userQuantity: locationData[index]['numberOfSecurity']
                              .toString(),
                          cameraQuantity:
                              locationData[index]['numberOfCamera'].toString(),
                        ),

                        SizedBox(height: 22.v),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _locationElement(BuildContext context,
      {required String locationName,
      required String locationId,
      required String imageLocation,
      required String userQuantity,
      required String cameraQuantity}) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LocationDetail(
                  locationId: locationId,
                  cameraInLocation: cameraQuantity,
                  locationImage: imageLocation,
                  userInLocation: userQuantity,
                ),
              ),
            );
          },
          child: Container(
            width: double.maxFinite,
            padding: EdgeInsets.symmetric(
              horizontal: 21.h,
              vertical: 14.v,
            ),
            decoration: AppDecoration.fillGray,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: 3.h,
                    top: 5.v,
                    bottom: 7.v,
                  ),
                  child: Text(
                    locationName,
                    style: theme.textTheme.titleMedium!
                        .copyWith(color: theme.colorScheme.onPrimary),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LocationDetail(
                          locationId: locationId,
                          cameraInLocation: cameraQuantity,
                          locationImage: imageLocation,
                          userInLocation: userQuantity,
                        ),
                      ),
                    );
                  },
                  child: CustomImageView(
                    imagePath: ImageConstant.imageGarage,
                    height: 28.adaptSize,
                    width: 28.adaptSize,
                    margin: EdgeInsets.only(top: 4.v),
                  ),
                ),
              ],
            ),
          ),
        ),
        Divider(),
      ],
    );
  }

  PreferredSizeWidget _appBar(BuildContext context) {
    return CustomAppBar();
  }
}
