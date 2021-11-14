import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:shopizy/ui/theme/app_colors.dart';
import 'package:shopizy/ui/theme/app_shapes.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.grey),
        elevation: 0,
        title: Text(FlutterI18n.translate(context, 'contactus'), style: TextStyle(color: Colors.black)),
      ),
      body: ListView(
        padding: EdgeInsets.all(8),
        children: [
          Container(
            decoration: AppShapes.roundedRectDecoration(radius: 12),
            padding: EdgeInsets.all(12),
            child: Column(
              children: [
                Container(
                  decoration: AppShapes.roundedRectDecoration(radius: 12, borderColor: AppColors.PRIMARY_COLOR),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset('assets/images/top_image.jpg'),
                  ),
                ),
                SizedBox(height: 12),
                phone(context),
                SizedBox(height: 20),
                whatsapp(context),
                SizedBox(height: 8),
                viber(context),
                SizedBox(height: 8),
                email(context),
              ],
            ),
          ),
          SizedBox(height: 12),
          Container(
            decoration: AppShapes.roundedRectDecoration(radius: 12),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  FlutterI18n.translate(context, 'followus'),
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Spacer(),
                    socialMedia('assets/images/instagram.png', 'https://www.instagram.com/shopizi.co'),
                    SizedBox(width: 10),
                    Spacer(),
                    socialMedia('assets/images/facebook.png', 'https://www.facebook.com/shopizi.co'),
                    SizedBox(width: 10),
                    Spacer(),
                    socialMedia('assets/images/snapchat.png', 'https://www.snapchat.com/add/shopizi.co'),
                    SizedBox(width: 10),
                    Spacer(),
                    socialMedia(
                        'assets/images/tiktok.png', 'https://www.tiktok.com/@shopizi.co?lang=tr-TR&is_copy_url=1&is_from_webapp=v1'),
                    Spacer(),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Container phone(BuildContext ctx) {
    return Container(
      height: 90,
      decoration: AppShapes.roundedRectDecoration(radius: 12, borderColor: Colors.grey[300]),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: 70,
            child: Icon(Icons.phone, size: 30, color: Colors.white),
            decoration: BoxDecoration(
                color: AppColors.PRIMARY_COLOR,
                borderRadius: BorderRadiusDirectional.only(topStart: Radius.circular(12), bottomStart: Radius.circular(12))),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Container(
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                FlutterI18n.translate(ctx, 'phonenumbers'),
                style: TextStyle(fontSize: 20, color: AppColors.PRIMARY_COLOR, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(width: 12),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () async =>
                    await canLaunch('tel:+9647514447474') ? await launch('tel:+9647514447474') : throw 'Could not launch',
                child: Text(
                  '0751 444 7474',
                  textDirection: TextDirection.ltr,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey),
                ),
              ),
              SizedBox(height: 4),
              GestureDetector(
                onTap: () async =>
                    await canLaunch('tel:+9647734447474') ? await launch('tel:+9647734447474') : throw 'Could not launch',
                child: Text(
                  '0773 444 7474',
                  textDirection: TextDirection.ltr,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey),
                ),
              ),
            ],
          ),
          SizedBox(width: 12),
        ],
      ),
    );
  }

  Container whatsapp(BuildContext ctx) {
    return Container(
      height: 75,
      decoration: AppShapes.roundedRectDecoration(radius: 12, borderColor: Colors.grey[300]),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: 70,
            alignment: Alignment.center,
            child: Image.asset(
              'assets/images/whatsapp.png',
              width: 35,
            ),
            decoration: BoxDecoration(
                color: Color(0xff00E676),
                borderRadius: BorderRadiusDirectional.only(topStart: Radius.circular(12), bottomStart: Radius.circular(12))),
          ),
          SizedBox(width: 12),
          Center(
            child: Text(
              'Whatsapp',
              style: TextStyle(fontSize: 20, color: Color(0xff00E676), fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(width: 12),
          Spacer(),
          TextButton(
            onPressed: () async {
              await canLaunch('https://wa.me/9647514447474') ? await launch('https://wa.me/9647514447474') : throw 'Could not launch';
            },
            child: Text(FlutterI18n.translate(ctx, 'open'),
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xff00E676))),
          ),
          SizedBox(width: 12),
        ],
      ),
    );
  }

  Container viber(BuildContext ctx) {
    return Container(
      height: 75,
      decoration: AppShapes.roundedRectDecoration(radius: 12, borderColor: Colors.grey[300]),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: 70,
            alignment: Alignment.center,
            child: Image.asset(
              'assets/images/viber.png',
              width: 35,
            ),
            decoration: BoxDecoration(
                color: Color(0xff8074D6),
                borderRadius: BorderRadiusDirectional.only(topStart: Radius.circular(12), bottomStart: Radius.circular(12))),
          ),
          SizedBox(width: 12),
          Center(
            child: Text(
              'Viber',
              style: TextStyle(fontSize: 20, color: Color(0xff8074D6), fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(width: 12),
          Spacer(),
          TextButton(
            onPressed: () async {
              await canLaunch('viber://chat?number=9647514447474')
                  ? await launch('viber://chat?number=9647514447474')
                  : throw 'Could not launch';
            },
            child: Text(FlutterI18n.translate(ctx, 'open'),
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xff8074D6))),
          ),
          SizedBox(width: 12),
        ],
      ),
    );
  }

  Container email(BuildContext ctx) {
    return Container(
      height: 75,
      decoration: AppShapes.roundedRectDecoration(radius: 12, borderColor: Colors.grey[300]),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: 70,
            alignment: Alignment.center,
            child: Image.asset(
              'assets/images/mail.png',
              width: 35,
            ),
            decoration: BoxDecoration(
                color: Color(0xff00C2FF),
                borderRadius: BorderRadiusDirectional.only(topStart: Radius.circular(12), bottomStart: Radius.circular(12))),
          ),
          SizedBox(width: 12),
          Center(
            child: Text(
              FlutterI18n.translate(ctx, 'email'),
              style: TextStyle(fontSize: 20, color: Color(0xff00C2FF), fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(width: 12),
          Spacer(),
          TextButton(
            onPressed: () async {
              await canLaunch('mailto:info@shopizi.co') ? await launch('mailto:info@shopizi.co') : throw 'Could not launch';
            },
            child: Text(FlutterI18n.translate(ctx, 'info@shopizi.co'),
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xff00C2FF))),
          ),
          SizedBox(width: 12),
        ],
      ),
    );
  }

  socialMedia(String iconPath, String link) => GestureDetector(
        onTap: () async => await canLaunch(link) ? await launch(link) : throw 'Could not launch',
        child: Image.asset(iconPath, width: 45),
      );
}
