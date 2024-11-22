
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
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
                    child: IconButton(
                      hoverColor: Colors.white,
                      highlightColor: Colors.white,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                    ),
                  ),
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
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                        child: Text(
                          "Unclaimed",
                          style: TextStyle(
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
                    const Row(
                      children: [
                        Icon(
                          Icons.av_timer,
                          size: 16,
                          color: Color.fromARGB(1000, 48, 38, 29),
                        ),
                        Text(
                          'December 25th, 2024 at 7:00AM',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(1000, 48, 38, 29),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF451B0A),
                        foregroundColor: Colors.white,
                        shadowColor: Colors.transparent,
                        minimumSize: const Size(double.infinity, 50), // Set width to double.infinity
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: const Text('Chat with Finder'),
                    )
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
