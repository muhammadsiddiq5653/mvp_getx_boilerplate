import 'package:flutter/material.dart';

class AppDimensions {
  // Private constructor to prevent instantiation
  AppDimensions._();

  // Base unit for consistent spacing
  static const double baseUnit = 8.0;

  // Spacing Scale
  static const double spacing2xs = baseUnit * 0.5; // 4
  static const double spacingXs = baseUnit * 1; // 8
  static const double spacingSm = baseUnit * 1.5; // 12
  static const double spacingMd = baseUnit * 2; // 16
  static const double spacingLg = baseUnit * 3; // 24
  static const double spacingXl = baseUnit * 4; // 32
  static const double spacing2xl = baseUnit * 5; // 40
  static const double spacing3xl = baseUnit * 6; // 48
  static const double spacing4xl = baseUnit * 8; // 64
  static const double spacing5xl = baseUnit * 10; // 80
  static const double spacing6xl = baseUnit * 12; // 96

  // Padding
  static const EdgeInsets paddingAll2xs = EdgeInsets.all(spacing2xs);
  static const EdgeInsets paddingAllXs = EdgeInsets.all(spacingXs);
  static const EdgeInsets paddingAllSm = EdgeInsets.all(spacingSm);
  static const EdgeInsets paddingAllMd = EdgeInsets.all(spacingMd);
  static const EdgeInsets paddingAllLg = EdgeInsets.all(spacingLg);
  static const EdgeInsets paddingAllXl = EdgeInsets.all(spacingXl);
  static const EdgeInsets paddingAll2xl = EdgeInsets.all(spacing2xl);
  static const EdgeInsets paddingAll3xl = EdgeInsets.all(spacing3xl);

  // Horizontal Padding
  static const EdgeInsets paddingHorizontalXs = EdgeInsets.symmetric(horizontal: spacingXs);
  static const EdgeInsets paddingHorizontalSm = EdgeInsets.symmetric(horizontal: spacingSm);
  static const EdgeInsets paddingHorizontalMd = EdgeInsets.symmetric(horizontal: spacingMd);
  static const EdgeInsets paddingHorizontalLg = EdgeInsets.symmetric(horizontal: spacingLg);
  static const EdgeInsets paddingHorizontalXl = EdgeInsets.symmetric(horizontal: spacingXl);
  static const EdgeInsets paddingHorizontal2xl = EdgeInsets.symmetric(horizontal: spacing2xl);

  // Vertical Padding
  static const EdgeInsets paddingVerticalXs = EdgeInsets.symmetric(vertical: spacingXs);
  static const EdgeInsets paddingVerticalSm = EdgeInsets.symmetric(vertical: spacingSm);
  static const EdgeInsets paddingVerticalMd = EdgeInsets.symmetric(vertical: spacingMd);
  static const EdgeInsets paddingVerticalLg = EdgeInsets.symmetric(vertical: spacingLg);
  static const EdgeInsets paddingVerticalXl = EdgeInsets.symmetric(vertical: spacingXl);
  static const EdgeInsets paddingVertical2xl = EdgeInsets.symmetric(vertical: spacing2xl);

  // Margin
  static const EdgeInsets marginAll2xs = EdgeInsets.all(spacing2xs);
  static const EdgeInsets marginAllXs = EdgeInsets.all(spacingXs);
  static const EdgeInsets marginAllSm = EdgeInsets.all(spacingSm);
  static const EdgeInsets marginAllMd = EdgeInsets.all(spacingMd);
  static const EdgeInsets marginAllLg = EdgeInsets.all(spacingLg);
  static const EdgeInsets marginAllXl = EdgeInsets.all(spacingXl);
  static const EdgeInsets marginAll2xl = EdgeInsets.all(spacing2xl);

  // Horizontal Margin
  static const EdgeInsets marginHorizontalXs = EdgeInsets.symmetric(horizontal: spacingXs);
  static const EdgeInsets marginHorizontalSm = EdgeInsets.symmetric(horizontal: spacingSm);
  static const EdgeInsets marginHorizontalMd = EdgeInsets.symmetric(horizontal: spacingMd);
  static const EdgeInsets marginHorizontalLg = EdgeInsets.symmetric(horizontal: spacingLg);
  static const EdgeInsets marginHorizontalXl = EdgeInsets.symmetric(horizontal: spacingXl);

  // Vertical Margin
  static const EdgeInsets marginVerticalXs = EdgeInsets.symmetric(vertical: spacingXs);
  static const EdgeInsets marginVerticalSm = EdgeInsets.symmetric(vertical: spacingSm);
  static const EdgeInsets marginVerticalMd = EdgeInsets.symmetric(vertical: spacingMd);
  static const EdgeInsets marginVerticalLg = EdgeInsets.symmetric(vertical: spacingLg);
  static const EdgeInsets marginVerticalXl = EdgeInsets.symmetric(vertical: spacingXl);

