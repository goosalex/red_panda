import 'dart:math' as math;

import 'package:flutter/widgets.dart';

/// The widest a column of text gets. On an iPad the text keeps the iPhone's
/// point sizes (Apple's guideline; only Dynamic Type scales it) and the extra
/// width becomes margin, so lines stay short enough to read.
const readableWidth = 700.0;

/// Side padding that centres a [readableWidth] column in the window, at least
/// [min] on each side. For scroll views, so they still scroll from the margins.
EdgeInsets readableInsets(BuildContext context, {double min = 0}) =>
    EdgeInsets.symmetric(horizontal: readableMargin(context, min: min));

double readableMargin(BuildContext context, {double min = 0}) =>
    math.max(min, (MediaQuery.sizeOf(context).width - readableWidth) / 2);
