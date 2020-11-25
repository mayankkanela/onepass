import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onepass/models/account.dart';
import 'package:onepass/providers/user_provider.dart';
import 'package:onepass/screens/passwords/list_item_account.dart';
import 'package:onepass/utils/utility.dart' as Utils;
import 'package:onepass/widget/dialog_title.dart';
import 'package:provider/provider.dart';

import 'bottom_sheet_decrypt.dart';

class Passwords extends StatefulWidget {
  @override
  _PasswordsState createState() => _PasswordsState();
}

class _PasswordsState extends State<Passwords> {
  final TextEditingController _searchBar = new TextEditingController();
  final GlobalKey<FormState> _addAccountFormKey = new GlobalKey<FormState>();
  final GlobalKey<FormState> _secretKeyFormKey = new GlobalKey<FormState>();

  bool _searchMode = false;

  @override
  void initState() {
    _fetchAccounts();
    super.initState();
  }

  @override
  void dispose() {
    _searchBar.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double dw = Utils.displayWidth(context) / 100;
    double dh = Utils.displayHeight(context) / 100;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildAppBar(dw, dh),
        body: _buildBody(dw, dh),
        floatingActionButton: _buildFloatingActionButton(dw, dh),
      ),
    );
  }

  AppBar _buildAppBar(double dw, double dh) {
    return AppBar(
      toolbarHeight: kToolbarHeight + dh * 5,
      elevation: 0,
      backgroundColor: Colors.white,
      title: Container(
        margin: EdgeInsets.symmetric(vertical: dh * 1),
        padding: EdgeInsets.symmetric(vertical: dh * 1, horizontal: dw * 2),
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              const Color(0xffe6e6e6),
              Colors.white,
            ], begin: Alignment(-5, -5), end: Alignment(1, 1)),
            borderRadius: BorderRadius.circular(dh * 1),
            boxShadow: [
              BoxShadow(
                  color: Color(0xffd9d9d9),
                  offset: Offset(dh * 1, dh * 1),
                  blurRadius: dh * 0.5),
              BoxShadow(
                  color: Colors.white,
                  offset: Offset(dh * -1, dh * -1),
                  blurRadius: dh * 0.5),
            ]),
        child: Row(
          children: [
            _buildSearchBar(kToolbarHeight / 100, dw),
          ],
        ),
      ),
    );
  }

  Expanded _buildSearchBar(double dh, double dw) {
    return Expanded(
      child: TextFormField(
        controller: _searchBar,
        onChanged: (text) {
          if (text.length > 2)
            setState(() {
              _searchMode = true;
            });
          else
            setState(() {
              _searchMode = false;
            });
        },
        autofocus: false,
        showCursor: _searchBar.text.length > 0 ? true : false,
        style: TextStyle(fontSize: dh * 35),
        decoration: InputDecoration(
          hintText: 'Search',
          contentPadding: EdgeInsets.only(left: dw * 5),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.grey,
          ),
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(dh * 60),
              borderSide: BorderSide(color: Colors.blue)),
        ),
      ),
    );
  }

  Widget _buildBody(double dw, double dh) {
    return Consumer<UserProvider>(
        builder: (context, userProvider, child) =>
            userProvider.accounts.length > 0
                ? Container(
                    margin: EdgeInsets.only(top: dh * 2),
                    child: _buildListView(userProvider.accounts, dw, dh))
                : Center(
                    child: Text('No accounts added'),
                  ));
  }

  ListView _buildListView(List<Account> accounts, double dw, double dh) {
    return ListView.builder(
        itemCount: accounts.length,
        itemBuilder: (BuildContext _, int index) {
          final account = accounts[index];
          return _searchMode
              ? (account.nickName
                          .toUpperCase()
                          .contains(_searchBar.text.toUpperCase()) ||
                      _searchBar.text
                          .toUpperCase()
                          .contains(account.nickName.toUpperCase()))
                  ? ListItemAccount(account, dw, dh, _decryptBottomSheet)
                  : SizedBox(
                      height: 0,
                    )
              : ListItemAccount(account, dw, dh, _decryptBottomSheet);
        });
  }

  FloatingActionButton _buildFloatingActionButton(double dw, double dh) {
    return FloatingActionButton(
      backgroundColor: Colors.white,
      elevation: dh * 0.5,
      onPressed: () => _addAccountDialog(dw, dh),
      child: Icon(
        Icons.add,
        color: Colors.blue,
      ),
    );
  }

  _addAccountDialog(double dw, double dh) async {
    final _accountNameController = new TextEditingController();
    final _accountPasswordController = new TextEditingController();
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: EdgeInsets.zero,
            actionsPadding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(dh * 4),
            ),
            content: Form(
              key: _addAccountFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DialogTitle(
                    dw: dw,
                    dh: dh,
                    title: 'ADD A NEW ACCOUNT',
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _accountNameController,
                      textInputAction: TextInputAction.next,
                      validator: (text) =>
                          Utils.emptyOrNullStringValidator(text),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                          hintText: 'nickname (ex: main account)'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _accountPasswordController,
                      obscureText: true,
                      validator: (text) =>
                          Utils.emptyOrNullStringValidator(text),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        hintText: 'password',
                      ),
                    ),
                  ),
                  SizedBox(
                    height: dh * 2,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Text(
                          'BACK',
                          style: TextStyle(
                              color: Colors.grey, fontWeight: FontWeight.w600),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _secretKeyDialog(
                            _accountNameController.text,
                            _accountPasswordController.text,
                            dw,
                            dh),
                        child: Text(
                          'ADD',
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: dh * 2,
                  )
                ],
              ),
            ),
          );
        });
  }

  Future<void> _fetchAccounts() async {
    await Provider.of<UserProvider>(context, listen: false).getAccounts();
  }

  _secretKeyDialog(String name, String password, double dw, double dh) async {
    if (_addAccountFormKey.currentState.validate()) {
      final TextEditingController _keyController = new TextEditingController();
      Navigator.of(context).pop();
      await showDialog(
          context: context,
          builder: (BuildContext _) {
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
                          controller: _keyController,
                          obscureText: true,
                          validator: (text) =>
                              Utils.emptyOrNullStringValidator(text),
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
                          'Always remember your secret key as it is not stored anywhere,'
                          'this key will be used to decrypt your password so try to use same '
                          'key all time.',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        height: dh * 2,
                      ),
                      GestureDetector(
                        onTap: () =>
                            _addAccount(name, password, _keyController),
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
          });
    }
  }

  _addAccount(
      String name, String password, TextEditingController keyController) async {
    if (_secretKeyFormKey.currentState.validate()) {
      final hash = Utils.encrypt(password, keyController.text);
      debugPrint(Utils.decrypt(hash.base64, keyController.text));
      final Account account = new Account(hash: hash.base64, nickName: name);
      bool res = await Provider.of<UserProvider>(context, listen: false)
          .addAccount(account.toJson(account));
      Navigator.of(context).pop();
    }
  }

  _decryptBottomSheet(Account account, double dw, double dh) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(dh * 4),
                topRight: Radius.circular(dh * 4))),
        builder: (BuildContext _) {
          return BottomSheetDecrypt(
            dh: dh,
            dw: dw,
            account: account,
          );
        });
  }
}
