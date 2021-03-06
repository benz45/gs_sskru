import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:gs_sskru/components/k_dialog.dart';
import 'package:gs_sskru/components/k_format_date.dart';
import 'package:gs_sskru/components/k_launchURL.dart';
import 'package:gs_sskru/components/k_toast.dart';
import 'package:gs_sskru/controllers/news_controller.dart';
import 'package:gs_sskru/models/link_model.dart';
import 'package:gs_sskru/operation/contents/home_content/components/form_action_link.dart';
import 'package:gs_sskru/util/constants.dart';

class ListNews extends StatefulWidget {
  ListNews({
    Key? key,
    required this.data,
    required this.width,
    required this.isAuth,
    required this.spaceBottom,
  }) : super(key: key);

  final LinkModel data;
  final double width;
  final bool isAuth;
  final bool spaceBottom;

  @override
  _ListNewsState createState() => _ListNewsState();
}

class _ListNewsState extends State<ListNews> {
  late double width;
  late double _inputWidth;
  late bool isAuth;
  late bool spaceBottom;
  late TextEditingController _textController =
      TextEditingController(text: widget.data.text);
  late TextEditingController _linkController =
      TextEditingController(text: widget.data.link);
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final _newsController = Get.find<NewsController>();
  @override
  void initState() {
    super.initState();
    width = widget.width;
    _inputWidth = width - (kDefaultPadding * 2);
    isAuth = widget.isAuth;
    spaceBottom = widget.spaceBottom;
  }

  @override
  void dispose() {
    _textController.dispose();
    _linkController.dispose();
    super.dispose();
  }

  bool _isSlideAnimationChanged = false;
  bool _isHover = false;
  bool _isEdit = false;
  bool _isLoading = false;

  late SlidableController slidableController = SlidableController(
      onSlideIsOpenChanged: onSlideIsOpenChanged,
      onSlideAnimationChanged: (Animation<double>? value) => null);

  void onSlideIsOpenChanged(bool? isOpen) {
    if (isOpen!) {
      setState(() {
        _isSlideAnimationChanged = true;
      });
    } else {
      setState(() {
        _isSlideAnimationChanged = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        overlayColor: MaterialStateProperty.all(Colors.grey[50]),
        highlightColor: Colors.grey[50],
        onHover: (value) {
          setState(() {
            _isHover = value;
          });
        },
        onTap: () => k_launchURL(url: widget.data.link!),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: widget.width,
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  Slidable(
                    controller: slidableController,
                    actionPane: SlidableBehindActionPane(),
                    movementDuration: Duration(milliseconds: 600),
                    actionExtentRatio: 0.15,
                    enabled: widget.isAuth,
                    actions: <Widget>[
                      IconSlideAction(
                        caption: '??????',
                        color: Colors.grey[50],
                        iconWidget: Icon(
                          Icons.close,
                          size: 14,
                          color: Colors.grey[600],
                        ),
                        foregroundColor: Colors.grey[600],
                        onTap: () {
                          kDialog(
                            title: '?????????????????????????????????',
                            content: Text(
                              '????????????????????????????????????????????????????????????????????????????????????????????? ?',
                            ),
                            onConfirm: _removeLinkOnDatabase,
                          );
                        },
                      ),
                      IconSlideAction(
                        caption: '???????????????',
                        color: Colors.grey[50],
                        iconWidget: Icon(
                          Icons.edit_outlined,
                          size: 14,
                          color: Colors.grey[600],
                        ),
                        foregroundColor: Colors.grey[600],
                        onTap: () {
                          setState(() {
                            _isEdit = true;
                          });
                        },
                      ),
                    ],
                    child: Container(
                      width: widget.width * .7,
                      color: Colors.grey[50],
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: kDefaultPadding,
                          vertical: kDefaultPadding,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Container(
                                width: widget.width * .7,
                                child: Text(
                                  widget.data.text!,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: _isHover
                                        ? kPrimaryColor
                                        : Colors.black87.withOpacity(.75),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // * Data time
                  Positioned(
                    right: kDefaultPadding,
                    child: AnimatedOpacity(
                      opacity: !_isSlideAnimationChanged ? 1 : 0,
                      duration: Duration(milliseconds: 300),
                      child: Container(
                        child: Text(
                          KFormatDate.getDateThai(
                            date: '${widget.data.createDate}',
                            time: false,
                          ),
                          style: TextStyle(
                              fontWeight: FontWeight.w300, color: Colors.grey),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            if (_isEdit)
              Center(
                child: FormActionLink(
                  inputWidth: _inputWidth,
                  type: FormActionLinkType.all(
                    onSubmitPress: _editLinkToDatabase,
                    title: '?????????????????????????????????',
                    link: '????????????????????????????????????????????????',
                    textController: _textController,
                    linkController: _linkController,
                  ),
                  onClosePress: () {
                    setState(() {
                      _isEdit = false;
                    });
                  },
                  isLoading: _isLoading,
                ),
              ),
            if (widget.spaceBottom) ...{
              SizedBox(height: 30),
            } else ...{
              Container(
                margin: const EdgeInsets.symmetric(
                    horizontal: kDefaultPadding, vertical: 2),
                child: Divider(height: 0, color: Colors.grey[300]),
              ),
            }
          ],
        ),
      ),
    );
  }

  Future<bool> _validateText() async {
    if (_textController.text.trim() != "" &&
        _linkController.text.trim() != "") {
      return true;
    }
    return false;
  }

  _editLinkToDatabase() async {
    print('editing...');
    try {
      setState(() {
        _isLoading = true;
      });
      final bool _isValidated = await _validateText();
      if (_isValidated) {
        final Map<String, dynamic> _linkModel = {
          "text": _textController.text,
          "link": _linkController.text,
        };

        _firebaseFirestore
            .collection('news')
            .doc(widget.data.id)
            .update(_linkModel)
            .then((value) {
          _newsController.updateLinkModelInList(
              id: widget.data.id!, value: _linkModel);
          setState(() {
            _isEdit = false;
            _isLoading = false;
          });

          kToast(
            '????????????????????????????????? !',
            Text('?????????????????????????????????????????????????????????????????????????????????????????????'),
          );
        });
      } else {
        kToast(
          '????????????????????????????????????????????????????????????????????????',
          Text('?????????????????????????????????????????????????????????????????????????????????????????????????????????????????????'),
        );
      }
    } catch (err) {
      print(err);
      setState(() {
        _isEdit = false;
        _isLoading = false;
      });
      kToast(
        '????????????????????????????????????????????????????????????????????????',
        Text('??????????????????????????????????????????????????????????????????'),
      );
    }
  }

  _removeLinkOnDatabase() async {
    try {
      _firebaseFirestore
          .collection('news')
          .doc(widget.data.id)
          .delete()
          .then((value) {
        Get.back();
        _newsController.removeLinkModelInList(id: widget.data.id!);
        setState(() {
          _isEdit = false;
        });
        kToast(
          '??????????????????????????????????????? !',
          Text('?????????????????????????????????????????????????????????????????????????????????????????????'),
        );
      });
    } catch (err) {
      Get.back();
      setState(() {
        _isEdit = false;
      });
      kToast(
        '???????????????????????????????????????????????????????????????',
        Text('??????????????????????????????????????????????????????????????????'),
      );
    }
  }
}
