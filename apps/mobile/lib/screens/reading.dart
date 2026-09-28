import 'dart:async';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../content/catalog.dart';
import '../content/models.dart';
import '../content/references.dart';
import '../content/submenu_icons.dart';
import '../services/appendix_export.dart';
import '../services/reading_store.dart';
import '../services/participant_store.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/export_action.dart';
import 'participant_access.dart';

class TopicListPage extends StatefulWidget {
  const TopicListPage({
    super.key,
    required this.group,
    required this.store,
    this.participants,
  });
  final ContentGroup group;
  final ReadingStore store;
  final ParticipantStore? participants;

  @override
  State<TopicListPage> createState() => _TopicListPageState();
}

class _TopicListPageState extends State<TopicListPage> {
  String query = '';

  @override
  Widget build(BuildContext context) => widget.participants == null
      ? _build(context)
      : ListenableBuilder(
          listenable: widget.participants!,
          builder: (context, _) => _build(context),
        );

  Widget _build(BuildContext context) {
    final group = widget.group;
    final store = widget.store;
    final participants = widget.participants;
    final program = group.id == 'program';
    final currentIndex = group.articles.indexWhere(
      (article) => article.id == store.articleId,
    );
    final active = currentIndex < 0 ? 0 : currentIndex;
    final normalized = query.trim().toLowerCase();
    final articles = normalized.isEmpty
        ? group.articles
        : group.articles.where((article) {
            final text = [
              article.title,
              article.summary,
              for (final section in article.sections) ...[
                section.title,
                ...section.paragraphs,
                ...section.points,
              ],
            ].join(' ').toLowerCase();
            return text.contains(normalized);
          }).toList();
    final theme = Theme.of(context);
    return AppPage(
      title: group.title,
      showTitle: false,
      children: [
        if (program) ...[
          const Eyebrow('PROGRAM DISQAM'),
          const SizedBox(height: 12),
          Text(
            'Pelajari satu sesi\npada satu waktu.',
            style: theme.textTheme.displaySmall,
          ),
          const SizedBox(height: 14),
          const Text(
            'Enam sesi yang saling terhubung.\nPelajari bersama fasilitator, sesuai kondisi Anda.',
          ),
          const SizedBox(height: 24),
          if (participants?.registered == true) ...[
            OutlinedButton.icon(
              onPressed: () => showParticipantCode(context, participants!),
              icon: const Icon(Icons.badge_outlined),
              label: const Text('Lihat kode kepesertaan'),
            ),
            const SizedBox(height: 14),
          ],
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: DisqamColors.surfaceAlt,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Eyebrow('URUTAN SESI'),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (var i = 0; i < 6; i++)
                      Container(
                        width: 36,
                        height: 5,
                        decoration: BoxDecoration(
                          color: i == active
                              ? DisqamColors.primary
                              : const Color(0xFFBEDDDF),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  currentIndex < 0
                      ? 'Mulai dari Sesi 1.'
                      : 'Bacaan terakhir: sesi ${active + 1}.',
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Sebaiknya ikuti sesi secara berurutan, dari sesi I hingga VI. Anda tetap dapat membuka sesi mana pun sesuai kebutuhan.',
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Material(
            color: DisqamColors.surfaceAlt,
            borderRadius: BorderRadius.circular(18),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () => openPage(
                context,
                TopicListPage(group: disqamGroup, store: store),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      'assets/images/icons/program.webp',
                      width: 52,
                      height: 52,
                      fit: BoxFit.contain,
                      excludeFromSemantics: true,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Konsep DISQAM',
                            style: theme.textTheme.titleSmall,
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Kenali prinsip dan komponen Program DISQAM.',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.arrow_forward_rounded,
                      size: 20,
                      color: DisqamColors.primary,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          _MaterialSearchField(
            onChanged: (value) => setState(() => query = value),
          ),
          const SizedBox(height: 18),
          if (articles.isEmpty)
            const InfoBox(
              'Materi yang dicari belum ditemukan. Coba gunakan kata lain.',
              label: 'Hasil pencarian',
            ),
          for (final article in articles) ...[
            Builder(
              builder: (context) {
                final i = group.articles.indexOf(article);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (i == 0 || i == 2 || i == 4) ...[
                      Padding(
                        padding: const EdgeInsets.only(top: 12, bottom: 18),
                        child: Eyebrow(
                          [
                            'KENALI & BANGUN KEBIASAAN',
                            'ATUR WAKTU & PIKIRAN',
                            'RILEKS & PANTAU',
                          ][i ~/ 2],
                        ),
                      ),
                    ],
                    _JourneyStop(
                      article: article,
                      number: i + 1,
                      active: active == i,
                      status: participants
                          ?.session(group.articles[i].id)
                          ?.status,
                      pending:
                          participants?.pending(article.id, 'complete') == true,
                      last: i == 5,
                      onTap: () async {
                        if (!await ensureParticipantAccess(
                              context,
                              participants,
                            ) ||
                            !context.mounted) {
                          return;
                        }
                        openPage(
                          context,
                          ReadingPage(
                            article: article,
                            store: store,
                            participants: participants,
                            initialSection: currentIndex == i
                                ? store.sectionIndex
                                : 0,
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ],
          const SizedBox(height: 20),
          const InfoBox(
            'Mulai mengisi buku harian tidur sejak sesi I bersama fasilitator. Penanda bacaan hanya menunjukkan sesi yang terakhir dibuka, bukan sesi yang telah diselesaikan.',
            label: 'Belajar dengan pendampingan',
          ),
        ] else ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Eyebrow('RUANG BELAJAR'),
                    const SizedBox(height: 12),
                    ForeignTermsText(
                      group.title,
                      style: theme.textTheme.headlineMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Image.asset(
                group.asset,
                width: 82,
                height: 82,
                excludeFromSemantics: true,
              ),
            ],
          ),
          const SizedBox(height: 18),
          ForeignTermsText(group.summary),
          const SizedBox(height: 28),
          Container(
            height: 3,
            width: double.infinity,
            color: DisqamColors.primary,
          ),
          const SizedBox(height: 20),
          _MaterialSearchField(
            onChanged: (value) => setState(() => query = value),
          ),
          const SizedBox(height: 8),
          if (articles.isEmpty)
            const Padding(
              padding: EdgeInsets.only(top: 16),
              child: InfoBox(
                'Materi yang dicari belum ditemukan. Coba gunakan kata lain.',
                label: 'Hasil pencarian',
              ),
            ),
          for (final article in articles)
            MenuCard(
              submenu: true,
              title: article.title,
              subtitle: article.summary,
              asset:
                  submenuIconAsset(article.id) ?? group.singleSectionIconAsset,
              onTap: () => openPage(
                context,
                ReadingPage(article: article, store: store),
              ),
            ),
        ],
      ],
    );
  }
}

class _MaterialSearchField extends StatelessWidget {
  const _MaterialSearchField({required this.onChanged});

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) => TextField(
    onChanged: onChanged,
    textInputAction: TextInputAction.search,
    decoration: const InputDecoration(
      labelText: 'Cari materi',
      hintText: 'Contoh: tidur siang atau relaksasi',
      prefixIcon: Icon(Icons.search_rounded),
    ),
  );
}

class _JourneyStop extends StatelessWidget {
  const _JourneyStop({
    required this.article,
    required this.number,
    required this.active,
    required this.status,
    required this.pending,
    required this.last,
    required this.onTap,
  });
  final Article article;
  final int number;
  final bool active, last;
  final String? status;
  final bool pending;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => IntrinsicHeight(
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          width: 34,
          child: Column(
            children: [
              Container(
                width: 34,
                height: 34,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: active
                      ? const Color(0xFFF3BC58)
                      : DisqamColors.surfaceAlt,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '$number',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: DisqamColors.navy,
                  ),
                ),
              ),
              if (!last)
                Expanded(
                  child: Container(
                    width: 1,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    color: const Color(0xFFBEDDDF),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 22),
            child: Material(
              color: active ? DisqamColors.navy : Colors.white,
              borderRadius: BorderRadius.circular(18),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: onTap,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(
                        color: active
                            ? const Color(0xFFF3BC58)
                            : const Color(0xFF82D1D8),
                        width: 3,
                      ),
                    ),
                  ),
                  padding: active
                      ? const EdgeInsets.all(20)
                      : const EdgeInsets.fromLTRB(16, 16, 14, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (active) ...[
                        const Eyebrow('BUKA PANDUAN', light: true),
                        const SizedBox(height: 12),
                      ],
                      ForeignTermsText(
                        article.title,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: active ? Colors.white : DisqamColors.navy,
                        ),
                      ),
                      if (status != null || pending) ...[
                        const SizedBox(height: 10),
                        Text(
                          pending
                              ? 'Menunggu sinkronisasi'
                              : status == 'completed'
                              ? 'Materi selesai dipelajari'
                              : 'Sedang dipelajari',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: active
                                ? const Color(0xFFF3BC58)
                                : DisqamColors.primary,
                          ),
                        ),
                      ],
                      const SizedBox(height: 8),
                      ForeignTermsText(
                        article.summary,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: active
                              ? const Color(0xFFD8E9EE)
                              : DisqamColors.muted,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Icon(
                        Icons.arrow_forward_rounded,
                        size: 22,
                        color: active
                            ? const Color(0xFFB5E5E9)
                            : DisqamColors.primary,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

class ReadingPage extends StatefulWidget {
  const ReadingPage({
    super.key,
    required this.article,
    required this.store,
    this.participants,
    this.initialSection = 0,
  });
  final Article article;
  final ReadingStore store;
  final ParticipantStore? participants;
  final int initialSection;
  @override
  State<ReadingPage> createState() => _ReadingPageState();
}

class _ReadingPageState extends State<ReadingPage> {
  final _scroll = ScrollController();
  late final List<GlobalKey> _sectionKeys;
  int _index = 0;
  bool _restoring = true;
  bool _savingCompletion = false;
  Timer? _saveTimer;

  @override
  void initState() {
    super.initState();
    _sectionKeys = List.generate(
      widget.article.sections.length,
      (_) => GlobalKey(),
    );
    _index = widget.initialSection.clamp(0, _sectionKeys.length - 1);
    _scroll.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (_index > 0) _jumpToSection(_index);
      unawaited(widget.store.remember(widget.article.id, _index));
      _restoring = false;
      if (widget.article.id.startsWith('session-') &&
          widget.participants?.registered == true) {
        unawaited(widget.participants!.record(widget.article.id, 'open'));
      }
    });
  }

  void _jumpToSection(int index) {
    final target = _sectionKeys[index].currentContext;
    if (target == null) return;
    Scrollable.ensureVisible(target);
    _index = index;
    unawaited(widget.store.remember(widget.article.id, index));
  }

  void _onScroll() {
    if (_restoring || !mounted) return;
    // Locate the section at the top of the actual scroll viewport, including
    // enlarged headers. This is a reading bookmark, not intervention progress.
    final target = _sectionKeys.first.currentContext;
    if (target == null) return;
    final viewport = Scrollable.of(target).context.findRenderObject();
    if (viewport is! RenderBox) return;
    final top = viewport.localToGlobal(Offset.zero).dy + 32;
    var next = 0;
    for (var i = 0; i < _sectionKeys.length; i++) {
      final box = _sectionKeys[i].currentContext?.findRenderObject();
      if (box is RenderBox && box.localToGlobal(Offset.zero).dy <= top) {
        next = i;
      }
    }
    if (next == _index) return;
    _index = next;
    _saveTimer?.cancel();
    _saveTimer = Timer(const Duration(milliseconds: 300), () {
      if (mounted) unawaited(widget.store.remember(widget.article.id, _index));
    });
  }

  @override
  void dispose() {
    if (_saveTimer?.isActive ?? false) {
      final store = widget.store;
      final articleId = widget.article.id;
      final index = _index;
      unawaited(Future<void>.microtask(() => store.remember(articleId, index)));
    }
    _saveTimer?.cancel();
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final article = widget.article;
    final isSession = article.id.startsWith('session-');
    final theme = Theme.of(context);
    final group = contentGroups.firstWhere(
      (group) => group.articles.any((item) => item.id == article.id),
    );
    final articleIndex = group.articles.indexOf(article);
    final showAdjacentNavigation = article.id != 'bibliography';
    final previousArticle = articleIndex > 0
        ? group.articles[articleIndex - 1]
        : null;
    final nextArticle = articleIndex < group.articles.length - 1
        ? group.articles[articleIndex + 1]
        : null;
    final sessionProgress = widget.participants?.session(article.id);
    final references = articleReferences[article.id] ?? const <ReadingLink>[];
    final completionPending =
        widget.participants?.pending(article.id, 'complete') == true;
    return AppPage(
      controller: _scroll,
      title: article.title,
      showTitle: false,
      children: [
        Eyebrow(isSession ? 'PANDUAN PROGRAM' : 'RUANG BELAJAR'),
        const SizedBox(height: 12),
        Semantics(
          header: true,
          child: ForeignTermsText(
            article.title,
            style: theme.textTheme.headlineMedium,
          ),
        ),
        const SizedBox(height: 22),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: DisqamColors.surfaceAlt,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            children: [
              Image.asset(
                isSession ? 'assets/images/mark.webp' : group.asset,
                width: 64,
                height: 64,
                excludeFromSemantics: true,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ForeignTermsText(
                  article.summary,
                  style: theme.textTheme.titleSmall,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        ExpansionTile(
          key: const ValueKey('reading-contents'),
          tilePadding: EdgeInsets.zero,
          title: const Text('Daftar isi'),
          subtitle: Text(
            'Baca dengan menggulir atau pilih bagian yang ingin dibuka.',
            style: theme.textTheme.bodySmall,
          ),
          shape: const Border(),
          collapsedShape: const Border(),
          children: [
            for (var i = 0; i < article.sections.length; i++)
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  key: ValueKey('reading-jump-$i'),
                  onPressed: () => _jumpToSection(i),
                  child: ForeignTermsText(
                    '${i + 1}. ${article.sections[i].title}',
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 30),
        for (final paragraph in article.openingParagraphs) ...[
          ForeignTermsText(paragraph, style: theme.textTheme.bodyLarge),
          const SizedBox(height: 20),
        ],
        for (var i = 0; i < article.sections.length; i++)
          _ArticleSection(
            key: _sectionKeys[i],
            section: article.sections[i],
            number: i + 1,
            isSession: isSession,
            singleSectionIconAsset: article.sections.length == 1
                ? group.singleSectionIconAsset
                : null,
          ),
        for (final paragraph in article.closingParagraphs) ...[
          ForeignTermsText(paragraph, style: theme.textTheme.bodyLarge),
          const SizedBox(height: 20),
        ],
        if (isSession && widget.participants != null) ...[
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: sessionProgress?.completed == true
                  ? DisqamColors.surfaceAlt
                  : Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: DisqamColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  sessionProgress?.completed == true
                      ? 'Materi ini selesai dipelajari'
                      : completionPending
                      ? 'Menunggu sinkronisasi'
                      : 'Sudah selesai membaca?',
                  style: theme.textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  sessionProgress?.completed == true
                      ? 'Anda tetap dapat membaca kembali sesi ini kapan saja.'
                      : completionPending
                      ? 'Penanda akan disimpan ketika koneksi tersedia.'
                      : 'Tandai setelah seluruh materi sesi ini selesai Anda pelajari.',
                ),
                if (sessionProgress?.completed != true &&
                    !completionPending) ...[
                  const SizedBox(height: 18),
                  FilledButton.icon(
                    onPressed: _savingCompletion
                        ? null
                        : () async {
                            setState(() => _savingCompletion = true);
                            final synced = await widget.participants!.record(
                              article.id,
                              'complete',
                            );
                            if (!context.mounted) return;
                            setState(() => _savingCompletion = false);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  synced
                                      ? 'Materi ditandai selesai dipelajari.'
                                      : 'Penanda disimpan dan akan disinkronkan saat koneksi tersedia.',
                                ),
                              ),
                            );
                          },
                    icon: _savingCompletion
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.check_rounded),
                    label: const Text('Tandai selesai dipelajari'),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 26),
        ],
        if (article.primaryActionArticleId != null) ...[
          FilledButton.icon(
            onPressed: () async {
              final target = findArticle(article.primaryActionArticleId);
              if (target == null ||
                  !await ensureParticipantAccess(context, widget.participants) ||
                  !context.mounted) {
                return;
              }
              openPage(
                context,
                ReadingPage(
                  article: target,
                  store: widget.store,
                  participants: widget.participants,
                ),
              );
            },
            icon: const Icon(Icons.arrow_forward_rounded),
            label: Text(article.primaryActionLabel ?? 'Lanjutkan'),
          ),
          const SizedBox(height: 26),
        ],
        ExpansionTile(
          tilePadding: EdgeInsets.zero,
          childrenPadding: const EdgeInsets.only(bottom: 16),
          title: Text('Rujukan materi', style: theme.textTheme.bodySmall),
          shape: const Border(),
          collapsedShape: const Border(),
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Sumber: ${article.source}',
                style: theme.textTheme.bodySmall,
              ),
            ),
            for (final reference in references) ...[
              const SizedBox(height: 10),
              _ReferenceButton(reference: reference),
            ],
          ],
        ),
        if (showAdjacentNavigation &&
            (previousArticle != null || nextArticle != null)) ...[
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 24),
          if (previousArticle != null) ...[
            _ReadingNavigationButton(
              article: previousArticle,
              direction: _ReadingDirection.previous,
              onPressed: () => _replaceReading(previousArticle),
            ),
            if (nextArticle != null) const SizedBox(height: 12),
          ],
          if (nextArticle != null)
            _ReadingNavigationButton(
              article: nextArticle,
              direction: _ReadingDirection.next,
              onPressed: () => _replaceReading(nextArticle),
            ),
        ],
        const SizedBox(height: 20),
        OutlinedButton.icon(
          onPressed: () => _scroll.jumpTo(0),
          icon: const Icon(Icons.arrow_upward_rounded),
          label: const Text('Kembali ke awal bacaan'),
        ),
      ],
    );
  }

  void _replaceReading(Article article) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => ReadingPage(
          article: article,
          store: widget.store,
          participants: widget.participants,
        ),
      ),
    );
  }
}

enum _ReadingDirection { previous, next }

class _ReadingNavigationButton extends StatelessWidget {
  const _ReadingNavigationButton({
    required this.article,
    required this.direction,
    required this.onPressed,
  });

  final Article article;
  final _ReadingDirection direction;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final previous = direction == _ReadingDirection.previous;
    final foreground = previous ? DisqamColors.navy : Colors.white;
    final content = Row(
      children: [
        if (previous) ...[
          Icon(Icons.arrow_back_rounded, color: foreground),
          const SizedBox(width: 12),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: previous
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.end,
            children: [
              Text(
                previous ? 'Baca sebelumnya' : 'Baca selanjutnya',
                style: TextStyle(
                  color: foreground,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              ForeignTermsText(
                article.title,
                textAlign: previous ? TextAlign.left : TextAlign.right,
                style: Theme.of(context).textTheme.bodySmall
                    ?.copyWith(color: foreground, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        if (!previous) ...[
          const SizedBox(width: 12),
          Icon(Icons.arrow_forward_rounded, color: foreground),
        ],
      ],
    );

    return SizedBox(
      width: double.infinity,
      child: previous
          ? OutlinedButton(onPressed: onPressed, child: content)
          : FilledButton(onPressed: onPressed, child: content),
    );
  }
}

class _ArticleSection extends StatelessWidget {
  const _ArticleSection({
    super.key,
    required this.section,
    required this.number,
    required this.isSession,
    this.singleSectionIconAsset,
  });
  final ReadingSection section;
  final int number;
  final bool isSession;
  final String? singleSectionIconAsset;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final steps =
        isSession &&
        (section.title.contains('Langkah') ||
            section.title.contains('Latihan napas') ||
            section.title.contains('KENALI'));
    return Padding(
      padding: const EdgeInsets.only(bottom: 36),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (number > 1) ...[const Divider(), const SizedBox(height: 28)],
          if (singleSectionIconAsset != null)
            Align(
              alignment: Alignment.centerLeft,
              child: Image.asset(
                singleSectionIconAsset!,
                width: 56,
                height: 56,
                fit: BoxFit.contain,
                semanticLabel: 'Ikon ${section.title}',
              ),
            )
          else
            Text(
              '$number'.padLeft(2, '0'),
              style: const TextStyle(
                fontSize: 32,
                height: 1,
                fontWeight: FontWeight.w500,
                color: DisqamColors.primary,
              ),
            ),
          const SizedBox(height: 12),
          Semantics(
            header: true,
            child: ForeignTermsText(
              section.title,
              style: theme.textTheme.titleLarge,
            ),
          ),
          const SizedBox(height: 20),
          for (final paragraph in section.paragraphs) ...[
            ForeignTermsText(paragraph, style: theme.textTheme.bodyLarge),
            const SizedBox(height: 20),
          ],
          for (var i = 0; i < section.points.length; i++)
            PointText(section.points[i], number: steps ? i + 1 : null),
          for (final paragraph in section.afterPoints) ...[
            ForeignTermsText(paragraph, style: theme.textTheme.bodyLarge),
            const SizedBox(height: 20),
          ],
          for (final subsection in section.subsections) ...[
            Text(
              subsection.title,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            for (final paragraph in subsection.paragraphs) ...[
              ForeignTermsText(paragraph, style: theme.textTheme.bodyLarge),
              const SizedBox(height: 20),
            ],
            for (final point in subsection.points) PointText(point),
            for (final paragraph in subsection.afterPoints) ...[
              ForeignTermsText(paragraph, style: theme.textTheme.bodyLarge),
              const SizedBox(height: 20),
            ],
            for (final media in subsection.media) ...[
              const SizedBox(height: 10),
              _ReadingImage(media: media),
              const SizedBox(height: 14),
            ],
            for (final table in subsection.tables) ...[
              const SizedBox(height: 10),
              _ReadingTableView(table: table),
              const SizedBox(height: 14),
            ],
            if (subsection.note != null) ...[
              const SizedBox(height: 8),
              InfoBox(
                subsection.note!,
                warm: true,
                label: subsection.noteLabel,
              ),
              const SizedBox(height: 20),
            ],
          ],
          if (section.callout != null) ...[
            InfoBox(section.callout!, label: section.calloutLabel),
            const SizedBox(height: 20),
          ],
          for (final media in section.media) ...[
            const SizedBox(height: 10),
            _ReadingImage(media: media),
            const SizedBox(height: 14),
          ],
          for (final table in section.tables) ...[
            const SizedBox(height: 10),
            _ReadingTableView(table: table),
            const SizedBox(height: 14),
          ],
          for (final example in section.communicationExamples) ...[
            _CommunicationExampleCard(example: example),
            const SizedBox(height: 14),
          ],
          for (final link in section.links) ...[
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: () => launchUrl(
                  Uri.parse(link.url),
                  mode: LaunchMode.externalApplication,
                ),
                icon: const Icon(Icons.open_in_new_rounded),
                label: ForeignTermsText(link.label),
              ),
            ),
          ],
          if (section.note != null) ...[
            const SizedBox(height: 8),
            InfoBox(
              section.note!,
              warm: true,
              label: section.noteLabel ?? 'Perlu diingat',
            ),
          ],
        ],
      ),
    );
  }
}

class _CommunicationExampleCard extends StatelessWidget {
  const _CommunicationExampleCard({required this.example});

  final CommunicationExample example;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: DisqamColors.border),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _CommunicationLabel(
          icon: Icons.do_not_disturb_on_outlined,
          label: 'Hindari',
          color: DisqamColors.danger,
        ),
        const SizedBox(height: 8),
        ForeignTermsText(
          example.avoid,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Divider(height: 1),
        ),
        const _CommunicationLabel(
          icon: Icons.check_circle_outline_rounded,
          label: 'Gunakan',
          color: DisqamColors.success,
        ),
        const SizedBox(height: 8),
        ForeignTermsText(
          example.use,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    ),
  );
}

class _CommunicationLabel extends StatelessWidget {
  const _CommunicationLabel({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Icon(icon, size: 22, color: color),
      const SizedBox(width: 8),
      Expanded(
        child: Text(
          label,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(color: color),
        ),
      ),
    ],
  );
}

class _ReadingTableView extends StatefulWidget {
  const _ReadingTableView({required this.table});

