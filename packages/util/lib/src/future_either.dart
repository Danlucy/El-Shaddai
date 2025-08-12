import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';

import '../util.dart';

typedef FutureEither<T> = Future<Either<Failure, T>>;
typedef FutureVoid = FutureEither<void>;
typedef MyBuilder = void Function(
    BuildContext context, void Function() methodFromChild);
