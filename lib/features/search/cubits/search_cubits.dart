import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/features/search/cubits/search_states.dart';
import 'package:social_app/features/search/search_repo.dart';

class SearchCubits extends Cubit<SearchStates>{
  final SearchRepo searchRepo;

  SearchCubits({required this.searchRepo}) : super(SearchInitial());

  Future<void> searchUsers(String query) async {
    if(query.isEmpty){
      emit(SearchInitial());
      return;
    }

    try {
      emit(SearchLoading());
      final users = await searchRepo.searchUsers(query);
      emit(SearchLoaded(users));
    } catch (e) {
      emit(SearchError("Error fetching search results:"));
    }
  }
}