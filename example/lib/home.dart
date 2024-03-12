import 'package:example/counter_cubit.dart';
import 'package:example/counter_widget.dart';
import 'package:example/multi_counter_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_cubit/get_state.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GetCubit Demo'),
        elevation: 0,
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SizedBox(),
            BlocProvider.value(
              value: GetCubit.put(CounterCubit()),
              child: BlocBuilder<CounterCubit, int>(
                builder: (context, state) {
                  return counterWidget(
                    onInc: () => GetCubit.find<CounterCubit>().increment(),
                    onDec: () => GetCubit.find<CounterCubit>().decrement(),
                    onRes: () => GetCubit.find<CounterCubit>().reset(),
                    counterName: 'Initial Counter',
                    counterValue: state,
                  );
                },
              ),
            ),
            const SizedBox(),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const MultiCounterCubit()));
                },
                child: const Text('Go to Multi Counter Screen'))
          ],
        ),
      ),
    );
  }
}
