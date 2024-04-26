import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

class RedeemPage extends StatefulWidget {
  final Function(int) redeemCallback;

  RedeemPage({Key? key, required this.redeemCallback}) : super(key: key);

  @override
  _RedeemPageState createState() => _RedeemPageState();
}

class _RedeemPageState extends State<RedeemPage>
{
  List<dynamic> rewards = [];

  @override
  void initState() {
    super.initState();
    loadRewardsData();
  }

  Future<void> loadRewardsData() async {
    String jsonData = await rootBundle.loadString('assets/json loyalty crd (1).txt');
    setState(() {
      rewards = jsonDecode(jsonData);
    });
  }

  void _showRewardDetails(dynamic reward) {
    TextEditingController otpController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/globe.png'), // Replace with your image asset
              SizedBox(height: 16),
              Text(
                'Worth: ${reward['worth']}',
                style: TextStyle(fontSize: 18),
              ),
              Text(
                'Price: ${reward['price']}',
                style: TextStyle(fontSize: 18),
              ),
              Text(
                'Expiry: ${reward['expiry']}',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 16),
              TextField(
                controller: otpController,
                keyboardType: TextInputType.number,
                maxLength: 4,
                decoration: InputDecoration(
                  labelText: 'Enter OTP',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Validate OTP here
                String enteredOTP = otpController.text;
                if (enteredOTP.length == 4) {
                  // Handle OTP validation logic here
                  // For example, compare enteredOTP with reward['otp']
                  if (enteredOTP == reward['otp'].toString()) {
                    // OTP is correct, close dialog
                    Navigator.of(context).pop();
                    // Notify MyHomePage to deduct points
                    widget.redeemCallback(reward['worth']);
                    // Show success message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Redeem successful!'),
                        duration: Duration(seconds: 2), // Adjust as needed
                      ),
                    );
                  } else {
                    // Incorrect OTP, show error message or handle accordingly
                  }
                } else {
                  // Invalid OTP length, show error message or handle accordingly
                }
              },
              child: Text('Submit'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Redeem Page'),
      ),
      body: rewards.isEmpty
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            for (var reward in rewards)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reward['brand'],
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 150,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: reward['noOfCards'],
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: 150, // Set a fixed width
                              height: 100, // Set a fixed height
                              child: Card(
                                child: InkWell(
                                  onTap: () {
                                    _showRewardDetails(reward);
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('${reward['title']}'),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}