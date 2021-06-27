import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:gs_sskru/components/buttons/k_text_link.dart';
import 'package:gs_sskru/components/k_dialog_edit.dart';
import 'package:gs_sskru/components/k_launchURL.dart';
import 'package:gs_sskru/controllers/service_controller.dart';
import 'package:gs_sskru/util/constants.dart';

class AcademicContent extends GetView<ServiceController> {
  @override
  Widget build(BuildContext context) {
    List<Widget> _listService = List.generate(
      1,
      (index) {
        return Obx(
          () {
            return Expanded(
              child: ListView.builder(
                itemCount: controller.getAcademic.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (_, index) => Container(
                  child: Container(
                    child: Center(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: KDialogEdit(
                              direction: DirectionDialogEdit.forCenter,
                              title:
                                  "ลิงค์${controller.getAcademic[index].text}",
                              child: Container(
                                width: context.isPhone
                                    ? context.width - (kDefaultPadding * 2)
                                    : context.width * .5,
                                child: Row(
                                  mainAxisAlignment: context.isPhone
                                      ? MainAxisAlignment.start
                                      : MainAxisAlignment.center,
                                  children: [
                                    Flexible(
                                      child: KTextLink(
                                        text:
                                            controller.getAcademic[index].text!,
                                        fontSize: context
                                            .textTheme.headline6!.fontSize,
                                        colors: Colors.black54,
                                        onPressed: () {
                                          k_launchURL(
                                              url: controller
                                                  .getAcademic[index].link!);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              type: DialogEditType.linkOnly(
                                link: controller.getAcademic[index].link ??
                                    notFound,
                                onSubmitPress: (link) {
                                  controller.updateService(
                                    doc: UpdateServiceTo.academic,
                                    id: controller.getAcademic[index].id!,
                                    key: ServiceKey.link,
                                    value: link,
                                  );
                                },
                              ),
                            ),
                          ),
                          if (index < controller.getAcademic.length - 1)
                            SizedBox(
                              height: kDefaultPadding * 2,
                              child: Divider(),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
    Column _rowList = Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.max,
          children: _listService,
        ),
        SizedBox(height: kDefaultPadding * 10)
      ],
    );

    return Container(
      constraints: BoxConstraints(maxWidth: kMaxWidth * .75),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding:
                const EdgeInsets.symmetric(vertical: kDefaultPadding) * 2.5,
          ),
          _rowList
        ],
      ),
    );
  }
}