  // Border Radius
  static const double radiusXs = 4.0;
  static const double radiusSm = 6.0;
  static const double radiusMd = 8.0;
  static const double radiusLg = 12.0;
  static const double radiusXl = 16.0;
  static const double radius2xl = 20.0;
  static const double radius3xl = 24.0;
  static const double radius4xl = 32.0;
  static const double radiusFull = 9999.0;

  // Border Radius Objects
  static const BorderRadius borderRadiusXs = BorderRadius.all(Radius.circular(radiusXs));
  static const BorderRadius borderRadiusSm = BorderRadius.all(Radius.circular(radiusSm));
  static const BorderRadius borderRadiusMd = BorderRadius.all(Radius.circular(radiusMd));
  static const BorderRadius borderRadiusLg = BorderRadius.all(Radius.circular(radiusLg));
  static const BorderRadius borderRadiusXl = BorderRadius.all(Radius.circular(radiusXl));
  static const BorderRadius borderRadius2xl = BorderRadius.all(Radius.circular(radius2xl));
  static const BorderRadius borderRadius3xl = BorderRadius.all(Radius.circular(radius3xl));
  static const BorderRadius borderRadius4xl = BorderRadius.all(Radius.circular(radius4xl));
  static const BorderRadius borderRadiusFull = BorderRadius.all(Radius.circular(radiusFull));

  // Specific Border Radius
  static const BorderRadius borderRadiusTopXs = BorderRadius.only(
    topLeft: Radius.circular(radiusXs),
    topRight: Radius.circular(radiusXs),
  );
  static const BorderRadius borderRadiusTopSm = BorderRadius.only(
    topLeft: Radius.circular(radiusSm),
    topRight: Radius.circular(radiusSm),
  );
  static const BorderRadius borderRadiusTopMd = BorderRadius.only(
    topLeft: Radius.circular(radiusMd),
    topRight: Radius.circular(radiusMd),
  );
  static const BorderRadius borderRadiusTopLg = BorderRadius.only(
    topLeft: Radius.circular(radiusLg),
    topRight: Radius.circular(radiusLg),
  );
  static const BorderRadius borderRadiusTopXl = BorderRadius.only(
    topLeft: Radius.circular(radiusXl),
    topRight: Radius.circular(radiusXl),
  );

  static const BorderRadius borderRadiusBottomXs = BorderRadius.only(
    bottomLeft: Radius.circular(radiusXs),
    bottomRight: Radius.circular(radiusXs),
  );
  static const BorderRadius borderRadiusBottomSm = BorderRadius.only(
    bottomLeft: Radius.circular(radiusSm),
    bottomRight: Radius.circular(radiusSm),
  );
  static const BorderRadius borderRadiusBottomMd = BorderRadius.only(
    bottomLeft: Radius.circular(radiusMd),
    bottomRight: Radius.circular(radiusMd),
  );
  static const BorderRadius borderRadiusBottomLg = BorderRadius.only(
    bottomLeft: Radius.circular(radiusLg),
    bottomRight: Radius.circular(radiusLg),
  );
  static const BorderRadius borderRadiusBottomXl = BorderRadius.only(
    bottomLeft: Radius.circular(radiusXl),
    bottomRight: Radius.circular(radiusXl),
  );

  // Elevation
  static const double elevationNone = 0;
  static const double elevationXs = 1;
  static const double elevationSm = 2;
  static const double elevationMd = 4;
  static const double elevationLg = 8;
  static const double elevationXl = 12;
  static const double elevation2xl = 16;
  static const double elevation3xl = 24;

  // Icon Sizes
  static const double iconXs = 12.0;
  static const double iconSm = 16.0;
  static const double iconMd = 20.0;
  static const double iconLg = 24.0;
  static const double iconXl = 32.0;
  static const double icon2xl = 40.0;
  static const double icon3xl = 48.0;
  static const double icon4xl = 64.0;
  static const double icon5xl = 80.0;
  static const double icon6xl = 96.0;

  // Avatar Sizes
  static const double avatarXs = 24.0;
  static const double avatarSm = 32.0;
  static const double avatarMd = 40.0;
  static const double avatarLg = 48.0;
  static const double avatarXl = 64.0;
  static const double avatar2xl = 80.0;
  static const double avatar3xl = 96.0;
  static const double avatar4xl = 128.0;

  // Button Heights
  static const double buttonHeightSm = 32.0;
  static const double buttonHeightMd = 40.0;
  static const double buttonHeightLg = 48.0;
  static const double buttonHeightXl = 56.0;

