// ignore_for_file: unused_import, prefer_const_constructors

import 'package:fintracker/bloc/cubit/app_cubit.dart';
import 'package:fintracker/screens/Advertisement/advertisement_page.dart';
import 'package:fintracker/screens/NFC/NFC_Payment.dart';
import 'package:fintracker/screens/Report/Report.dart';
import 'package:fintracker/screens/Visa/Visa.screen.dart';
import 'package:fintracker/screens/accounts/accounts.screen.dart';
import 'package:fintracker/screens/categories/categories.screen.dart';
import 'package:fintracker/screens/home/home.screen.dart';
import 'package:fintracker/screens/onboard/onboard_screen.dart';
import 'package:fintracker/screens/plans/plan.dart';
import 'package:fintracker/screens/settings/settings.screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'Wishlist.dart';

class MainScreen extends StatefulWidget{
  const MainScreen({super.key});
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>{
  final PageController _controller = PageController(keepPage: true);
  int _selected = 0;

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state){
        AppCubit cubit = context.read<AppCubit>();
        if(cubit.state.currency == null || cubit.state.username == null){
          return OnboardScreen();
        }
        return  Scaffold(
          body: PageView(
            controller: _controller,
            physics: const NeverScrollableScrollPhysics(),
            children: const [
              HomeScreen(),
              AccountsScreen(),
              CategoriesScreen(),
              Visascreen(),
              plan()
            ],
            onPageChanged: (int index){
              setState(() {
                _selected = index;
              });
            },
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: _selected,
            destinations: const [
              NavigationDestination(icon: Icon(Icons.home), label: "Home"),
              NavigationDestination(icon: Icon(Icons.manage_accounts), label: "Accounts"),
              NavigationDestination(icon: Icon(Icons.category), label: "Categories"),
              NavigationDestination(icon: Icon(Icons.credit_card), label: "Visa"),
              NavigationDestination(icon: Icon(Icons.create), label: "plans"),

            ],
            onDestinationSelected: (int selected){
              _controller.jumpToPage(selected);
            },
          ),
          drawer: NavigationDrawer(
            selectedIndex: _selected,
            children: const [
              NavigationDrawerDestination(icon: Icon(Icons.report), label: Text("Monthly_Report")),
              NavigationDrawerDestination(icon: Icon(Icons.nfc), label: Text("NFC_Paymet")),
              NavigationDrawerDestination(icon: Icon(Icons.shopify_sharp), label: Text("Shop")),
              NavigationDrawerDestination(icon: Icon(Icons.note), label: Text("Wishlist")),
              NavigationDrawerDestination(icon: Icon(Icons.settings), label: Text("Settings")),
            ],
            onDestinationSelected: (int selected){
              Navigator.pop(context);

              if(selected == 0){
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ExpenseTracker()));
              }

              if(selected == 1){
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=> NfcPaymentPage()));
              }

              if(selected == 2){
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const AdvertisementPage()));
              }

              if(selected == 3){
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const WishlistPage()));
              }
              if(selected == 4){
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const SettingsScreen()));
              }


            },
          ),
        );
      },
    );

  }
}