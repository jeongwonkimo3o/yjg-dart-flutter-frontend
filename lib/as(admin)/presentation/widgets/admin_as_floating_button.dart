import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_speed_dial/flutter_speed_dial.dart";
import "package:yjg/as(admin)/data/data_sources/as_status_data_source.dart";
import "package:yjg/as(admin)/domain/entities/status.dart";
import "package:yjg/as(admin)/domain/usecases/as_status_usecase.dart";
import "package:yjg/as(admin)/presentation/viewmodels/as_viewmodel.dart";
import "package:yjg/as(admin)/presentation/widgets/as_writing_comment_modal.dart";
import "package:yjg/shared/theme/theme.dart";

class AdminAsFloatingButton extends ConsumerWidget {
  AdminAsFloatingButton({super.key});
  final statusUseCases = StatusUseCases(StatusDataSource());

  @override
  Widget build(BuildContext context, WidgetRef ref) {
  final serviceId = ref.watch(serviceIdProvider.notifier).state;
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: const IconThemeData(size: 22.0, color: Colors.white),
      visible: true,
      curve: Curves.bounceIn,
      backgroundColor: Palette.mainColor,
      children: [
        SpeedDialChild(
            child: const Icon(Icons.chat, color: Colors.white),
            label: "댓글 작성",
            labelStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.white,
              fontSize: 15.0,
              letterSpacing: -1,
            ),
            backgroundColor: Palette.mainColor,
            labelBackgroundColor: Palette.mainColor,
            onTap: () {
              showAsWritingCommentModal(context, ref);
            }),
        SpeedDialChild(
            child: const Icon(Icons.check, color: Colors.white),
            label: "완료 처리",
            labelStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.white,
              fontSize: 15.0,
              letterSpacing: -1,
            ),
            backgroundColor: Palette.mainColor,
            labelBackgroundColor: Palette.mainColor,
            onTap: () async {
              Status updateStatus = Status(
                        serviceId: serviceId,
                      );

                      StatusResult result =
                          await statusUseCases.patchStatus(updateStatus);
                        Navigator.pop(context);

                      if (result.isSuccess) {

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(result.message),
                            backgroundColor: Palette.mainColor,
                          ),
                        );

                        // 모달 창 닫기
                      } else {
                        // 실패 시 실패 알림 표시
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(result.message),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
            }),
      ],
    );
  }
}
