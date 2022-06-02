import 'package:flutter/material.dart';

class LoadingShortPage extends StatelessWidget {
  const LoadingShortPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/shortLoading.png"),
                fit: BoxFit.cover),
          ),
        ),
        Positioned(
          bottom: 0,
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 30),
            width: MediaQuery.of(context).size.width,
            height: 200,
            color: Colors.black.withOpacity(0.1),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 300,
                    height: 25,
                    color: Colors.grey[400],
                  ),
                  Container(
                    height: 25,
                    width: 25,
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      shape: BoxShape.circle,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                width: 250,
                height: 25,
                color: Colors.grey[400],
              ),
              const SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 18,
                    width: 130,
                    color: Colors.grey[400],
                  ),
                  Container(height: 18, width: 130, color: Colors.grey[400]),
                  const SizedBox(width: 35,)
                ],
              )
            ]),
          ),
        ),
      ],
    );
  }
}
