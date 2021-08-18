import 'package:ediary_flutter_web/model/user.dart';
import 'package:ediary_flutter_web/services/service.dart';
import 'package:flutter/material.dart';

class UpdateUserProfileDialog extends StatelessWidget {
  const UpdateUserProfileDialog({
    Key? key,
    required this.curUser,
    required TextEditingController avatarUrlTextController,
    required TextEditingController displayNameTextController,
  })  : _avatarUrlTextController = avatarUrlTextController,
        _displayNameTextController = displayNameTextController,
        super(key: key);

  final MUser curUser;
  final TextEditingController _avatarUrlTextController;
  final TextEditingController _displayNameTextController;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        width: MediaQuery.of(context).size.width * 0.40,
        height: MediaQuery.of(context).size.height * 0.40,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'Editing ${curUser.displayName}',
              style: Theme.of(context).textTheme.headline5,
            ),
            SizedBox(height: 30),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.50,
              child: Form(
                child: Column(
                  children: [
                    TextFormField(
                      controller: _avatarUrlTextController,
                    ),
                    TextFormField(
                      controller: _displayNameTextController,
                    ),
                    SizedBox(height: 20),
                    TextButton(
                      style: TextButton.styleFrom(
                        primary: Colors.white,
                        backgroundColor: Colors.green,
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                          side: BorderSide(color: Colors.green, width: 1),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 20,
                        ),
                        child: Text(
                          'Update',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      onPressed: () {
                        DiaryService().updateUser(
                          curUser,
                          _displayNameTextController.text,
                          _avatarUrlTextController.text,
                          context,
                        );
                        Future.delayed(
                          Duration(milliseconds: 200),
                        ).then(
                          (value) {
                            return Navigator.of(context).pop();
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
