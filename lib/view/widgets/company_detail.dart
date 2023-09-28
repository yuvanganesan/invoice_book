import 'package:flutter/material.dart';

class CompanyDetail extends StatelessWidget {
  const CompanyDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: 15.0, right: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Zam Zam Mobiles',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  )),
              SizedBox(
                height: 2,
              ),
              Text('Mukkuchalai-Peraiyur',
                  style: TextStyle(
                    fontSize: 15,
                  )),
              SizedBox(
                height: 2,
              ),
              Text('Samsukani',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  )),
              SizedBox(
                height: 2,
              ),
              Row(
                children: [
                  Text('Phone: ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      )),
                  Text('+916383932022',
                      style: TextStyle(
                        fontSize: 15,
                      )),
                ],
              )
            ],
          ),
          //company logo
        ],
      ),
    );
  }
}