  // Input Heights
  static const double inputHeightSm = 32.0;
  static const double inputHeightMd = 40.0;
  static const double inputHeightLg = 48.0;
  static const double inputHeightXl = 56.0;

  // App Bar Heights
  static const double appBarHeight = 56.0;
  static const double appBarHeightLarge = 64.0;
  static const double appBarHeightSmall = 48.0;

  // Tab Heights
  static const double tabHeight = 48.0;
  static const double tabHeightSmall = 36.0;

  // Bottom Navigation Heights
  static const double bottomNavHeight = 56.0;
  static const double bottomNavHeightLarge = 64.0;

  // List Item Heights
  static const double listItemHeight = 56.0;
  static const double listItemHeightDense = 48.0;
  static const double listItemHeightLarge = 72.0;

  // Card Dimensions
  static const double cardMinHeight = 120.0;
  static const double cardMaxWidth = 400.0;

  // Dialog Dimensions
  static const double dialogMaxWidth = 400.0;
  static const double dialogMinWidth = 280.0;

  // Bottom Sheet Dimensions
  static const double bottomSheetMaxHeight = 0.85;
  static const double bottomSheetMinHeight = 0.25;

  // Responsive Breakpoints
  static const double breakpointXs = 480.0;
  static const double breakpointSm = 600.0;
  static const double breakpointMd = 840.0;
  static const double breakpointLg = 1200.0;
  static const double breakpointXl = 1600.0;

  // Grid Dimensions
  static const double gridSpacing = spacingMd;
  static const double gridItemMinWidth = 120.0;
  static const double gridItemMaxWidth = 200.0;
  static const double gridItemAspectRatio = 1.0;

  // Divider Dimensions
  static const double dividerThickness = 1.0;
  static const double dividerThicknessBold = 2.0;

  // Border Widths
  static const double borderWidthThin = 1.0;
  static const double borderWidthMedium = 2.0;
  static const double borderWidthThick = 3.0;

  // Animation Durations (in milliseconds)
  static const int animationDurationFast = 150;
  static const int animationDurationNormal = 300;
  static const int animationDurationSlow = 500;

  // Z-Index Values
  static const double zIndexDropdown = 1000;
  static const double zIndexSticky = 1020;
  static const double zIndexFixed = 1030;
  static const double zIndexModal = 1040;
  static const double zIndexPopover = 1050;
  static const double zIndexTooltip = 1060;
  static const double zIndexToast = 1070;

  // Helper Methods
  static EdgeInsets paddingSymmetric({
    double horizontal = 0,
    double vertical = 0,
  }) {
    return EdgeInsets.symmetric(
      horizontal: horizontal,
      vertical: vertical,
    );
  }

  static EdgeInsets paddingOnly({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) {
    return EdgeInsets.only(
      left: left,
      top: top,
      right: right,
      bottom: bottom,
    );
  }

  static BorderRadius borderRadiusOnly({
    double topLeft = 0,
    double topRight = 0,
    double bottomLeft = 0,
    double bottomRight = 0,
  }) {
    return BorderRadius.only(
      topLeft: Radius.circular(topLeft),
      topRight: Radius.circular(topRight),
      bottomLeft: Radius.circular(bottomLeft),
      bottomRight: Radius.circular(bottomRight),
    );
  }

  static double responsive(BuildContext context, {
    double xs = 0,
    double sm = 0,
    double md = 0,
    double lg = 0,
    double xl = 0,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth <= breakpointXs) return xs;
    if (screenWidth <= breakpointSm) return sm;
    if (screenWidth <= breakpointMd) return md;
    if (screenWidth <= breakpointLg) return lg;
    return xl;
  }

  static EdgeInsets responsivePadding(BuildContext context, {
    EdgeInsets xs = EdgeInsets.zero,
    EdgeInsets sm = EdgeInsets.zero,
    EdgeInsets md = EdgeInsets.zero,
    EdgeInsets lg = EdgeInsets.zero,
    EdgeInsets xl = EdgeInsets.zero,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth <= breakpointXs) return xs;
    if (screenWidth <= breakpointSm) return sm;
    if (screenWidth <= breakpointMd) return md;
    if (screenWidth <= breakpointLg) return lg;
    return xl;
  }

  static int responsiveColumns(BuildContext context, {
    int xs = 1,
    int sm = 2,
    int md = 3,
    int lg = 4,
    int xl = 5,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth <= breakpointXs) return xs;
    if (screenWidth <= breakpointSm) return sm;
    if (screenWidth <= breakpointMd) return md;
    if (screenWidth <= breakpointLg) return lg;
    return xl;
  }
}