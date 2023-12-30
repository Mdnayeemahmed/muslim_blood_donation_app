import 'package:flutter/material.dart';
import '../../constant/text_style.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({super.key});

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 7,
                ),
                SizedBox(
                  height: 100, // Adjust the height of the logo container
                  child: Stack(
                    children: [
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: ColorFiltered(
                          colorFilter: ColorFilter.mode(
                            Colors.white.withOpacity(0.7),
                            // Adjust the opacity as needed
                            BlendMode.dstATop,
                          ),
                          child: Image.asset(
                            "assets/logo/logo.png",
                            fit: BoxFit.contain,
                            height: 100, // Adjust the height of the logo
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  'নাম',
                  style: TextStyles.style16BoldBangla(Colors.black),
                ),
                const Divider(),
                Text(
                  "Muslim Blood Donor Bangladesh-MBDB(মুসলিম ব্লাড ডোনার বাংলাদেশ)",
                  style: TextStyles.style15Bangla(Colors.black),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  'লক্ষ্য',
                  style: TextStyles.style16BoldBangla(Colors.black),
                ),
                const Divider(),
                Text(
                  "রক্তদান কর্মসূচি বাস্তবায়নের মাধ্যমে আল্লাহর সন্তুষ্টি এবং আখিরাতে উত্তম প্রতিদান লাভ।",
                  style: TextStyles.style15Bangla(Colors.black),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  'বৈশিষ্ট্য:',
                  style: TextStyles.style16BoldBangla(Colors.black),
                ),
                const Divider(),
                Text(
                  "১.MBDB অলাভজনক,অরাজনৈতিক ও পূর্ণ মানবসেবায় নিবেদিত আখিরাতমুখী প্রতিষ্ঠান।\n"
                  "২.সংস্থাটি পরিচালিত হয় একটি সক্রিয় পরিচালনা পরিষদ এবং শরিয়াহ বোর্ড এর মাধ্যমে।\n"
                  "৩.যেকোনো নীতি গ্রহণ-বর্জন-পরিমার্জনের ক্ষেত্রে পরিচালনা পরিষদ সম্মিলিত ভাবে সিদ্ধান্ত নিয়ে থাকেন।\n"
                  "৪.MBDB কোনো গতানুগতিক ধারার প্রতিষ্ঠান নয়।এর মূল কাজ দেশের ইসলামি ভাবধারার,অরাজনৈতিক প্রতিষ্ঠানগুলোকে একটি প্লাটফর্মে এনে রক্তদান কর্মসূচির গতিকে সুসংগঠিত, শক্তিশালী করা।\n"
                  "৫.MBDB একটি স্বাধীন,অরাজনৈতিক সংস্থা।দেশের রাজনৈতিক কোনো বিষয়ে এই সংস্থা কখনোই সাহায্য বা হস্তক্ষেপ করবে না।\n"
                  "৬.MBDB নিরাপদ,রোগমুক্ত রক্তদানের বিষয়ে সর্বোচ্চ সতর্কতা অবলম্বন করে।",
                  style: TextStyles.style15Bangla(Colors.black),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  'কার্যপদ্ধতি:',
                  style: TextStyles.style16BoldBangla(Colors.black),
                ),
                const Divider(),
                Text(
                  '১.MBDB এর রয়েছে নিজস্ব ফেইসবুক পেইজ এবং মোবাইল এপ। যার মাধ্যমে নির্দিষ্ট ফরম্যাটে যে কেও রক্তের আবেদন করতে পারবেন এবং ডোনার রেজিস্ট্রেশন করতে পারবেন।\n'
                  "২.কমপক্ষে ১৫-২০ ঘন্টা পূর্বে আবেদন করতে হবে।যথাসময়ের মধ্যে ডোনার খুজে বের করে দেয়ার জন্য MBDB সর্বোচ্চ চেষ্টা করবে।বাকিটা আল্লাহ ভরসা।(ফেইসবুক পেইজে আবেদন করতে পারবেন,কিন্তু আমাদের ‘Muslim blood Doner Bangladesh’ এপ ব্যবহার করার অনুরোধ রইল।)",
                  style: TextStyles.style15Bangla(Colors.black),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  'আয়ের উৎস:',
                  style: TextStyles.style16BoldBangla(Colors.black),
                ),
                const Divider(),
                Text(
                  '১.মাসিক অনুদান\n'
                  "২.সদকাহ",
                  style: TextStyles.style15Bangla(Colors.black),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  'ব্যয়ের খাত:',
                  style: TextStyles.style16BoldBangla(Colors.black),
                ),
                const Divider(),
                Text(
                  '১.রক্তদান কর্মসূচি পরিচালনা \n'
                  " ২.নিয়মিত এপ ডেভেলপমেন্ট ইত্যাদি।",
                  style: TextStyles.style15Bangla(Colors.black),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  'ডোনারদের সুবিধা:',
                  style: TextStyles.style16BoldBangla(Colors.black),
                ),
                const Divider(),
                Text(
                  '১.ডোনারদের তথ্যের নিরাপত্তা দেয়া\n'
                  '২.প্রতিকূল সময়ে বিশেষ বিবেচনায় যাতায়াত ও খাবার খরচ প্রদান।\n'
                  '৩.বছরে ০৩ বার বা ২ বছরে ০৫ বার আমাদের সংস্থার মাধ্যমে রক্ত দানকারীদের জন্য ক্রেস্ট,সার্টিফিকেট প্রদান।\n'
                  '৪.অন্যদের রক্তদানে উৎসাহ দিতে ডোনারদের রক্তদানরত ছবি,ভিডিও প্রকাশ করা হবে মোবাইল এপ এবং ফেইসবুক পেইজে।',
                  style: TextStyles.style15Bangla(Colors.black),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  'সদস্য সংগ্রহ:',
                  style: TextStyles.style16BoldBangla(Colors.black),
                ),
                const Divider(),
                Text(
                  'ইসলামি ভাবধারার যেকোনো সেচ্ছাসেবী,অরাজনৈতিক প্রতিষ্ঠান আমাদের সাথে সহজ শর্তসাপেক্ষে যুক্ত হতে পারবেন।',
                  style: TextStyles.style15Bangla(Colors.black),
                ),
                const SizedBox(
                  height: 8,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
