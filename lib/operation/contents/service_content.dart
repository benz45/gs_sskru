import 'package:flutter/material.dart';
import 'package:gs_sskru/components/buttons/k_text_link.dart';
import 'package:gs_sskru/components/k_launchURL.dart';
import 'package:gs_sskru/models/title_link_model.dart';
import 'package:gs_sskru/util/constants.dart';

class ServiceContent extends StatelessWidget {
  final TitleLinkModel _titleLink = TitleLinkModel().getValue;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: kDefaultPadding * 20,
      constraints: BoxConstraints(maxWidth: kMaxWidth),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding:
                const EdgeInsets.symmetric(vertical: kDefaultPadding) * 2.5,
            child: Divider(height: 0, color: Colors.grey[300]),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.max,
            children: List.generate(
              3,
              (index) {
                int _index = index + 4;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _titleLink.data![_index].headTitle,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 26,
                      ),
                    ),
                    for (var _elemSubTitle in _titleLink.data![_index].subTitle)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: KTextLink(
                          text: _elemSubTitle.text,
                          colors: Colors.black54,
                          onPressed: () {
                            k_launchURL(url: _elemSubTitle.link);
                          },
                        ),
                      )
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
