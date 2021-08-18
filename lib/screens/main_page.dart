import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ediary_flutter_web/model/Diary.dart';
import 'package:ediary_flutter_web/model/user.dart';
import 'package:ediary_flutter_web/widgets/create_profile.dart';
import 'package:ediary_flutter_web/widgets/diary_list_view.dart';
import 'package:ediary_flutter_web/widgets/write_diary_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String? _dropDownText;
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final _titleTextController = TextEditingController();
    final _descriptionTextController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade100,
        toolbarHeight: 100,
        elevation: 4,
        title: Row(
          children: [
            Text(
              'e',
              style: TextStyle(fontSize: 39, color: Colors.grey.shade400),
            ),
            Text(
              'Diary',
              style: TextStyle(fontSize: 39, color: Colors.green),
            ),
          ],
        ),
        actions: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButton<String>(
                  items: <String>['Latest', 'Earliest'].map(
                    (String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(color: Colors.grey),
                        ),
                      );
                    },
                  ).toList(),
                  hint: (_dropDownText == null)
                      ? Text('Select')
                      : Text(_dropDownText!),
                  onChanged: (value) {
                    if (value == 'Latest') {
                      setState(() {
                        _dropDownText = value;
                      });
                    } else if (value == 'Earliest') {
                      setState(() {
                        _dropDownText = value;
                      });
                    }
                  },
                ),
              ),
              // TODO: Create Profile
              StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection('users').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  final usersListStream = snapshot.data!.docs.map((docs) {
                    return MUser.fromDocument(docs);
                  }).where((muser) {
                    return (muser.uid ==
                        FirebaseAuth.instance.currentUser!.uid);
                  }).toList();
                  print(usersListStream.length);

                  MUser curUser = usersListStream[0];

                  return CreateProfile(curUser: curUser);
                },
              ),
            ],
          ),
        ],
      ),
      body: Row(
        children: [
          Expanded(
            flex: 4,
            child: Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                border: Border(
                  right: BorderSide(width: 0.4, color: Colors.blueGrey),
                ),
              ),
              // color: Colors.green,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(38.0),
                    child: SfDateRangePicker(
                      onSelectionChanged: (dateRangePickerSelection) {
                        setState(() {
                          selectedDate = dateRangePickerSelection.value;
                        });
                        // print(dateRangePickerSelection.value.toString());
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(48.0),
                    child: Card(
                      elevation: 4,
                      child: TextButton.icon(
                        icon: Icon(
                          Icons.add,
                          size: 40,
                          color: Colors.greenAccent,
                        ),
                        label: Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Write New',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return WriteDiaryDialog(
                                selectedDate: selectedDate,
                                titleTextController: _titleTextController,
                                descriptionTextController:
                                    _descriptionTextController,
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 10,
            child: DiaryListView(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Add New',
        child: Icon(Icons.add),
      ),
    );
  }
}
