import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Notifications extends StatelessWidget {
  final currentFCMToken; // Assuming you pass the current FCM token to this widget

  Notifications({this.currentFCMToken});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 2, 129, 55),
        title: Text(
          "Notifications",
          style: TextStyle(color: Colors.white),
        ),
        leading: Icon(
          Icons.arrow_back_ios_new_sharp,
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('notificationList')
                    .where('androidNotificationToken',
                        isEqualTo: currentFCMToken)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return DataTable(
                    columns: [
                      DataColumn(
                        label: SizedBox(
                          width: 200, // Adjust width as needed
                          child: Text('Date'),
                        ),
                      ),
                      DataColumn(
                        label: SizedBox(
                          width: 100, // Adjust width as needed
                          child: Text('Time'),
                        ),
                      ),
                      // DataColumn(
                      //   label: SizedBox(
                      //     width: 100, // Adjust width as needed
                      //     child: Text('lengthOn'),
                      //   ),
                      // ),
                    ],
                    rows: _buildRows(snapshot.data!.docs),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<DataRow> _buildRows(List<DocumentSnapshot> snapshot) {
    List<DataRow> rows = [];
    snapshot.forEach((document) {
      Map<String, dynamic> data =
          document.data() as Map<String, dynamic>; // Explicit cast
      String date = data['date'] as String; // Explicit cast
      String time = data['time'] as String;
      // String lengthOn = data['lengthOn'] as String; // Explicit cast
      rows.add(DataRow(
        cells: [
          DataCell(Text(date)),
          DataCell(Text(time)),
          // DataCell(Text(lengthOn)),
        ],
      ));
    });
    return rows;
  }
}