  final ReadingTable table;

  @override
  State<_ReadingTableView> createState() => _ReadingTableViewState();
}

class _ReadingTableViewState extends State<_ReadingTableView> {
  bool _exporting = false;

  @override
  Widget build(BuildContext context) {
    final table = widget.table;
    final wide = table.headers.length > 2;
    final displayTitle = table.title.replaceFirst(
      RegExp(
        r'^(?:Tabel\s+\d+(?:\.\d+)?|Lampiran\s+\d+)\s*[^A-Za-z0-9]*\s*',
      ),
      '',
    );
    final tableWidget = Table(
      defaultColumnWidth: const FlexColumnWidth(),
      columnWidths: wide || table.headers.length != 2
          ? null
          : const {0: FlexColumnWidth(2), 1: FlexColumnWidth(3)},
      border: const TableBorder(
        top: BorderSide(color: DisqamColors.border),
        horizontalInside: BorderSide(color: DisqamColors.border),
        verticalInside: BorderSide(color: DisqamColors.border),
      ),
      children: [
        TableRow(
          decoration: const BoxDecoration(color: DisqamColors.surfaceAlt),
          children: [
            for (final header in table.headers)
              _TableCellText(header, header: true),
          ],
        ),
        for (final row in table.rows)
          TableRow(
            children: [
              for (var i = 0; i < table.headers.length; i++)
                _TableCellText(i < row.length ? row[i] : ''),
            ],
          ),
      ],
    );
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: DisqamColors.border),
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
            child: ForeignTermsText(
              displayTitle,
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          if (table.headers.length > 2)
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 10),
              child: Text('Geser tabel ke samping untuk melihat semua kolom.'),
            ),
          if (wide)
            LayoutBuilder(
              builder: (context, constraints) {
                final minimumWidth = table.headers.length * 150.0;
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: constraints.maxWidth > minimumWidth
                        ? constraints.maxWidth
                        : minimumWidth,
                    child: tableWidget,
                  ),
                );
              },
            )
          else
            tableWidget,
          if (table.note != null)
            Padding(
              padding: const EdgeInsets.all(16),
              child: ForeignTermsText(
                table.note!,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          if (table.exportable) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16),
              child: FilledButton.tonalIcon(
                onPressed: _exporting ? null : _export,
                icon: _exporting
                    ? const SizedBox.square(
                        dimension: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.table_view_rounded),
                label: Text(_exporting ? 'Menyiapkan Excel…' : 'Unduh Excel'),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _export() async {
    setState(() => _exporting = true);
    try {
      final file = AppendixExport.build(widget.table);
      if (!mounted) return;
      await chooseExportAction(
        context: context,
        filename: file.filename,
        bytes: file.bytes,
        mimeType:
            'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
        share: () => AppendixExport.share(widget.table),
      );
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Berkas belum berhasil dibuat. Silakan coba lagi.'),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _exporting = false);
    }
  }
}

class _ReferenceButton extends StatelessWidget {
  const _ReferenceButton({required this.reference});

  final ReadingLink reference;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    child: OutlinedButton(
      onPressed: () => launchUrl(
        Uri.parse(reference.url),
        mode: LaunchMode.externalApplication,
      ),
      child: Row(
        children: [
          const Icon(Icons.open_in_new_rounded),
          const SizedBox(width: 10),
          Expanded(child: ForeignTermsText(reference.label)),
        ],
      ),
    ),
  );
}

