import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onepass/models/account.dart';
import 'package:onepass/utils/utility.dart' as Utils;
import 'package:onepass/widget/dialog_title.dart';

class BottomSheetDecrypt extends StatefulWidget {
  final double dw;
  final double dh;
  final Account account;
  BottomSheetDecrypt({
    Key key,
    this.dw,
    this.dh,
    this.account,
  }) : super(key: key);

  @override
  _BottomSheetDecryptState createState() => _BottomSheetDecryptState();
}

class _BottomSheetDecryptState extends State<BottomSheetDecrypt> {
  bool _isDecoded = false;
  bool _isObscured = true;
  bool _showSb = false;
  final GlobalKey<FormState> _secretKeyFormKey = new GlobalKey<FormState>();
  final TextEditingController _secretKeyController =
      new TextEditingController();
  String _decoded;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _secretKeyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildBottomSheetBody(context);
  }

  Column _buildBottomSheetBody(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.symmetric(
              vertical: widget.dh * 1, horizontal: widget.dw * 2),
          width: double.maxFinite,
          child: Text(
            widget.account.nickName,
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: widget.dh * 2),
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(widget.dh * 4),
            ),
          ),
        ),
        Container(
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(
              horizontal: widget.dw * 2.4, vertical: widget.dh * 1),
          margin: EdgeInsets.symmetric(
              vertical: widget.dh * 2, horizontal: widget.dw * 4),
          decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.8),
              borderRadius: BorderRadius.circular(widget.dh * 4)),
          child: Text(
            widget.account.hash,
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: widget.dh * 2),
          ),
        ),
        GestureDetector(
          onTap: !_isDecoded
              ? () => _decode(widget.dw, widget.dh)
              : () => _showOrHidePass(),
          onDoubleTap: _isDecoded ? () => _copyPass(context) : () {},
          child: Container(
            margin: EdgeInsets.symmetric(
                horizontal: widget.dw * 4, vertical: widget.dh * 2),
            padding: EdgeInsets.symmetric(
                vertical: widget.dh * 3, horizontal: widget.dw * 4),
            width: double.maxFinite,
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  const Color(0xffe6e6e6),
                  Colors.white,
                ], begin: Alignment(-5, -5), end: Alignment(1, 1)),
                borderRadius: BorderRadius.circular(widget.dh * 4),
                boxShadow: [
                  BoxShadow(
                      color: Color(0xffd9d9d9),
                      offset: Offset(widget.dh * 1, widget.dh * 1),
                      blurRadius: widget.dh * 0.5),
                  BoxShadow(
                      color: Colors.white,
                      offset: Offset(widget.dh * -1, widget.dh * -1),
                      blurRadius: widget.dh * 0.5),
                ]),
            child: !_isDecoded || _decoded == null
                ? Text(
                    'TAP TO DECODE',
                    style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w600,
                        fontSize: widget.dh * 3),
                    textAlign: TextAlign.center,
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _isObscured ? '*' * _decoded.length : _decoded,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        "(TAP TO SHOW, DOUBLE TAP TO COPY)",
                        style: TextStyle(
                            color: Colors.blue, fontSize: widget.dh * 2),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
          ),
        ),
        _showSb
            ? Container(
                margin: EdgeInsets.symmetric(
                    vertical: widget.dh * 2, horizontal: widget.dw * 4),
                padding: EdgeInsets.symmetric(vertical: widget.dh * 2),
                width: double.maxFinite,
                decoration: BoxDecoration(color: Colors.black, boxShadow: [
                  BoxShadow(
                    color: Colors.white,
                    blurRadius: 9,
                    offset: Offset(4, 4),
                  )
                ]),
                child: Text(
                  'Copied to clipboard',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
              )
            : SizedBox(
                height: 0,
              )
      ],
    );
  }

  _decode(double dw, double dh) async {
    final String key = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SecretKeyDialog(
              dw: dw,
              dh: dh,
              secretKeyFormKey: _secretKeyFormKey,
              secretKeyController: _secretKeyController);
        });

    if (!Utils.isNullOrEmpty(key)) {
      setState(() {
        _decoded = Utils.decrypt(widget.account.hash, key);
        if (!Utils.isNullOrEmpty(_decoded)) _isDecoded = true;
      });
    }
  }

  _showOrHidePass() {
    setState(() {
      _isObscured = !_isObscured;
    });
  }

  _copyPass(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: _decoded ?? 'failed'))
        .then((value) => _sb());
  }

  _sb() async {
    setState(() {
      _showSb = !_showSb;
    });
    await Future.delayed(Duration(milliseconds: 1000), () {
      setState(() {
        _showSb = !_showSb;
      });
    });
  }
}

class SecretKeyDialog extends StatelessWidget {
  const SecretKeyDialog({
    Key key,
    @required GlobalKey<FormState> secretKeyFormKey,
    @required TextEditingController secretKeyController,
    this.dw,
    this.dh,
  })  : _secretKeyFormKey = secretKeyFormKey,
        _secretKeyController = secretKeyController,
        super(key: key);
  final double dw;
  final double dh;
  final GlobalKey<FormState> _secretKeyFormKey;
  final TextEditingController _secretKeyController;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        contentPadding: EdgeInsets.zero,
        actionsPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(dh * 4),
        ),
        content: Form(
          key: _secretKeyFormKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DialogTitle(
                dh: dh,
                dw: dw,
                title: 'ENTER SECRET KEY',
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _secretKeyController,
                  obscureText: true,
                  validator: (text) => Utils.emptyOrNullStringValidator(text),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    suffixIcon: Icon(Icons.vpn_key),
                    hintText: 'secret key',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Make sure that this key is the same as entered during first adding this account',
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: dh * 2,
              ),
              GestureDetector(
                onTap: () {
                  if (_secretKeyFormKey.currentState.validate()) {
                    Navigator.of(context).pop(_secretKeyController.text);
                  }
                },
                child: Text(
                  'DONE',
                  style: TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(
                height: dh * 2,
              )
            ],
          ),
        ));
  }
}
