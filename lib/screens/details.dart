
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import 'package:carousel_slider/carousel_slider.dart';

final supabase = Supabase.instance.client;

class Details extends StatelessWidget {
  final Map<String, dynamic> item;

  const Details({
    super.key,
    required this.item
  });


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  CarouselSlider(
                    options: CarouselOptions(
                      height: 400.0,
                      enableInfiniteScroll: false,
                      viewportFraction: 0.9,
                    ),
                    items: item['images'].map<Widget>((i) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            margin: const EdgeInsets.symmetric(horizontal: 5.0),
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(190, 242, 242, 242)
                            ),
                            child: Image.network(
                              i['image_url'],
                              width: double.infinity,
                              fit: BoxFit.fitWidth,
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      decoration: const BoxDecoration(
                        color:  Color(0xFF451B0A),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        hoverColor: Colors.white,
                        highlightColor: Colors.white,
                        color: Colors.white,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const FaIcon(
                          FontAwesomeIcons.arrowLeft,
                          size: 20,),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['name'],
                      style: const TextStyle(
                        fontSize: 20,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(1000, 48, 38, 29),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: const Color(0xFF451B0A).withOpacity(.70),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                        child: Text(
                          item['claimed'] != null && item['claimed'] ? "Claimed" : "Unclaimed",
                          style: const TextStyle(
                            fontSize: 13,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w300,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      item['description'],
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        color: Color.fromARGB(1000, 48, 38, 29),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Divider(),
                    const Text(
                      'Location Found',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w300,
                        color: Color.fromARGB(1000, 48, 38, 29),
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 16,
                          color: Color.fromARGB(1000, 48, 38, 29),
                        ),
                        Text(
                          item['location'],
                          style: const TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(1000, 48, 38, 29),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Last Found',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w300,
                        color: Color.fromARGB(1000, 48, 38, 29),
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.av_timer,
                          size: 16,
                          color: Color.fromARGB(1000, 48, 38, 29),
                        ),
                        Text(
                          DateFormat('MMMM dd, yyyy – kk:mm').format(DateTime.parse(item['date_reported'])),
                          style: const TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(1000, 48, 38, 29),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
