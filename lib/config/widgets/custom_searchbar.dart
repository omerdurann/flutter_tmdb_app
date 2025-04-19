import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tmdb_app/config/extensions/context_extensions.dart';

import '../items/colors/app_colors.dart';

class CustomSearchBar extends ConsumerStatefulWidget {
  final Function(String z) onChanged;
  final Function()? clearList;
  final String hintText;

  ///Constructor
  const CustomSearchBar(
      {super.key,
      required this.onChanged,
      this.clearList,
      required this.hintText});

  @override
  ConsumerState<CustomSearchBar> createState() => _CustomSearchBar();
}

class _CustomSearchBar extends ConsumerState<CustomSearchBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _con;
  late TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();

    _textEditingController = TextEditingController();
    _con = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 375),
    );
  }

  @override
  void dispose() {
    _con.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int? toggle = ref.read(searchBarToggleNotifierProvider).getToggle;

    return PopScope(
      // ignore: deprecated_member_use
      onPopInvoked: (didpop) {
        if (didpop) {
          ref.invalidate(searchBarToggleNotifierProvider);
          _textEditingController.clear();
          _con.reverse();
        }
      },
      child: Center(
        child: Container(
          height: context.dynamicHeight(0.05),
          width: context.dynamicWidth(0.9),
          alignment: const Alignment(1.0, 0.0),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 375),
            height: context.dynamicHeight(0.06),
            width: (toggle == 0)
                ? context.dynamicWidth(0.10)
                : context.dynamicWidth(0.9),
            curve: Curves.easeOut,
            decoration: BoxDecoration(
              color: AppColors.grayColor,
              borderRadius: BorderRadius.circular(4),
              boxShadow: [
                BoxShadow(
                  color: AppColors.darkGrayColor.withOpacity(0.5),
                  offset: const Offset(0, 5),
                  blurRadius: 5,
                  spreadRadius: 0.5,
                ),
              ],
            ),
            child: Stack(
              children: [
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 375),
                  top: context.dynamicHeight(0.005),
                  right: context.dynamicWidth(0.02),
                  curve: Curves.easeOut,
                  child: AnimatedOpacity(
                    opacity: (toggle == 0) ? 0.0 : 1.0,
                    duration: const Duration(milliseconds: 200),
                    child: Container(
                      // Remove the background color from this container
                      padding: EdgeInsets.all(context.dynamicHeight(0.005)),
                      decoration: BoxDecoration(
                          // color: Color(0xffF2F3F7), // Remove this line
                          borderRadius: BorderRadius.circular(4)),
                      child: AnimatedBuilder(
                        builder: (context, widget) {
                          return Transform.rotate(
                            angle: _con.value * 2.0 * pi,
                            child: widget,
                          );
                        },
                        animation: _con,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              ref
                                  .read(searchBarToggleNotifierProvider)
                                  .setToggle(0);
                              _textEditingController.clear();
                              _con.reverse();
                            });
                          },
                          child: Icon(
                            Icons.chevron_right_outlined,
                            size: context.dynamicHeight(0.03),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 375),
                  left: context.dynamicWidth(0.002),
                  curve: Curves.easeOut,
                  top: context.dynamicHeight(0.012),
                  child: AnimatedOpacity(
                    opacity: (toggle == 0) ? 0.0 : 1.0,
                    duration: const Duration(milliseconds: 200),
                    child: SizedBox(
                      height: context.dynamicHeight(0.023),
                      width: context.dynamicWidth(0.7),
                      child: TextField(
                        onChanged: widget.onChanged,
                        maxLines: 1,
                        inputFormatters: [
                          FilteringTextInputFormatter.singleLineFormatter,
                        ],
                        style: TextStyle(
                          fontSize: context.dynamicHeight(0.019),
                          fontWeight: FontWeight.w500,
                        ),
                        controller: _textEditingController,
                        cursorRadius: const Radius.circular(10.0),
                        cursorWidth: 2.0,
                        cursorColor: AppColors.blackColor,
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          labelText: widget.hintText,
                          labelStyle: TextStyle(
                            color: AppColors.darkGrayColor,
                            fontSize: context.dynamicHeight(0.019),
                            fontWeight: FontWeight.w500,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: context.dynamicWidth(0.02),
                          ),
                          alignLabelWithHint: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                (toggle == 0)
                    ? Material(
                        color: AppColors.grayColor,
                        borderRadius: BorderRadius.circular(4),
                        child: Center(
                          child: IconButton(
                            splashRadius: 19.0,
                            icon: Icon(
                              Icons.search,
                              color: AppColors.blackColor,
                              size: context.dynamicHeight(0.03),
                            ),
                            onPressed: () {
                              setState(
                                () {
                                  if (toggle == 0) {
                                    ref
                                        .read(searchBarToggleNotifierProvider)
                                        .setToggle(1);
                                    _con.forward();
                                  } else {
                                    widget.clearList!();
                                    _textEditingController.clear();
                                  }
                                },
                              );
                            },
                          ),
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
