import 'package:mind_dumps/models/dump.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class DumpRepository {
  Stream<List<MindDump>> dumps();

  void dispose();

  void refresh();

  void delete(MindDump mindDump) {}
}

abstract class DumpEvents {}

class HasDataEvent extends DumpEvents {
  final List<MindDump> data;

  HasDataEvent(this.data);
}

abstract class DumpState {}

class DumpLoadingState extends DumpState {}

class DumpHasDataState extends DumpState {
  final List<MindDump> data;

  DumpHasDataState(this.data);
}

class DumpsBloc extends Bloc<DumpEvents, DumpState> {
  final DumpRepository repository;

  DumpsBloc(this.repository) {
    repository.dumps().listen((data) {
      add(HasDataEvent(data));
    });
  }

  @override
  Future<Function> close() {
    repository.dispose();
    return super.close();
  }

  @override
  DumpState get initialState => DumpLoadingState();

  @override
  Stream<DumpState> mapEventToState(DumpEvents event) async* {
    if (event is HasDataEvent) {
      yield DumpHasDataState(event.data);
    }
  }


}

