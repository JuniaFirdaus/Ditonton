import 'package:core/core.dart';
import 'package:core/utils/state_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/presentation/bloc/search/tv_search_bloc.dart';
import 'package:tv/presentation/bloc/search/tv_search_event.dart';
import 'package:tv/presentation/widgets/tv_card_list.dart';

// class SearchTvPage extends StatelessWidget {
//   static const ROUTE_NAME = '/search-tv';
//
//   const SearchTvPage({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Search'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             TextField(
//               onChanged: (query) {
//                 context.read<TvSearchBloc>().add(OnQueryChanged(query));
//               },
//               decoration: const InputDecoration(
//                 hintText: 'Search title',
//                 prefixIcon: Icon(Icons.search),
//                 border: OutlineInputBorder(),
//               ),
//               textInputAction: TextInputAction.search,
//             ),
//             const SizedBox(height: 16),
//             Text(
//               'Search Result',
//               style: kHeading6,
//             ),
//             BlocBuilder<TvSearchBloc, StateRequest>(
//               builder: (context, state) {
//                 if (state is Loading) {
//                   return const Center(
//                     child: CircularProgressIndicator(),
//                   );
//                 } else if (state is HasData) {
//                   final result = state.result;
//                   return Expanded(
//                     child: ListView.builder(
//                       padding: const EdgeInsets.all(8),
//                       itemBuilder: (context, index) {
//                         final tv = state.result[index];
//                         return TvCard(tv);
//                       },
//                       itemCount: result.length,
//                     ),
//                   );
//                 } else {
//                   return Expanded(
//                     child: Container(),
//                   );
//                 }
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