class _TableCellText extends StatelessWidget {
  const _TableCellText(this.value, {this.header = false});

  final String value;
  final bool header;

  @override
  Widget build(BuildContext context) => Container(
    constraints: const BoxConstraints(minHeight: 54),
    alignment: Alignment.centerLeft,
    padding: const EdgeInsets.all(12),
    child: ForeignTermsText(
      value.isEmpty ? ' ' : value,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
        color: header ? DisqamColors.navy : DisqamColors.text,
        fontWeight: header ? FontWeight.w700 : FontWeight.w400,
      ),
    ),
  );
}

class _ReadingImage extends StatelessWidget {
  const _ReadingImage({required this.media});

  final ReadingMedia media;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '${media.alt}. Ketuk untuk memperbesar gambar.',
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => _showExpanded(context),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: DisqamColors.border),
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    media.asset,
                    fit: BoxFit.contain,
                    semanticLabel: media.alt,
                  ),
                ),
                if (media.caption != null) ...[
                  const SizedBox(height: 12),
                  ForeignTermsText(
                    media.caption!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: DisqamColors.navy,
                    ),
                  ),
                ],
                const SizedBox(height: 6),
                const Row(
                  children: [
                    Icon(
                      Icons.zoom_in_rounded,
                      size: 22,
                      color: DisqamColors.primary,
                    ),
                    SizedBox(width: 8),
                    Expanded(child: Text('Ketuk untuk memperbesar gambar')),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showExpanded(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (dialogContext) => Dialog.fullscreen(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
                child: Row(
                  children: [
                    if (media.caption != null)
                      Expanded(
                        child: ForeignTermsText(
                          media.caption!,
                          style: Theme.of(dialogContext).textTheme.titleSmall,
                        ),
                      )
                    else
                      const Spacer(),
                    TextButton.icon(
                      onPressed: () => Navigator.pop(dialogContext),
                      icon: const Icon(Icons.close_rounded),
                      label: const Text('Tutup'),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: InteractiveViewer(
                  minScale: 0.8,
                  maxScale: 5,
                  child: Center(
                    child: Image.asset(
                      media.asset,
                      fit: BoxFit.contain,
                      semanticLabel: media.alt,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
