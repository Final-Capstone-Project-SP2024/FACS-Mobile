import 'package:facs_mobile/core/utils/image_constant.dart';
import 'package:facs_mobile/core/utils/size_utils.dart';
import 'package:facs_mobile/pages/NavigationBar/SubPage/action_page.test.dart';
import 'package:facs_mobile/pages/home_page.dart';
import 'package:facs_mobile/services/record_service.dart';
import 'package:facs_mobile/services/user_services.dart';
import 'package:facs_mobile/themes/app_decoration.dart';
import 'package:facs_mobile/themes/custom_bottom_style.dart';
import 'package:facs_mobile/themes/custom_text_style.dart';
import 'package:facs_mobile/themes/theme_helper.dart';
import 'package:facs_mobile/widgets/custom_evulated_bottom.test.dart';
import 'package:facs_mobile/widgets/custom_icon_button.dart';
import 'package:facs_mobile/widgets/custom_image_view.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

// ignore_for_file: must_be_immutable
class RecordDetailUserRoleEightScreen extends StatefulWidget {
  final String recordId;
  final String state;

  const RecordDetailUserRoleEightScreen(
      {super.key, required this.recordId, required this.state});

  @override
  _RecordDetailPageState createState() => _RecordDetailPageState();
}

class _RecordDetailPageState extends State<RecordDetailUserRoleEightScreen> {
  dynamic recordDetailResponse;
  bool _showVideo = false;
  late VideoPlayerController _videoController;
  TextEditingController locationController = TextEditingController();
  TextEditingController colortexboxoneController = TextEditingController();

  GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    getRecordDetailId(widget.recordId);
  }

  @override
  Widget build(BuildContext context) {
    bool shouldHideWhenAlertAll = recordDetailResponse['userVoting'].any(
        (vote) =>
            vote['userId'] == UserServices.userId && vote['voteLevel'] == 5);
    return SafeArea(
      child: Scaffold(
        backgroundColor: appTheme.whiteA700,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text('Record detail'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: SizedBox(
          width: SizeUtils.width,
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Form(
                key: _formKey,
                child: Padding(
                  padding: EdgeInsets.only(left: 0),
                  child: Column(
                    children: [
                      _showVideo
                          ? _showVideoWidget(context)
                          : _showImage(context),
                      SizedBox(height: 1.v),
                      _buildRowcameraone(context),
                      SizedBox(height: 5.v),
                      _buildUiboxmini(context),
                      SizedBox(height: 10.v),
                      Padding(
                        padding: EdgeInsets.only(left: 15.h),
                        child: Column(
                          children: [
                            _buildColumntypesomet(context),
                            SizedBox(height: 21.v),
                            _buildColumntypesomet1(context),
                            SizedBox(height: 5.v),
                            if (recordDetailResponse['userVoting'].isNotEmpty)
                              _buildActionFunction(context,
                                  recordIdAdding:
                                      recordDetailResponse['recordId']),
                            SizedBox(height: 5.v),
                            //Buttons section
                            if (recordDetailResponse['status'] ==
                                "InAlarm") ...[
                              Column(
                                children: [
                                  _buildActionButton(context,
                                      recordIdAdding:
                                          recordDetailResponse['recordId']),
                                  SizedBox(height: 20.h),
                                  _buildFakeAlarmButton(context,
                                      recordIdAdding:
                                          recordDetailResponse['recordId']),
                                ],
                              )
                            ],
                            if (recordDetailResponse['status'] ==
                                "InAction") ...[
                              Column(
                                children: [
                                  if (!shouldHideWhenAlertAll)
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Expanded(
                                          child: _buildFakeAlarmButton(
                                            context,
                                            recordIdAdding:
                                                recordDetailResponse[
                                                    'recordId'],
                                          ),
                                        ),
                                        SizedBox(width: 8.0),
                                        Expanded(
                                          child: _buildAlertAllButton(
                                            context,
                                            recordIdAdding:
                                                recordDetailResponse[
                                                    'recordId'],
                                          ),
                                        ),
                                      ],
                                    ),
                                  SizedBox(height: 16.0),
                                  _buildFinishButton(
                                    context,
                                    recordIdAdding:
                                        recordDetailResponse['recordId'],
                                  ),
                                ],
                              )
                            ]
                          ],
                        ),
                      ),
                      SizedBox(height: 20.v),
                    ],
                  ),
                )),
          ),
        ),
      ),
    );
  }

  void _initializeVideoController() {
    _videoController = VideoPlayerController.network(
        "https://firebasestorage.googleapis.com/v0/b/final-capstone-project-f8bdd.appspot.com/o/VideoRecord%2F${recordDetailResponse['videoRecord']['videoUrl']}?alt=media&token=18e13091-0a41-4b0e-9b9c-283fb2f3a803")
      ..initialize().then((_) {
        setState(() {});
      });
  }

  Future<dynamic> getRecordDetailId(String recordId) async {
    print(recordId);
    var data = await RecordService.getRecordDetail(recordId);
    setState(() {
      if (data != null) {
        recordDetailResponse = data['data'];

        print(recordDetailResponse);
        _initializeVideoController();
      }
    });
  }

  Widget _showVideoWidget(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 18.h,
        vertical: 14.v,
      ),
      decoration: AppDecoration.fillBlueGray,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  if (_videoController.value.isPlaying) {
                    _videoController.pause();
                  } else {
                    _videoController.play();
                  }
                });
              },
              child: Container(
                color: Colors.black,
                child: _videoController.value.isInitialized
                    ? AspectRatio(
                        aspectRatio: _videoController.value.aspectRatio,
                        child: VideoPlayer(_videoController),
                      )
                    : Container(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _showImage(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 18.h,
        vertical: 14.v,
      ),
      decoration: AppDecoration.fillBlueGray,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                // Add your code to navigate to another page here
              },
              child: Container(
                color: Colors.black,
                child: Image.network(
                  'https://firebasestorage.googleapis.com/v0/b/final-capstone-project-f8bdd.appspot.com/o/ImageRecord%2F${recordDetailResponse['imageRecord']['imageUrl']}?alt=media&token=7b30179f-3ec9-4e33-956d-7ad737aeb82f',
                  fit: BoxFit.cover,
                  width: double.maxFinite,
                  height: 200, // Maximum input size
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildRowcameraone(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 15.h,
        vertical: 10.v,
      ),
      decoration: AppDecoration.fillGray,
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: 0.v),
              child: Text(
                "Media Record",
                style: theme.textTheme.titleLarge,
              ),
            ),
          ),
          const Spacer(),
          CustomIconButton(
            decoration: AppDecoration.fillGray,
            height: 24.adaptSize,
            width: 24.adaptSize,
            child: CustomImageView(
              imagePath: ImageConstant.imgCameraOnprimary,
            ),
            onTap: () {
              setState(() {
                _showVideo = false;
              });
            },
          ),
          SizedBox(width: 20.h),
          CustomIconButton(
            decoration: AppDecoration.fillGray,
            height: 24.adaptSize,
            width: 24.adaptSize,
            child: CustomImageView(
              imagePath: ImageConstant.imgUpload,
            ),
            onTap: () {
              setState(() {
                _showVideo = true;
              });
            },
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildUiboxmini(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(
        horizontal: 17.h,
        vertical: 2.v,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: 10.h,
              top: 2.v,
              bottom: 2.v,
            ),
            child: Text(
              recordDetailResponse['status'],
              style: theme.textTheme.titleMedium,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 5.v),
            child: Text(
              recordDetailResponse['recordTime'],
              style: theme.textTheme.titleMedium,
            ),
          )
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildColumntypesomet(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.h),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              height: 24.v,
              width: 90.h,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Camera",
                      style: CustomTextStyles.titleLargeBluegray300,
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Camera",
                      style: CustomTextStyles.titleLargeBluegray300,
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: 4.v),
          Padding(
            padding: EdgeInsets.only(
              left: 18.h,
              right: 32.h,
            ),
            child: _buildColorwhite(
              context,
              typesomething: "Location",
              typesomething1: "Location A",
            ),
          ),
          SizedBox(height: 1.v),
          Padding(
            padding: EdgeInsets.only(
              left: 18.h,
              right: 32.h,
            ),
            child: _buildColorwhite(
              context,
              typesomething: "Camera Name",
              typesomething1: recordDetailResponse['cameraName'],
            ),
          ),
          SizedBox(height: 1.v),
          Padding(
            padding: EdgeInsets.only(
              left: 18.h,
              right: 32.h,
            ),
            child: _buildColorwhite(
              context,
              typesomething: "Camera Destination",
              typesomething1: recordDetailResponse['cameraDestination'],
            ),
          )
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildColumntypesomet1(BuildContext context) {
    String alarmLevel = recordDetailResponse['recommendAlarmLevel'].toString();
    String cleanedAlarmLevel = alarmLevel.replaceAll('Alarm ', '');
    String finishTime =
        recordDetailResponse['finishTime'] == "00:00:00 01-01-0001"
            ? "Not Finish"
            : recordDetailResponse['finishTime'];
    String AlarmAccountable = recordDetailResponse['alarmUser'] == null
        ? "AI Detect"
        : recordDetailResponse['alarmUser']['name'];
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.h),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Analysis",
              style: CustomTextStyles.titleLargeBluegray300,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 15.h,
              right: 31.h,
            ),
            child: _buildColorwhite(
              context,
              typesomething: "AI Predicted",
              typesomething1:
                  recordDetailResponse['predictedPercent'].toString(),
            ),
          ),
          SizedBox(height: 3.v),
          Padding(
            padding: EdgeInsets.only(
              left: 15.h,
              right: 31.h,
            ),
            child: _buildColorwhite(
              context,
              typesomething: "Recommend Alarm Level",
              typesomething1: cleanedAlarmLevel,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 15.h,
              right: 31.h,
            ),
            child: _buildColorwhite(
              context,
              typesomething: "Detected by",
              typesomething1: AlarmAccountable,
            ),
          ),
          SizedBox(height: 3.v),
          Padding(
            padding: EdgeInsets.only(
              left: 15.h,
              right: 31.h,
            ),
            child: _buildColorwhite(
              context,
              typesomething: "Finish time",
              typesomething1: finishTime,
            ),
          ),
          SizedBox(height: 3.v),
        ],
      ),
    );
  }

  Widget _buildActionFunction(BuildContext context,
      {required String recordIdAdding}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.h),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Action",
              style: CustomTextStyles.titleLargeBluegray300,
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: recordDetailResponse['userVoting'].length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(
                  left: 15.h,
                  right: 31.h,
                ),
                child: _buildColorwhite(
                  context,
                  typesomething: recordDetailResponse['userVoting'][index]
                      ['securityCode'],
                  typesomething1: recordDetailResponse['userVoting'][index]
                      ['voteType'],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  /// Common widget
  Widget _buildColorwhite(
    BuildContext context, {
    required String typesomething,
    required String typesomething1,
  }) {
    return Container(
      decoration: AppDecoration.fillWhiteA,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 13.v),
          Padding(
            padding: EdgeInsets.only(right: 30.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  typesomething,
                  style: CustomTextStyles.titleMediumOnPrimary.copyWith(
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 2.v),
                  child: Text(
                    typesomething1,
                    style: theme.textTheme.titleSmall!.copyWith(
                      color: appTheme.blueGray300,
                    ),
                  ),
                )
              ],
            ),
          ),
          Divider()
        ],
      ),
    );
  }

  /// Move all buttons to reduce redundancy

  Widget _buildFakeAlarmButton(BuildContext context,
      {required String recordIdAdding}) {
    return CustomEvulatedBottom(
      onPressed: () async {
        bool confirmed = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Confirm"),
              content:
                  Text("Are you sure you want to set status to false alarm?"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    side: MaterialStateProperty.all(
                      BorderSide(color: Colors.black),
                    ),
                    textStyle: MaterialStateProperty.all(
                      TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                  ),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                    child: Text(
                      "Cancel",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    side: MaterialStateProperty.all(
                      BorderSide(color: Colors.black87),
                    ),
                    textStyle: MaterialStateProperty.all(
                      TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.all(Colors.blue),
                  ),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                    child: Text(
                      "Confirm",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            );
          },
        );

        if (confirmed != null && confirmed) {
          bool setStatus = await RecordService.actionAlarm(
              recordId: recordIdAdding, alarmLevel: 7);
          if (setStatus) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Successfully set status to false alarm'),
                duration: Duration(seconds: 2),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to set status to false alarm'),
                duration: Duration(seconds: 2),
              ),
            );
          }
        }
      },
      text: "Fake Alarm",
      buttonStyle: CustomBottomStyle.fillYellow,
      margin: EdgeInsets.only(right: 22.h),
      buttonTextStyle: CustomTextStyles.titleMediumWhiteA700,
    );
  }

  Widget _buildActionButton(BuildContext context,
      {required String recordIdAdding}) {
    return CustomEvulatedBottom(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AlarmPage(
              recordId: recordIdAdding,
            ),
          ),
        );
      },
      text: "Action",
      buttonStyle: CustomBottomStyle.fillBlue,
      margin: EdgeInsets.only(right: 22.h),
      buttonTextStyle: CustomTextStyles.titleMediumWhiteA700,
    );
  }

  Widget _buildAlertAllButton(BuildContext context,
      {required String recordIdAdding}) {
    return Expanded(
      child: CustomEvulatedBottom(
        onPressed: () {
          RecordService.actionAlarm(recordId: recordIdAdding, alarmLevel: 5);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        },
        text: "Alert All",
        buttonStyle: CustomBottomStyle.fillRed,
        margin: EdgeInsets.only(right: 22.h),
        buttonTextStyle: CustomTextStyles.titleMediumWhiteA700,
      ),
    );
  }

  Widget _buildFinishButton(BuildContext context,
      {required String recordIdAdding}) {
    return CustomEvulatedBottom(
      onPressed: () {
        RecordService.finishActionPhase(recordId: recordIdAdding);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Successfully'),
            duration: Duration(seconds: 2),
          ),
        );
      },
      text: "Finish",
      buttonStyle: CustomBottomStyle.fillGreen,
      margin: EdgeInsets.only(right: 22.h),
      buttonTextStyle: CustomTextStyles.titleMediumWhiteA700,
    );
  }
}
