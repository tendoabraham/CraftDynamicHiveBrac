import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:craft_dynamic/src/network/dynamic_request.dart';
import 'package:craft_dynamic/src/util/local_data_util.dart';
import 'package:flutter/material.dart';

class ViewBeneficiary extends StatefulWidget {
  final ModuleItem moduleItem;

  const ViewBeneficiary({required this.moduleItem, super.key});

  @override
  State<StatefulWidget> createState() => _ViewBeneficiaryState();
}

class _ViewBeneficiaryState extends State<ViewBeneficiary> {
  final _beneficiaryRepository = BeneficiaryRepository();
  final _dynamicFormRequest = DynamicFormRequest();

  @override
  initState() {
    super.initState();
    isCallingService.value = false;
  }

  getBeneficiaries() => _beneficiaryRepository.getAllBeneficiaries();

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
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
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
                      'View Beneficiaries',
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
              Expanded(
                child: FutureBuilder<List<Beneficiary>>(
                  future: viewBeneficiaries(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Beneficiary>> snapshot) {
                    Widget widget = Center(child: CircularLoadUtil());

                    if (snapshot.hasData) {
                      final itemCount = snapshot.data?.length ?? 0;

                      if (itemCount == 0) {
                        widget = EmptyUtil();
                      } else {
                        widget = ListView.separated(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          separatorBuilder: (BuildContext context, int index) =>
                          const SizedBox(
                            height: 10,
                          ),
                          itemCount: itemCount,
                          itemBuilder: (context, index) {
                            final beneficiary = snapshot.data![index];

                            return Card(
                              elevation: 4.0,
                              margin: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 2,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Beneficiary ${index + 1}",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: "Mulish",
                                            color: APIService.appPrimaryColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 12,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 1),
                                          child: Row(
                                            children: [
                                              const Text(
                                                "Name",
                                                style: TextStyle(
                                                  fontFamily: "Mulish",
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 12,
                                              ),
                                              Text(
                                                beneficiary.accountAlias,
                                                style: TextStyle(
                                                  fontFamily: "Mulish",
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 2,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 1),
                                          child: Row(
                                            children: [
                                              const Text(
                                                "Account",
                                                style: TextStyle(
                                                  fontFamily: "Mulish",
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 12,
                                              ),
                                              Text(
                                                beneficiary.accountID,
                                                style: TextStyle(
                                                  fontFamily: "Mulish",
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text(
                                                "Alert",
                                                style: TextStyle(
                                                  fontFamily: "Mulish",
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              content: Text(
                                                "Confirm action to delete this beneficiary ${beneficiary.accountAlias}",
                                                style: TextStyle(
                                                  fontFamily: "Mulish",
                                                ),
                                              ),
                                              actions: <Widget>[
                                                TextButton(
                                                  child: const Text(
                                                    "Cancel",
                                                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontFamily: "Mulish", fontSize: 18),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.of(context).pop(true);
                                                  },
                                                ),
                                                TextButton(
                                                  child: Text(
                                                    "Yes",
                                                    style: TextStyle(fontWeight: FontWeight.bold, color: APIService.appPrimaryColor, fontFamily: "Mulish", fontSize: 18),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.of(context).pop(true);
                                                    deleteBeneficiary(beneficiary, context);
                                                    // Allow back navigation
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                        // AlertUtil.showAlertDialog(context,
                                        //     "Confirm action to delete this beneficiary ${beneficiary.accountAlias}",
                                        //     isConfirm: true,
                                        //     title: "Delete",
                                        //     confirmButtonText: "Delete")
                                        //     .then((value) {
                                        //   if (value) {
                                        //     deleteBeneficiary(beneficiary, context);
                                        //   }
                                        // });
                                      },
                                      icon: const Icon(
                                        Icons.delete_outline_outlined,
                                        color: Colors.red,
                                        size: 34,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }
                    }
                    return widget;
                  },
                ),
              ),
            ],
          ),
        ),
      ),);
  }

  Future<List<Beneficiary>> viewBeneficiaries() async {
    isCallingService.value = true;
    List<Beneficiary> beneficiaries = [];
    try {
      DynamicInput.formInputValues.clear();
      DynamicInput.formInputValues
          .addAll({"MerchantID": widget.moduleItem.merchantID});

      DynamicInput.formInputValues.addAll({"HEADER": "GETBENEFICIARY"});
      DynamicInput.formInputValues.addAll({"INFOFIELD1": "TRANSFER"});
    } catch (e) {
      debugPrint("benefifciary error $e");
    }

    await _dynamicFormRequest
        .dynamicRequest(widget.moduleItem,
        dataObj: DynamicInput.formInputValues,
        context: context,
        listType: ListType.BeneficiaryList)
        .then((value) {
      isCallingService.value = false;
      if (value?.status == StatusCode.success.statusCode) {
        var beneficiaryList = value?.beneficiaries;
        if (beneficiaryList != []) {
          beneficiaryList?.forEach((beneficiary) {
            beneficiaries.add(Beneficiary.fromJson(beneficiary));
          });
        }
      }
    });
    return beneficiaries;
  }

  deleteBeneficiary(Beneficiary beneficiary, context) {
    isCallingService.value = true;
    DynamicInput.formInputValues.clear();
    DynamicInput.formInputValues
        .addAll({"INFOFIELD1": beneficiary.accountAlias});
    DynamicInput.formInputValues
        .addAll({"INFOFIELD2": beneficiary.merchantName});
    DynamicInput.formInputValues.addAll({"INFOFIELD4": beneficiary.accountID});
    DynamicInput.formInputValues.addAll({"INFOFIELD3": beneficiary.rowId});
    DynamicInput.formInputValues
        .addAll({"MerchantID": widget.moduleItem.merchantID});
    DynamicInput.formInputValues.addAll({"HEADER": "DELETEBENEFICIARY"});
    _dynamicFormRequest
        .dynamicRequest(widget.moduleItem,
        dataObj: DynamicInput.formInputValues,
        context: context,
        listType: ListType.BeneficiaryList)
        .then((value) {
      isCallingService.value = false;

      if (value?.status == StatusCode.success.statusCode) {
        CommonUtils.showToast(
            "Beneficiary ${beneficiary.accountAlias} successfully deleted");
        setState(() {
          _beneficiaryRepository.deleteBeneficiary(beneficiary.rowId);
          var beneficiaries = value?.beneficiaries;
          if (beneficiaries != null) {
            LocalDataUtil.refreshBeneficiaries(beneficiaries);
          }
        });
      } else {
        AlertUtil.showAlertDialog(
          context,
          value?.message ?? "Error",
        );
      }
    });
  }
}
