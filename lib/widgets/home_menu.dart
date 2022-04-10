import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../pages/first_page.dart';

class HomeMenu extends StatefulWidget {
  const HomeMenu({Key? key}) : super(key: key);

  @override
  State<HomeMenu> createState() => _HomeMenuState();
}

class _HomeMenuState extends State<HomeMenu> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 8, right: 8),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(right: 8),
                padding: EdgeInsets.only(left: 8),
                height: 64,
                width: MediaQuery.of(context).size.width * 0.45,
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
              Container(
                margin: EdgeInsets.only(left: 8),
                padding: EdgeInsets.only(left: 8),
                height: 64,
                width: MediaQuery.of(context).size.width * 0.45,
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
              )
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.45,
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
              Container(
                width: MediaQuery.of(context).size.width * 0.45,
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
              )
            ],
          ),
        ],
      ),
    );
  }
}
