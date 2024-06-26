import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yjg/salon/data/data_sources/admin/admin_service_data_source.dart';
import 'package:yjg/salon/domain/entities/service.dart';
import 'package:yjg/salon/domain/usecases/admin_service_usecase.dart';
import 'package:yjg/salon/presentaion/viewmodels/service_viewmodel.dart';
import 'package:yjg/shared/theme/palette.dart';

void editServiceModal(
    BuildContext context,
    String serviceId,
    int? salonCategoryId,
    String price,
    String service,
    String gender,
    WidgetRef ref,
    String uniqueKey) {
  final serviceUseCases = ServiceUseCases(AdminServiceDataSource());

  TextEditingController nameController = TextEditingController(text: service);
  TextEditingController priceController =
      TextEditingController(text: price.toString());
  // 성별 상태 관리를 위한 StatefulBuilder 사용
  String selectedGender = gender; // 초기 성별 값을 매개변수에서 설정

  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        // StatefulBuilder를 사용하여 상태를 관리
        builder: (context, setState) {
          return Container(
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  '서비스 수정',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: '서비스명',
                    labelStyle: TextStyle(
                      color: Palette.textColor.withOpacity(0.7),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Palette.mainColor),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: priceController,
                  decoration: InputDecoration(
                    labelText: '가격',
                    labelStyle: TextStyle(
                      color: Palette.textColor.withOpacity(0.7),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Palette.mainColor),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: ListTile(
                        title: const Text('Male'),
                        horizontalTitleGap: 0,
                        leading: Radio<String>(
                          value: 'male',
                          groupValue: selectedGender,
                          onChanged: (value) {
                            setState(() {
                              selectedGender = value!;
                            });
                          },
                          activeColor: Palette.mainColor,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListTile(
                        title: const Text('Female'),
                        horizontalTitleGap: 0,
                        leading: Radio<String>(
                          value: 'female',
                          groupValue: selectedGender,
                          onChanged: (value) {
                            setState(() {
                              selectedGender = value!;
                            });
                          },
                          activeColor: Palette.mainColor,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      child: Text(
                        '서비스 삭제',
                        style: TextStyle(
                            color: Palette.stateColor3,
                            letterSpacing: -1.0,
                            fontWeight: FontWeight.bold),
                      ),
                      onPressed: () async {
                        // 삭제 확인 다이얼로그 표시
                        final confirmDelete = await showDialog<bool>(
                          context: context,
                          builder: (BuildContext dialogContext) {
                            return AlertDialog(
                              title: Text('서비스 삭제',
                                  style: TextStyle(
                                      color: Palette.textColor,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w600)),
                              content: Text('이 서비스를 삭제하시겠습니까?'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(dialogContext)
                                        .pop(false); // 다이얼로그를 닫고 false 반환
                                  },
                                  child: Text('취소',
                                      style: TextStyle(
                                          color: Palette.stateColor4,
                                          fontWeight: FontWeight.w600)),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(dialogContext)
                                        .pop(true); // 다이얼로그를 닫고 true 반환
                                  },
                                  child: Text('삭제',
                                      style: TextStyle(
                                          color: Palette.stateColor3,
                                          fontWeight: FontWeight.w600)),
                                ),
                              ],
                            );
                          },
                        );

                        // 삭제를 확인했다면, 삭제 로직 실행
                        if (confirmDelete == true) {
                          ServiceResult result = await serviceUseCases
                              .deleteService(int.parse(serviceId));
                          if (result.isSuccess) {
                            ref.refresh(servicesProvider(uniqueKey));
                            Navigator.pop(context); // 모달 닫기
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(result.message),
                              backgroundColor: Palette.mainColor,
                            ));
                          } else {
                            // 실패 알림
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(result.message),
                              backgroundColor: Colors.red,
                            ));
                          }
                        }
                      },
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        String updatedServiceName = nameController.text;
                        String updatedPrice = priceController.text;
                        String updatedGender = selectedGender;

                        // Service 인스턴스 생성
                        Service updatedService = Service(
                          serviceId: int.parse(serviceId),
                          serviceName: updatedServiceName,
                          gender: updatedGender,
                          price: updatedPrice,
                          categoryId: salonCategoryId, // 이미 있는 값이나 수정된 값을 사용
                        );

                        // 서비스 수정 로직 실행
                        ServiceResult result =
                            await serviceUseCases.updateService(updatedService);
                        if (result.isSuccess) {
                          // 서비스 리스트 상태를 업데이트하기 위해 프로바이더를 사용
                          ref.refresh(servicesProvider(uniqueKey));

                          // 스낵바를 표시하여 사용자에게 결과 알림
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(result.message),
                              backgroundColor: Palette.mainColor));

                          // 모달창 닫기
                          Navigator.pop(context);
                        } else {
                          // 수정 실패 시 스낵바를 표시하여 사용자에게 알림
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(result.message),
                              backgroundColor: Colors.red));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Palette.mainColor,
                        elevation: 0,
                      ),
                      child: Text(
                        '완료',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30)
              ],
            ),
          );
        },
      );
    },
  );
}
