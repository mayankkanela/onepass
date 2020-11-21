import 'package:flutter/material.dart';
import 'package:onepass/providers/user_provider.dart';
import 'package:onepass/utils/utility.dart' as Utils;
import 'package:onepass/widget/dialog_title.dart';
import 'package:provider/provider.dart';

class Passwords extends StatefulWidget {
  @override
  _PasswordsState createState() => _PasswordsState();
}

class _PasswordsState extends State<Passwords> {
  final TextEditingController _searchBar = new TextEditingController();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
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
        appBar: _buildAppBar(dw, dh),
        body: _buildBody(dw, dh),
        floatingActionButton: _buildFloatingActionButton(dw, dh),
      ),
    );
  }

  AppBar _buildAppBar(double dw, double dh) {
    return AppBar(
      title: Row(
        children: [
          _buildSearchBar(kToolbarHeight / 100, dw),
          Icon(
            Icons.account_circle,
            size: kToolbarHeight / 2,
          )
        ],
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
            userProvider.accounts.isNotEmpty
                ? Container()
                : Center(
                    child: Text('No accounts added'),
                  ));
  }

  FloatingActionButton _buildFloatingActionButton(double dw, double dh) {
    return FloatingActionButton(
      onPressed: () => _addAccountDialog(dw, dh),
      child: Icon(Icons.add),
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
              key: _formKey,
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

  void _fetchAccounts() {}

  _secretKeyDialog(String name, String password, double dh, double dw) async {
    if (_formKey.currentState.validate()) {
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
              content: Container(
                width: 10,
                height: 10,
              ),
            );
          });
    }
  }
}
