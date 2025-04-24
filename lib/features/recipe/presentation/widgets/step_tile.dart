import 'package:flutter/material.dart';

class StepTile extends StatelessWidget {
  final data;
  StepTile({
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: NeverScrollableScrollPhysics(),
      itemCount: data.length,
      itemBuilder: (context, index) => Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(color: Colors.grey.shade300, width: 1))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          textDirection: TextDirection.rtl,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            (data != null)
                ? Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Text(
                      textDirection: TextDirection.rtl,
                      data[index],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'inter',
                        color: Colors.grey[600],
                        height: 150 / 100,
                      ),
                    ),
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
