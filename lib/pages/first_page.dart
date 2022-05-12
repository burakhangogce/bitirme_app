import 'package:bitirme_app/model/auth_service.dart';
import 'package:bitirme_app/pages/home_page.dart';
import 'package:bitirme_app/pages/organization/home_organization.dart';
import 'package:bitirme_app/pages/edit_photo.dart';
import 'package:bitirme_app/pages/profile_page.dart';
import 'package:bitirme_app/widgets/org_all_chat.dart';
import 'package:bitirme_app/widgets/user_all_chat.dart';
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
    fontSize: 13, fontWeight: FontWeight.w700, color: mFillColor);
var mTravlogContentStyle = GoogleFonts.inter(
    fontSize: 10, fontWeight: FontWeight.w500, color: mTitleColor);
var mTravlogPlaceStyle = GoogleFonts.inter(
    fontSize: 10, fontWeight: FontWeight.w500, color: mBlueColor);

class HomeScreen extends StatefulWidget {
  final int page;

  const HomeScreen({
    Key? key,
    required this.page,
  }) : super(key: key);
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
  int _page = 0;
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
    _page = widget.page;
  }

  Widget bodyFunction() {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    switch (_page) {
      case 0:
        return loggedInUser.userType == "organization"
            ? OrganizationHome()
            : FirstPage();
        break;
      case 1:
        return loggedInUser.userType == "organization"
            ? OrgAllChats()
            : UserAllChats();
        break;
      case 2:
        return Container();
        break;
      case 3:
        return MyProfile();
        break;
    }
    return Container(
      child: Text(
        "burak22222",
        style: TextStyle(color: Colors.black, fontSize: 25),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Setting up AppBar
      appBar: AppBar(
        backgroundColor: mBackgroundColor,
        title: SvgPicture.asset('assets/svg/appname.svg'),
        elevation: 0,
        toolbarHeight: _page != 0 ? 0 : 50,
      ),

      // Setting up Background Color
      backgroundColor: Colors.white,

      // Setting up Custom Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: _page == 0
                ? new SvgPicture.asset('assets/icons/home_colored.svg')
                : new SvgPicture.asset('assets/icons/home.svg'),
            label: 'Ana Sayfa',
          ),
          BottomNavigationBarItem(
              icon: _page == 1
                  ? new SvgPicture.asset('assets/icons/order_colored.svg')
                  : new SvgPicture.asset('assets/icons/order.svg'),
              label: 'Sohbet'),
          BottomNavigationBarItem(
              icon: _page == 2
                  ? new SvgPicture.asset('assets/icons/watch_colored.svg')
                  : new SvgPicture.asset('assets/icons/watch.svg'),
              label: 'Watch List'),
          BottomNavigationBarItem(
            icon: _page == 3
                ? new SvgPicture.asset('assets/icons/account_colored.svg')
                : new SvgPicture.asset('assets/icons/account.svg'),
            label: 'Profil',
          ),
        ],
        currentIndex: _page,
        selectedItemColor: mBlueColor,
        unselectedItemColor: mSubtitleColor,
        onTap: (index) => setState(() => _page = index),
        backgroundColor: Colors.transparent,
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 12,
        showUnselectedLabels: true,
        elevation: 0,
      ),
      body: bodyFunction(),
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
            label: 'Ana Sayfa',
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
