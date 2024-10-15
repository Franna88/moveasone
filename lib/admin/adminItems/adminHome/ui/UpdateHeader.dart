import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:move_as_one/myutility.dart';
import '../adminHomeItems/writeAMessage.dart';

class UpdateHeader extends StatefulWidget {
  const UpdateHeader({super.key});

  @override
  State<UpdateHeader> createState() => _UpdateHeaderState();
}

class _UpdateHeaderState extends State<UpdateHeader> {
  Map<String, dynamic> _headerData = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchHeaderData();
  }

  Future<void> _fetchHeaderData() async {
    try {
      DocumentSnapshot headerSnapshot = await FirebaseFirestore.instance
          .collection('updateHeader')
          .doc('headerInfo')
          .get();

      if (headerSnapshot.exists) {
        setState(() {
          _headerData = headerSnapshot.data() as Map<String, dynamic>;
          _isLoading = false;
        });
        print('Fetched header data: $_headerData'); // Debug print
      } else {
        setState(() {
          _isLoading = false;
        });
        print('No header data found'); // Debug print
      }
    } catch (e) {
      print('Error fetching header data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : Container(
            width: MyUtility(context).width,
            height: MyUtility(context).height / 1.8,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(_headerData['imageUrl']),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: MyUtility(context).height * 0.21,
                ),
                SizedBox(
                  width: MyUtility(context).width / 1.15,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      _headerData['headerText'] ?? '',
                      style: TextStyle(
                        color: Color(0xFF006261),
                        fontSize: 44,
                        fontFamily: 'belight',
                        height: 0.0,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 25),
                  child: SizedBox(
                    width: MyUtility(context).width / 1.15,
                    child: Text(
                      _headerData['subtitleText'] ?? '',
                      style: TextStyle(
                        color: /*Color(0xA5006261)*/
                            Color.fromARGB(255, 116, 235, 217),
                        fontSize: 16,
                        fontFamily: 'Be Vietnam',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: MyUtility(context).width / 1.15,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WriteAMessage(),
                          ),
                        );
                      },
                      child: Container(
                        width: MyUtility(context).width * 0.5,
                        height: MyUtility(context).height * 0.05,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        decoration: ShapeDecoration(
                          color: Color(0xFF006261),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Update App Header',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontFamily: 'belight',
                                height: 0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
  }
}
