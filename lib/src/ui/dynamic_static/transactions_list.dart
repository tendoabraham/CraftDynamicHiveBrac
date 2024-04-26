// ignore_for_file: prefer_typing_uninitialized_variables, must_be_immutable

import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:craft_dynamic/src/network/dynamic_request.dart';
import 'package:flutter/material.dart';

class TransactionList extends StatefulWidget {
  TransactionList({Key? key, required this.moduleItem}) : super(key: key);
  ModuleItem moduleItem;

  @override
  State<TransactionList> createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  List<Transaction> transactionList = [];
  final _dynamicRequest = DynamicFormRequest();

  @override
  void initState() {
    super.initState();
    DynamicInput.formInputValues.clear();
    DynamicInput.formInputValues.addAll({"HEADER": "GETTRXLIST"});
  }

  getTransactionList() => _dynamicRequest.dynamicRequest(widget.moduleItem,
      dataObj: DynamicInput.formInputValues,
      encryptedField: DynamicInput.encryptedField,
      context: context,
      listType: ListType.TransactionList);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/bk4.png'),
              fit: BoxFit.cover,
              alignment: Alignment.topCenter
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Column(
            children: [
              SizedBox(
                height: 50,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'My Transactions',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                        color: APIService.appPrimaryColor,
                        fontFamily: "Mulish",
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey[300],
                        ),
                        child: Icon(
                          Icons.close,
                          color: APIService.appPrimaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                height: 1.0, // Line height
                color: Colors.grey[300], // Line color
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(child: FutureBuilder<DynamicResponse?>(
                  future: getTransactionList(),
                  builder: (BuildContext context,
                      AsyncSnapshot<DynamicResponse?> snapshot) {
                    Widget widget = Center(child: LoadUtil());

                    if (snapshot.hasData) {
                      var list = snapshot.data?.dynamicList;
                      if (list != null && list.isNotEmpty) {
                        addTransactions(list: list);
                        widget = ListView.separated(
                          itemCount: transactionList.length,
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          itemBuilder: (context, index) {
                            return TransactionItem(
                                transaction: transactionList[index]);
                          },
                          separatorBuilder: (BuildContext context, int index) =>
                          const SizedBox(
                            height: 2,
                          ),
                        );
                      } else {
                        widget = EmptyUtil();
                      }
                    }
                    return widget;
                  })
              )
            ],
          ),
        ),
      ),);
  }

  @override
  void dispose() {
    super.dispose();
  }

  addTransactions({required list}) {
    list.forEach((item) {
      transactionList.add(Transaction.fromJson(item));
    });
  }
}

class TransactionItem extends StatelessWidget {
  Transaction transaction;

  TransactionItem({Key? key, required this.transaction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        child: Card(
            elevation: 4.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: IntrinsicHeight(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      transaction.serviceName,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'Mulish',
                                          color: APIService.appPrimaryColor),
                                    ),
                                    Text(
                                      transaction.status,
                                      style: TextStyle(
                                        fontFamily: 'Mulish',
                                        color: transaction.status == "FAIL"
                                            ? Colors.red
                                            : Colors.green,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text("Date",
                                            style: TextStyle(
                                                fontFamily: 'Mulish',
                                                fontSize: 13,
                                                color: Colors.grey
                                            ),),
                                          Text(
                                            transaction.date,
                                            style: const TextStyle(
                                                fontFamily: 'Mulish',
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ]),
                                    Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text("Amount",
                                            style: TextStyle(
                                              fontFamily: 'Mulish',
                                              color: Colors.grey,
                                            ),),
                                          Text(transaction.amount,
                                              style: const TextStyle(
                                                  fontFamily: 'Mulish',
                                                  fontWeight: FontWeight.bold))
                                        ])
                                  ],
                                ),
                                const SizedBox(
                                  height: 15,
                                )
                              ],
                            )),
                      ],
                    )))));
  }
}

class Transaction {
  String bankAccountID;
  String status;
  String serviceName;
  String date;
  String amount;

  Transaction(
      {required this.bankAccountID,
        required this.status,
        required this.serviceName,
        required this.date,
        required this.amount});

  Transaction.fromJson(Map<String, dynamic> json)
      : bankAccountID = json["BankAccountID"],
        status = json["Status"],
        serviceName = json["ServiceName"],
        date = json["Date"],
        amount = json["Amount"];
}
