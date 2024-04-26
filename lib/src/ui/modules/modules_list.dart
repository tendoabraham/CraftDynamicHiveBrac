// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';

import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:provider/provider.dart';

class ModulesListWidget extends StatefulWidget {
  Orientation orientation;
  ModuleItem? moduleItem;
  FrequentAccessedModule? favouriteModule;

  ModulesListWidget({
    super.key,
    required this.orientation,
    required this.moduleItem,
    this.favouriteModule,
  });

  @override
  State<ModulesListWidget> createState() => _ModulesListWidgetState();
}

class _ModulesListWidgetState extends State<ModulesListWidget> {
  final _moduleRepository = ModuleRepository();

  Future<List<ModuleItem>?> getModules() async {
    List<ModuleItem>? modules = await _moduleRepository.getModulesById(
        widget.favouriteModule == null
            ? widget.moduleItem!.moduleId
            : widget.favouriteModule!.moduleID);

    return modules;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
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
                  // GestureDetector(
                  //   onTap: (){
                  //     Navigator.pop(context);
                  //   },
                  //   child: Container(
                  //     padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  //     decoration: BoxDecoration(
                  //       color: Colors.transparent,
                  //       border: Border.all(color: Colors.white, width: 2),
                  //       borderRadius: BorderRadius.circular(8),
                  //     ),
                  //     child: Row(
                  //       children: [
                  //         SizedBox(
                  //           width: 5,
                  //         ),
                  //         Image.asset(
                  //           'assets/images/back2.png',
                  //           height: 30,
                  //           width: 30,
                  //         ),
                  //         Text("Home",
                  //           style: TextStyle(
                  //               fontSize: 13,
                  //               fontFamily: "Mulish",
                  //               fontWeight: FontWeight.bold,
                  //               color: Colors.white
                  //           ),),
                  //       ],
                  //     ),
                  //   ),
                  // ),
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
                        width: 40,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.04,
                  ),
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
                  //       child: Text("Please choose one of the services below",
                  //           style: const TextStyle(
                  //             fontFamily: "Mulish",
                  //             fontWeight: FontWeight.bold,
                  //           )),
                  //     ),
                  //   ),
                  // ),
                  Expanded(child: FutureBuilder<List<ModuleItem>?>(
                      future: getModules(),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<ModuleItem>?> snapshot) {
                        Widget child = const Center(child: Text("Please wait..."));
                        if (snapshot.hasData) {
                          var modules = snapshot.data?.toList();
                          modules?.removeWhere((module) => module.isHidden == true);

                          if (modules != null) {
                            child = SizedBox(
                                height: double.infinity,
                                child: GridView.builder(
                                  // physics: const NeverScrollableScrollPhysics(),
                                    padding: const EdgeInsets.only(
                                        left: 14, right: 14, top: 15, bottom: 8),
                                    shrinkWrap: true,
                                    itemCount: modules.length,
                                    gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        crossAxisSpacing: 4,
                                        mainAxisSpacing: 12,
                                        childAspectRatio: .9),
                                    itemBuilder: (BuildContext context, int index) {
                                      var module = modules[index];
                                      return ModuleItemWidget(moduleItem: module);
                                    }));
                          }
                        }
                        return child;
                      }))
                ],
              ),
            ),
          ),
        ));
  }

  @override
  void dispose() {
    super.dispose();
  }
}
