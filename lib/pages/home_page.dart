import 'package:bitirme_app/firebase_login/auth_service.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

const mBackgroundColor = Color(0xFFFAFAFA);
const mBlueColor = Color(0xFF2C53B1);
const mGreyColor = Color(0xFFB4B0B0);
const mTitleColor = Color(0xFF23374D);
const mSubtitleColor = Color(0xFF8E8E8E);
const mBorderColor = Color(0xFFE8E8F3);
const mFillColor = Color(0xFFFFFFFF);
const mCardTitleColor = Color(0xFF2E4ECF);
const mCardSubtitleColor = mTitleColor;

// Style for title
var mTitleStyle = GoogleFonts.inter(
    fontWeight: FontWeight.w600, color: mTitleColor, fontSize: 16);

// Style for Discount Section
var mMoreDiscountStyle = GoogleFonts.inter(
    fontSize: 12, fontWeight: FontWeight.w700, color: mBlueColor);

// Style for Service Section
var mServiceTitleStyle = GoogleFonts.inter(
    fontWeight: FontWeight.w500, fontSize: 14, color: mTitleColor);
var mServiceSubtitleStyle = GoogleFonts.inter(
    fontWeight: FontWeight.w400, fontSize: 10, color: mSubtitleColor);

// Style for Popular Destination Section
var mPopularDestinationTitleStyle = GoogleFonts.inter(
  fontWeight: FontWeight.w700,
  fontSize: 16,
  color: mCardTitleColor,
);
var mPopularDestinationSubtitleStyle = GoogleFonts.inter(
  fontWeight: FontWeight.w500,
  fontSize: 10,
  color: mCardSubtitleColor,
);

// Style for Travlog Section
var mTravlogTitleStyle = GoogleFonts.inter(
    fontSize: 14, fontWeight: FontWeight.w900, color: mFillColor);
var mTravlogContentStyle = GoogleFonts.inter(
    fontSize: 10, fontWeight: FontWeight.w500, color: mTitleColor);
