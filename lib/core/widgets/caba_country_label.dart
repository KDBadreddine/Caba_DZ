import 'package:flutter/material.dart';
import '../../app/theme.dart';
import '../utils/country_flag.dart';
import 'caba_network_image.dart';

class CabaCountryLabel extends StatelessWidget {
  final String name;
  final String? iso;
  final int? countryId;
  final TextStyle? style;
  final int maxLines;
  final TextOverflow overflow;
  final double flagWidth;
  final double flagHeight;
  final bool expanded;

  const CabaCountryLabel({
    super.key,
    required this.name,
    this.iso,
    this.countryId,
    this.style,
    this.maxLines = 1,
    this.overflow = TextOverflow.ellipsis,
    this.flagWidth = 22,
    this.flagHeight = 16,
    this.expanded = false,
  });

  @override
  Widget build(BuildContext context) {
    final iso2 = countryIso2(iso: iso, countryId: countryId, name: name);
    final text = Text(
      name,
      style: style,
      maxLines: maxLines,
      overflow: overflow,
    );
    return Row(
      mainAxisSize: expanded ? MainAxisSize.max : MainAxisSize.min,
      children: [
        if (iso2 != null) ...[
          CabaNetworkImage(
            url: flagImageUrl(iso2),
            width: flagWidth,
            height: flagHeight,
            fit: BoxFit.cover,
            borderRadius: BorderRadius.circular(3),
            fallback: SizedBox(
              width: flagWidth,
              height: flagHeight,
              child: Center(
                child: Text(
                  iso2ToEmoji(iso2),
                  style: TextStyle(fontSize: flagHeight - 1, height: 1),
                ),
              ),
            ),
          ),
          const SizedBox(width: 6),
        ],
        if (expanded) Expanded(child: text) else text,
      ],
    );
  }
}

class CabaRouteLabel extends StatelessWidget {
  final String from;
  final String to;
  final String? fromIso;
  final String? toIso;
  final int? fromCountryId;
  final int? toCountryId;
  final TextStyle? style;

  const CabaRouteLabel({
    super.key,
    required this.from,
    required this.to,
    this.fromIso,
    this.toIso,
    this.fromCountryId,
    this.toCountryId,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: CabaCountryLabel(
            name: from,
            iso: fromIso,
            countryId: fromCountryId,
            style: style,
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 6),
          child: Icon(
            Icons.arrow_back_rounded,
            size: 14,
            color: AppColors.primary,
          ),
        ),
        Flexible(
          child: CabaCountryLabel(
            name: to,
            iso: toIso,
            countryId: toCountryId,
            style: style,
          ),
        ),
      ],
    );
  }
}
