import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:gs_sskru/util/constants.dart';

class ContactTablet extends StatelessWidget {
  const ContactTablet({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            vertical: kDefaultPadding * .75,
            horizontal: kDefaultPadding,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: kPrimaryColor,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: kDefaultPadding),
                child: FaIcon(
                  FontAwesomeIcons.phone,
                  color: kPrimaryColor,
                  size: context.textTheme.caption!.fontSize,
                ),
              ),
              Text(
                "099-9999-999",
                style: context.textTheme.caption!.copyWith(
                  color: kPrimaryColor,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: kDefaultPadding),
        Container(
          padding: EdgeInsets.symmetric(
            vertical: kDefaultPadding * .75,
            horizontal: kDefaultPadding * .75,
          ),
          decoration: BoxDecoration(
            color: kPrimaryColor,
            border: Border.all(
              color: kPrimaryColor,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: kDefaultPadding),
                child: FaIcon(
                  FontAwesomeIcons.facebookF,
                  color: Colors.white,
                  size: context.textTheme.caption!.fontSize,
                ),
              ),
              Text(
                "สำหนักงานบัญฑิตศึกษา",
                style: context.textTheme.caption!.copyWith(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}