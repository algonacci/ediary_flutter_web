import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ediary_flutter_web/model/Diary.dart';
import 'package:ediary_flutter_web/screens/main_page.dart';
import 'package:ediary_flutter_web/util/utils.dart';
import 'package:ediary_flutter_web/widgets/delete_entry_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DiaryListView extends StatelessWidget {
  const DiaryListView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CollectionReference bookCollectionReference =
        FirebaseFirestore.instance.collection('diaries');
    return StreamBuilder<QuerySnapshot>(
      stream: bookCollectionReference.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return LinearProgressIndicator();
        }
        var filteredList = snapshot.data!.docs.map((diary) {
          return Diary.fromDocument(diary);
        }).where((item) {
          return (item.userId == FirebaseAuth.instance.currentUser!.uid);
        }).toList();

        return Column(
          children: [
            Expanded(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.40,
                child: ListView.builder(
                  itemCount: filteredList.length,
                  itemBuilder: (context, index) {
                    Diary diary = filteredList[index];
                    return Card(
                      elevation: 4.0,
                      child: Column(
                        children: [
                          ListTile(
                            title: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${formatDateFromTimestamp(diary.entryTime)}',
                                    style: TextStyle(
                                      color: Colors.blueGrey,
                                      fontSize: 19,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextButton.icon(
                                      icon: Icon(Icons.delete_forever,
                                          color: Colors.grey),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return DeleteEntryDialog(
                                                bookCollectionReference:
                                                    bookCollectionReference,
                                                diary: diary);
                                          },
                                        );
                                      },
                                      label: Text(''))
                                ],
                              ),
                            ),
                            subtitle: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '•${formatDateFromTimestampHour(diary.entryTime)}',
                                      style: TextStyle(color: Colors.green),
                                    ),
                                    TextButton.icon(
                                      onPressed: () {},
                                      icon: Icon(Icons.more_horiz),
                                      label: Text(''),
                                    ),
                                  ],
                                ),
                                Image.network((diary.photoUrls == null)
                                    ? 'https://picsum.photos/400/200'
                                    : diary.photoUrls.toString()),
                                Row(
                                  children: [
                                    Flexible(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              diary.title!,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              diary.entry!,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.3,
                                          child: Row(
                                            children: [
                                              Text(
                                                '${formatDateFromTimestamp(diary.entryTime)}',
                                                style: TextStyle(
                                                  color: Colors.blueGrey,
                                                  fontSize: 19,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Spacer(),
                                              IconButton(
                                                icon: Icon(Icons.edit),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return Container();
                                                      // return UpdateEntryDialog()
                                                    },
                                                  );
                                                },
                                              ),
                                              IconButton(
                                                icon: Icon(Icons
                                                    .delete_forever_rounded),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return DeleteEntryDialog(
                                                          bookCollectionReference:
                                                              bookCollectionReference,
                                                          diary: diary);
                                                    },
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    content: ListTile(
                                      subtitle: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                '${formatDateFromTimestamp(diary.entryTime)}',
                                                style: TextStyle(
                                                  color: Colors.green,
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.6,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.50,
                                            child: Image.network(
                                              (diary.photoUrls == null)
                                                  ? 'https://picsum.photos/400/200'
                                                  : diary.photoUrls.toString(),
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Flexible(
                                                  child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(8),
                                                    child: Text(
                                                      '${diary.title}',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(8),
                                                    child: Text(
                                                      '${diary.entry}',
                                                      style: TextStyle(),
                                                    ),
                                                  ),
                                                ],
                                              ))
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                        child: Text('Cancel'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
