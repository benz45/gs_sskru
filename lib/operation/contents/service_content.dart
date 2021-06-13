import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gs_sskru/components/buttons/k_text_link.dart';
import 'package:gs_sskru/components/k_dialog_edit.dart';
import 'package:gs_sskru/components/k_launchURL.dart';
import 'package:gs_sskru/models/title_link_model.dart';
import 'package:gs_sskru/util/constants.dart';
import 'package:gs_sskru/util/responsive.dart';

class ServiceContent extends StatelessWidget {
  final TitleLinkModel _titleLink = TitleLinkModel().getValue;

  @override
  Widget build(BuildContext context) {
    final List<Widget> _listService = List.generate(
      3,
      (index) {
        int _index = index + 4;
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _titleLink.data![_index].headTitle,
              style: context.textTheme.headline5,
            ),
            SizedBox(height: 8),
            for (var _elemSubTitle in _titleLink.data![_index].subTitle)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: KDialogEdit(
                    child: KTextLink(
                      text: _elemSubTitle.text,
                      colors: Colors.black54,
                      onPressed: () {
                        k_launchURL(url: _elemSubTitle.link);
                      },
                    ),
                    type: DialogEditType.linkOnly(
                        link: 'link',
                        onSubmitPress: (link) {
                          // TODO
                        })),
              )
          ],
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

    Column _colList = Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: _listService,
        ),
        SizedBox(height: kDefaultPadding * 5)
      ],
    );

    return Container(
      constraints: BoxConstraints(maxWidth: kMaxWidth),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding:
                const EdgeInsets.symmetric(vertical: kDefaultPadding) * 2.5,
            child: Divider(height: 0, color: Colors.grey[300]),
          ),
          Responsive(
            mobile: _colList,
            tablet: _rowList,
            desktop: _rowList,
          )
        ],
      ),
    );
  }
}
