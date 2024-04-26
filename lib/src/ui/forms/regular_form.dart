// ignore_for_file: must_be_immutable

import 'package:craft_dynamic/src/ui/dynamic_static/list_data.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:provider/provider.dart';

class RegularFormWidget extends StatefulWidget {
  final ModuleItem moduleItem;
  final List<FormItem> sortedForms;
  final List<dynamic>? jsonDisplay, formFields;
  final bool hasRecentList;

  const RegularFormWidget(
      {super.key,
        required this.moduleItem,
        required this.sortedForms,
        required this.jsonDisplay,
        required this.formFields,
        this.hasRecentList = false});

  @override
  State<RegularFormWidget> createState() => _RegularFormWidgetState();
}

class _RegularFormWidgetState extends State<RegularFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();
  List<FormItem> formItems = [];
  FormItem? recentList;

  @override
  initState() {
    recentList = widget.sortedForms.toList().firstWhereOrNull(
            (formItem) => formItem.controlType == ViewType.LIST.name);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    formItems = widget.sortedForms.toList()
      ..removeWhere((element) => element.controlType == ViewType.LIST.name);

    return WillPopScope(
        onWillPop: () async {
          if (Provider.of<PluginState>(context, listen: false)
              .loadingNetworkData) {
            CommonUtils.showToast("Please wait...");
            return false;
          }
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Provider.of<PluginState>(context, listen: false)
                .clearDynamicDropDown();
          });
          Provider.of<PluginState>(context, listen: false)
              .setRequestState(false);
          return true;
        },
        child: Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/trx_bk2.png'),
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.07,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                          onTap: (){
                            Navigator.pop(context);
                          },
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.zero,
                                child: Image.asset(
                                  'assets/images/back2.png',
                                  height: 30,
                                  width: 30,
                                ),
                              )
                          )
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: IntrinsicWidth(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              border: Border.all(color: Colors.white, width: 2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(widget.moduleItem!.moduleName,
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontFamily: "Mulish",
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 20
                              ),),
                          ),
                        ),),
                      SizedBox(
                        width: 5,
                      ),
                      IconButton(
                          onPressed: () {
                            CommonUtils.navigateToRoute(
                                context: context,
                                widget: ListDataScreen(
                                    widget: DynamicListWidget(
                                        moduleItem: widget.moduleItem,
                                        formItem: recentList)
                                        .render(),
                                    title: widget.moduleItem.moduleName));
                          },
                          icon: const Icon(
                            Icons.view_list,
                            color: Colors.white,
                            size: 30,
                          )),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.032,
                  ),
                  // Text(widget.moduleItem!.moduleName,
                  //   textAlign: TextAlign.center,
                  //   maxLines: 1,
                  //   style: const TextStyle(
                  //       fontFamily: "Mulish",
                  //       color: Colors.white,
                  //       fontWeight: FontWeight.bold,
                  //       fontSize: 30
                  //   ),),
                  // SizedBox(
                  //   height: 10,
                  // ),
                  // Center(
                  //   child: Card(
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(50.0),
                  //       //set border radius more than 50% of height and width to make circle
                  //     ),
                  //     elevation: 2,
                  //     shadowColor: Colors.black,
                  //     surfaceTintColor: Colors.white,
                  //     child: Padding(
                  //       padding: EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                  //       child: Text("Please complete the form below",
                  //           style: const TextStyle(
                  //             fontFamily: "Mulish",
                  //             fontWeight: FontWeight.bold,
                  //           )),
                  //     ),
                  //   ),
                  // ),
                  Expanded(child: SizedBox(
                      height: double.infinity,
                      child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              const SizedBox(
                                height: 12,
                              ),
                              Form(
                                  key: _formKey,
                                  child: ListView.builder(
                                      padding: const EdgeInsets.only(
                                          left: 14, right: 14, top: 8),
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemCount: formItems.length,
                                      itemBuilder: (context, index) {
                                        return BaseFormComponent(
                                            formItem: formItems[index],
                                            moduleItem: widget.moduleItem,
                                            formItems: formItems,
                                            formKey: _formKey,
                                            child: IFormWidget(formItems[index],
                                                jsonText: widget.jsonDisplay,
                                                formFields: widget.formFields)
                                                .render());
                                      }))
                            ],
                          ))))
                ],
              ),
            ),
          ),
        ));
  }
}