var mTravlogPlaceStyle = GoogleFonts.inter(
    fontSize: 10, fontWeight: FontWeight.w500, color: mBlueColor);

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _current = 0;

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Setting up AppBar
      appBar: AppBar(
        backgroundColor: mBackgroundColor,
        title: SvgPicture.asset('assets/svg/appname.svg'),
        elevation: 0,
      ),

      // Setting up Background Color
      backgroundColor: mBackgroundColor,

      // Setting up Custom Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationTravelkuy(),

      // Body
      body: Container(
        child: ListView(
          physics: ClampingScrollPhysics(),
          children: <Widget>[
            // Promos Section
            Padding(
              padding: EdgeInsets.only(left: 16, bottom: 24),
              child: Text(
                'Merhaba, ${loggedInUser.username} 👋 Keyifli Kodlamalar!',
                style: mTitleStyle,
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(left: 16, right: 16),
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('slider')
                          .snapshots(),
                      builder: (context, snapshot) {
                        return snapshot.data == null
                            ? Container()
                            : Container(
                                width: MediaQuery.of(context).size.width,
                                height: 190,
                                child: Swiper(
                                  onIndexChanged: (index) {
                                    setState(() {
                                      _current = index;
                                    });
                                  },
                                  pagination: SwiperPagination(
                                      margin: EdgeInsets.only(top: 20),
                                      builder: DotSwiperPaginationBuilder(
                                          color: Color(0xFFA7A7A7),
                                          activeColor: Colors.white,
                                          activeSize: 10)),
                                  autoplay: true,
                                  layout: SwiperLayout.DEFAULT,
                                  itemCount: snapshot.data!.docs.length,
                                  itemBuilder: (BuildContext context, index) {
                                    final DocumentSnapshot map =
                                        snapshot.data!.docs[index];
                                    return Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        image: DecorationImage(
                                            image: NetworkImage(
                                              map['sliderImg'],
                                            ),
                                            fit: BoxFit.cover),
                                      ),
                                    );
                                  },
                                ),
                              );
                      }),
                  SizedBox(
                    height: 12,
                  ),
                ],
              ),
            ),

            // Service Section
            Padding(
              padding: EdgeInsets.only(left: 16, top: 24, bottom: 12),
              child: Text(
                'Haydi Başlayalım!',
                style: mTitleStyle,
              ),
            ),
            Container(
              height: 144,
              margin: EdgeInsets.only(left: 8, right: 8),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(right: 8),
                          padding: EdgeInsets.only(left: 8),
                          height: 64,
                          decoration: BoxDecoration(
                            color: mFillColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: mBorderColor, width: 1),
                          ),
                          child: Row(
                            children: <Widget>[
                              SvgPicture.asset(
                                'assets/svg/questions.svg',
                                fit: BoxFit.contain,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      'İstatistikler',
                                      style: mServiceTitleStyle,
                                    ),
                                    Text(
                                      'Sonuç ve istatistiklerim',
                                      style: mServiceSubtitleStyle,
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(left: 8),
                          padding: EdgeInsets.only(left: 8),
                          height: 64,
                          decoration: BoxDecoration(
                            color: mFillColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: mBorderColor, width: 1),
                          ),
                          child: Row(
                            children: <Widget>[
                              SvgPicture.asset(
                                'assets/svg/categorys.svg',
                                fit: BoxFit.contain,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      'Kategoriler',
                                      style: mServiceTitleStyle,
                                    ),
                                    Text(
                                      'Bütün diller',
                                      style: mServiceSubtitleStyle,
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(right: 8),
                          padding: EdgeInsets.only(left: 8),
                          height: 64,
                          decoration: BoxDecoration(
                            color: mFillColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: mBorderColor, width: 1),
                          ),
                          child: Row(
                            children: <Widget>[
                              SvgPicture.asset(
                                'assets/svg/events.svg',
                                fit: BoxFit.contain,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      'Etkinlikler',
                                      style: mServiceTitleStyle,
                                    ),
                                    Text(
                                      'Ödüllü etkinlikler',
                                      style: mServiceSubtitleStyle,
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(left: 8),
                          padding: EdgeInsets.only(left: 8),
                          height: 64,
                          decoration: BoxDecoration(
                            color: mFillColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: mBorderColor, width: 1),
                          ),
                          child: Row(
                            children: <Widget>[
                              SvgPicture.asset(
                                'assets/svg/gifts.svg',
                                fit: BoxFit.contain,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      'Hediyeler',
                                      style: mServiceTitleStyle,
                                    ),
                                    Text(
                                      'Kazandığın hediyeler',
                                      style: mServiceSubtitleStyle,
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),

            // Popular Destination Section
            Padding(
              padding: EdgeInsets.only(left: 16, top: 24, bottom: 12),
              child: Text(
                'Popüler Diller!',
                style: mTitleStyle,
              ),
            ),
            Container(
              height: 140,
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('quizkategorileri')
                      .limit(5)
                      .orderBy("sira", descending: false)
                      .snapshots(),
                  builder: (context, snapshot) {
                    return snapshot.data == null
                        ? Container()
                        : ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            padding: EdgeInsets.only(left: 16, right: 16),
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (BuildContext context, int index) {
                              final DocumentSnapshot map =
                                  snapshot.data!.docs[index];
                              return Card(
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Container(
                                  height: 140,
                                  width: 120,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                        color: mBorderColor, width: 1),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8.0, bottom: 16),
                                    child: Column(
                                      children: <Widget>[
                                        Image.network(
                                          map["v1CatImg"],
                                          height: 74,
                                        ),
                                        Text(
                                          map["categoryTitle"],
                                          style: mPopularDestinationTitleStyle,
                                        ),
                                        Text(
                                          map["categoryDesc"],
                                          style:
                                              mPopularDestinationSubtitleStyle,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                  }),
            ),

            // Travlog Section
            Padding(
              padding: EdgeInsets.only(left: 16, top: 24, bottom: 12),
              child: Text(
                'Travlogs!',
                style: mTitleStyle,
              ),
            ),
            Container(
              height: 181,
              child: ListView.builder(
                padding: EdgeInsets.only(left: 16),
                itemCount: travlogs.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(right: 16),
                    width: 220,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            Container(
                              height: 104,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                    image: AssetImage(travlogs[index].image),
                                    fit: BoxFit.cover),
                              ),
                            ),
                            Positioned(
                              child: SvgPicture.asset(
                                  'assets/svg/travlog_top_corner.svg'),
                              right: 0,
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: SvgPicture.asset(
                                  'assets/svg/travelkuy_logo_white.svg'),
                            ),
                            Positioned(
                              bottom: 0,
                              child: SvgPicture.asset(
                                  'assets/svg/travlog_bottom_gradient.svg'),
                            ),
                            Positioned(
                              bottom: 8,
                              left: 8,
                              child: Text(
                                'Travlog ' + travlogs[index].name,
                                style: mTravlogTitleStyle,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          travlogs[index].content,
                          maxLines: 3,
                          style: mTravlogContentStyle,
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          travlogs[index].place,
                          style: mTravlogPlaceStyle,
                        )
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CarouselModel {
  String image;

  CarouselModel(this.image);
}

List<CarouselModel> carousels = carouselsData
    .map((item) => CarouselModel(item['image'].toString()))
    .toList();

var carouselsData = [
  {"image": "assets/images/carousel_flight_discount.png"},
  {"image": "assets/images/carousel_hotel_discount.png"},
  {"image": "assets/images/carousel_covid_discount.png"},
];

class PopularDestinationModel {
  String name;
  String country;
  String image;

  PopularDestinationModel(this.name, this.country, this.image);
}

List<PopularDestinationModel> populars = popularsData
    .map((item) => PopularDestinationModel(item['name'].toString(),
        item['country'].toString(), item['image'].toString()))
    .toList();

var popularsData = [
  {
    "name": "Bali",
    "country": "Indonesia",
    "image": "assets/images/destination_bali.png"
  },
  {
    "name": "Paris",
    "country": "France",
    "image": "assets/images/destination_paris.png"
  },
  {
    "name": "Rome",
    "country": "Italy",
    "image": "assets/images/destination_rome.png"
  },
  {
    "name": "Bali",
    "country": "Indonesia",
    "image": "assets/images/destination_bali.png"
  },
  {
    "name": "Paris",
    "country": "France",
    "image": "assets/images/destination_paris.png"
  },
  {
    "name": "Rome",
    "country": "Italy",
    "image": "assets/images/destination_rome.png"
  },
];

class TravlogModel {
  String name;
  String content;
  String place;
  String image;

  TravlogModel(this.name, this.content, this.place, this.image);
}

List<TravlogModel> travlogs = travlogsData
    .map((item) => TravlogModel(
        item['name'].toString(),
        item['content'].toString(),
        item['place'].toString(),
        item['image'].toString()))
    .toList();

var travlogsData = [
  {
    "name": "\"Yogyakarta!\"",
    "content":
        "Halo guys, David di sini dengan Travelkuy!! di Yogyakarta!! Mengunjungi alamnya dan mencari tahu tempat jual gadget oke, hehe...",
    "place": "Yogyakarta, Indonesia",
    "image": "assets/images/travlog_yogyakarta.png"
  },
  {
    "name": "\"Tokyo!\"",
    "content":
        "Japan was such a dream and I worked really hard on this vlog, so I hope you enjoyed it! In this Travlog!",
    "place": "Tokyo, Japan",
    "image": "assets/images/travlog_tokyo.png"
  },
  {
    "name": "\"Yogyakarta!\"",
    "content":
        "Halo guys, David di sini dengan Travelkuy!! di Yogyakarta!! Mengunjungi alamnya dan mencari tahu tempat jual gadget oke, hehe...",
    "place": "Yogyakarta, Indonesia",
    "image": "assets/images/travlog_yogyakarta.png"
  },
  {
    "name": "\"Tokyo!\"",
    "content":
        "Japan was such a dream and I worked really hard on this vlog, so I hope you enjoyed it! In this Travlog!",
    "place": "Tokyo, Japan",
    "image": "assets/images/travlog_tokyo.png"
  },
  {
    "name": "\"Yogyakarta!\"",
    "content":
        "Halo guys, David di sini dengan Travelkuy!! di Yogyakarta!! Mengunjungi alamnya dan mencari tahu tempat jual gadget oke, hehe...",
    "place": "Yogyakarta, Indonesia",
    "image": "assets/images/travlog_yogyakarta.png"
  },
  {
    "name": "\"Tokyo!\"",
    "content":
        "Japan was such a dream and I worked really hard on this vlog, so I hope you enjoyed it! In this Travlog!",
    "place": "Tokyo, Japan",
    "image": "assets/images/travlog_tokyo.png"
  },
];

class BottomNavigationTravelkuy extends StatefulWidget {
  @override
  _BottomNavigationTravelkuyState createState() =>
      _BottomNavigationTravelkuyState();
}

class _BottomNavigationTravelkuyState extends State<BottomNavigationTravelkuy> {
  int _selectedIndex = 0;

  var bottomTextStyle =
      GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500);

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: mFillColor,
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 15,
              offset: Offset(0, 5))
        ],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: _selectedIndex == 0
                ? new SvgPicture.asset('assets/icons/home_colored.svg')
                : new SvgPicture.asset('assets/icons/home.svg'),
            label: 'Home',
          ),
          BottomNavigationBarItem(
              icon: _selectedIndex == 1
                  ? new SvgPicture.asset('assets/icons/order_colored.svg')
                  : new SvgPicture.asset('assets/icons/order.svg'),
              label: 'My Order'),
          BottomNavigationBarItem(
              icon: _selectedIndex == 2
                  ? new SvgPicture.asset('assets/icons/watch_colored.svg')
                  : new SvgPicture.asset('assets/icons/watch.svg'),
              label: 'Watch List'),
          BottomNavigationBarItem(
            icon: _selectedIndex == 3
                ? new SvgPicture.asset('assets/icons/account_colored.svg')
                : new SvgPicture.asset('assets/icons/account.svg'),
            label: 'Account',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: mBlueColor,
        unselectedItemColor: mSubtitleColor,
        onTap: _onItemTapped,
        backgroundColor: Colors.transparent,
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 12,
        showUnselectedLabels: true,
        elevation: 0,
      ),
    );
  }
}
