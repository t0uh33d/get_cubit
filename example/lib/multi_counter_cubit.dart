import 'package:example/counter_cubit.dart';
import 'package:example/counter_selector_cubit.dart';
import 'package:example/counter_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_cubit/get_cubit.dart';

class MultiCounterCubit extends StatefulWidget {
  const MultiCounterCubit({super.key});

  @override
  State<MultiCounterCubit> createState() => _MultiCounterCubitState();
}

class _MultiCounterCubitState extends State<MultiCounterCubit> {
  @override
  void dispose() {
    GetCubit.deleteAllCubitInstances<CounterCubit>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Multi Counter Cubit"),
        elevation: 0,
      ),
      body: Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 5,
            itemBuilder: (context, index) {
              return BlocProvider.value(
                value: GetCubit.put(CounterCubit(), id: index.toString()),
                child: BlocBuilder<CounterCubit, int>(
                  builder: (context, state) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: counterWidget(
                        onInc: () {},
                        onDec: () {},
                        onRes: () {},
                        counterName: index.toString(),
                        counterValue: state,
                        disableControls: true,
                      ),
                    );
                  },
                ),
              );
            },
          ),
          const SizedBox(height: 100),
          BlocProvider.value(
            value: GetCubit.put(CounterSelectorCubit()),
            child: counterWidget(
              onInc: () {
                int currentCounter =
                    GetCubit.find<CounterSelectorCubit>().state;
                GetCubit.find<CounterCubit>(id: currentCounter.toString())
                    .increment();
              },
              onDec: () {
                int currentCounter =
                    GetCubit.find<CounterSelectorCubit>().state;
                GetCubit.find<CounterCubit>(id: currentCounter.toString())
                    .decrement();
              },
              onRes: () {
                int currentCounter =
                    GetCubit.find<CounterSelectorCubit>().state;
                GetCubit.find<CounterCubit>(id: currentCounter.toString())
                    .reset();
              },
              counterName: 'Controls',
              counterValue: 0,
              disableDisplay: true,
            ),
          ),
        ],
      ),
    );
  }
}
