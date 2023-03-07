import 'package:example/counter_selector_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_cubit/get_cubit.dart';

typedef CounterFunction = void Function()?;

Widget counterWidget({
  required CounterFunction onInc,
  required CounterFunction onDec,
  required CounterFunction onRes,
  required String counterName,
  required int counterValue,
  bool disableControls = false,
  bool disableDisplay = false,
}) {
  return Container(
    width: 300,
    color: Colors.grey,
    padding: const EdgeInsets.all(2),
    child: Column(
      children: [
        if (!disableDisplay) Text('Counter : $counterName'),
        !disableDisplay
            ? Container(
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.symmetric(horizontal: 5),
                width: double.infinity,
                color: Colors.green,
                child: Text(
                  '$counterValue',
                  style: const TextStyle(color: Colors.black),
                  textScaleFactor: 2,
                ),
              )
            : BlocBuilder<CounterSelectorCubit, int>(
                builder: (context, state) {
                  return DropdownButton(
                      dropdownColor: Colors.grey,
                      value: state,
                      items: [0, 1, 2, 3, 4]
                          .map((e) => DropdownMenuItem(
                              value: e,
                              child: Text(
                                'Counter : $e',
                                style: const TextStyle(color: Colors.white),
                              )))
                          .toList(),
                      onChanged: (value) =>
                          GetCubit.find<CounterSelectorCubit>()
                              .selectCounter(value!));
                },
              ),
        if (!disableControls)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _counterButton(onDec, 'DEC'),
              _counterButton(onRes, 'RES'),
              _counterButton(onInc, 'INC'),
            ],
          )
      ],
    ),
  );
}

MaterialButton _counterButton(CounterFunction onPressed, String btnTxt) {
  return MaterialButton(
    onPressed: onPressed,
    color: Colors.black45,
    child: Text(
      btnTxt,
      style: const TextStyle(color: Colors.white),
    ),
  );
}
