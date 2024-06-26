import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:yjg/shared/datasources/qr_img_data_source.dart';
import 'package:yjg/shared/service/user_info.dart';
import 'package:yjg/shared/theme/palette.dart';
import 'package:yjg/shared/widgets/base_appbar.dart';
import 'package:yjg/shared/widgets/base_drawer.dart';
import 'package:yjg/shared/widgets/bottom_navigation_bar.dart';
import 'package:timer_count_down/timer_count_down.dart';

class MealQr extends StatefulWidget {
  const MealQr({super.key});

  @override
  State<MealQr> createState() => _MealQrState();
}

class _MealQrState extends State<MealQr> {
  String qlXml = '';
  bool isLoading = true;
  String? name;
  String? studentNum;

  // ql api 호출
  void getQl() async {
    final response = await QrImgDataSource().getImgQRDataAPI();
    setState(() {
      qlXml = response.data.toString();
      isLoading = false;
    });
  }

  Future<void> loadUserInfo() async {
    final userInfo = await UserInfo.getUserInfo();
    setState(() {
      name = userInfo['name'];
      studentNum = userInfo['studentNum'];
    });
  }

  @override
  void initState() {
    super.initState();
    loadUserInfo();
    getQl();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 29, 127, 159),
      appBar: BaseAppBar(title: '식수QR'),
      drawer: BaseDrawer(),
      bottomNavigationBar: CustomBottomNavigationBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(left: 50, right: 50),
            width: 500,
            height: 500,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 20, bottom: 15, left: 10),
                  child: Row(
                    children: [
                      //뒤로가기 버튼
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.keyboard_return),
                        color: const Color.fromARGB(255, 29, 127, 159),
                      ),
                      SizedBox(
                        width: 40,
                      ),

                      //식당 QR코드 글자
                      Text(
                        '식당 QR 코드',
                        style: TextStyle(
                          color: const Color.fromARGB(255, 29, 127, 159),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                //~~~글자
                Container(
                  margin: EdgeInsets.only(bottom: 15),
                  child: Text(
                    '식당 입장 시 단말기에 QR코드를 찍어주세요.',
                    style: TextStyle(fontSize: 12),
                  ),
                ),

                //카운트 다운
                Countdown(
                  seconds: 60,
                  build: (_, double time) => Text(
                    time.toInt().toString(),
                    style: TextStyle(
                      fontSize: 25,
                    ),
                  ),
                  onFinished: () {
                    Navigator.pop(context);
                  },
                ),

                //QR여기에 넣기
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: isLoading
                      ? CircularProgressIndicator(
                          color: Palette.stateColor4,
                        )
                      : SvgPicture.string(
                          qlXml,
                          width: 200,
                          height: 200,
                        ),
                ),

                //구분 점선
                Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 10),
                  child: const Text(
                      '............................................................',
                      style:
                          TextStyle(color: Color.fromARGB(255, 173, 173, 173))),
                ),

                //학번 글자
                Text(
                  studentNum ?? '',
                  style: TextStyle(
                      color: Color.fromARGB(255, 148, 148, 148), fontSize: 15),
                ),

                //이름 글자
                Text(
                  name ?? '',
                  style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
