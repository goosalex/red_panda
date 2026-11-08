/// What's new, newest first: Settings > Panda > News. Keep each line short;
/// add an entry (and bump pubspec.yaml) with every pull request.
///
/// Every line is written in all app languages (en, fr, de, es, it, ja, ar;
/// see lib/l10n/l10n.dart); [NewsEntry.itemsIn] falls back to English.
class NewsEntry {
  const NewsEntry(this.version, this.pr, this.items);
  final String version;
  final int pr;

  /// One map per line: language code → text.
  final List<Map<String, String>> items;

  String get url => 'https://github.com/goosalex/red_panda/pull/$pr';

  /// The lines in [lang] (a language code such as `de`), English where a
  /// translation is missing.
  List<String> itemsIn(String lang) => [for (final i in items) i[lang] ?? i['en']!];
}

const news = [
  NewsEntry('0.6.0', 10, [
    {
      'en': 'Red Panda now runs natively on iPad: normal-sized text, more notes on screen, in a centred column',
      'fr': "Red Panda fonctionne nativement sur iPad : texte de taille normale, plus de notes à l'écran, dans une colonne centrée",
      'de': 'Red Panda läuft jetzt nativ auf dem iPad: normal große Schrift, mehr Notizen auf dem Bildschirm, in einer mittigen Spalte',
      'es': 'Red Panda ahora funciona de forma nativa en iPad: texto de tamaño normal y más notas en pantalla, en una columna centrada',
      'it': 'Red Panda ora funziona in modo nativo su iPad: testo di dimensioni normali, più note sullo schermo, in una colonna centrata',
      'ja': 'Red PandaがiPadにネイティブ対応：文字は通常サイズで、中央の列により多くのメモを表示',
      'ar': 'Red Panda صار يشتغل عالآيباد مباشرة: خط بحجمه الطبيعي وملاحظات أكتر عالشاشة، بعمود بالنص',
    },
    {
      'en': 'On iPad, Quick capture no longer mentions the Action Button',
      'fr': "Sur iPad, Capture rapide ne mentionne plus le bouton Action",
      'de': 'Auf dem iPad erwähnt „Schnell notieren“ die Aktionstaste nicht mehr',
      'es': 'En iPad, Captura rápida ya no menciona el botón de acción',
      'it': 'Su iPad, Cattura rapida non menziona più il tasto Azione',
      'ja': 'iPadではクイックキャプチャにアクションボタンが表示されなくなりました',
      'ar': 'عالآيباد، التسجيل السريع ما عاد يذكر زر الإجراءات',
    },
  ]),
  NewsEntry('0.5.1', 9, [
    {
      'en': 'Walkthroughs for adding the widgets to the Lock Screen and Home Screen',
      'fr': "Des guides animés pour ajouter les widgets à l'écran verrouillé et à l'écran d'accueil",
      'de': 'Animierte Anleitungen, um die Widgets auf Sperr- und Home-Bildschirm zu legen',
      'es': 'Guías animadas para agregar los widgets a la pantalla bloqueada y de inicio',
      'it': 'Guide animate per aggiungere i widget alla schermata di blocco e alla Home',
      'ja': 'ロック画面とホーム画面にウィジェットを追加する手順アニメーション',
      'ar': 'شروحات متحركة لتضيف الأدوات على شاشة القفل والشاشة الرئيسية',
    },
  ]),
  NewsEntry('0.5.0', 8, [
    {
      'en': 'Blue links to iOS Settings show the way there with a short animation, in your language',
      'fr': 'Les liens bleus vers Réglages montrent le chemin en une courte animation, dans votre langue',
      'de': 'Blaue Links zu den Einstellungen zeigen den Weg dorthin als kurze Animation, in deiner Sprache',
      'es': 'Los enlaces azules a Configuración muestran el camino con una animación corta, en tu idioma',
      'it': 'I link blu alle Impostazioni mostrano la strada con una breve animazione, nella tua lingua',
      'ja': '青いリンクから、設定までの道順を短いアニメーションでご案内（各言語対応）',
      'ar': 'الروابط الزرقا للإعدادات بتفرجيك الطريق بأنيميشن قصير، بلغتك',
    },
  ]),
  NewsEntry('0.4.0', 7, [
    {
      'en': 'Red Panda speaks French, German, Spanish, Italian, Japanese and Arabic',
      'fr': 'Red Panda parle français, allemand, espagnol, italien, japonais et arabe',
      'de': 'Red Panda spricht jetzt Französisch, Deutsch, Spanisch, Italienisch, Japanisch und Arabisch',
      'es': 'Red Panda ahora habla francés, alemán, español, italiano, japonés y árabe',
      'it': 'Red Panda ora parla francese, tedesco, spagnolo, italiano, giapponese e arabo',
      'ja': 'Red Pandaがフランス語・ドイツ語・スペイン語・イタリア語・日本語・アラビア語に対応しました',
      'ar': 'Red Panda صار يحكي فرنسي وألماني وإسباني وإيطالي وياباني وعربي',
    },
  ]),
  NewsEntry('0.3.2', 6, [
    {
      'en': 'The Undo bar goes away after 5 seconds',
      'fr': 'La barre Annuler disparaît après 5 secondes',
      'de': 'Die Rückgängig-Leiste verschwindet nach 5 Sekunden',
      'es': 'La barra Deshacer desaparece después de 5 segundos',
      'it': 'La barra Annulla sparisce dopo 5 secondi',
      'ja': '「取り消す」バーが5秒で消えるように',
      'ar': 'شريط التراجع بيختفي بعد 5 ثواني',
    },
    {
      'en': 'Twinkling stars next to the moon',
      'fr': 'Des étoiles qui scintillent près de la lune',
      'de': 'Funkelnde Sterne neben dem Mond',
      'es': 'Estrellas que titilan junto a la luna',
      'it': 'Stelle scintillanti accanto alla luna',
      'ja': '月のそばにきらめく星',
      'ar': 'نجوم عم تلمع جنب القمر',
    },
  ]),
  NewsEntry('0.3.1', 5, [
    {
      'en': 'Widgets count notes shared from other apps straight away',
      'fr': "Les widgets comptent tout de suite les notes partagées depuis d'autres apps",
      'de': 'Widgets zählen aus anderen Apps geteilte Notizen sofort mit',
      'es': 'Los widgets cuentan al instante las notas compartidas desde otras apps',
      'it': 'I widget contano subito le note condivise da altre app',
      'ja': 'ほかのAppから共有したメモをウィジェットがすぐに数えるように',
      'ar': 'الأدوات بتعدّ الملاحظات المشاركة من تطبيقات تانية فورًا',
    },
  ]),
  NewsEntry('0.3.0', 4, [
    {
      'en': 'iCloud sync across your devices',
      'fr': 'Synchro iCloud entre vos appareils',
      'de': 'iCloud-Sync zwischen deinen Geräten',
      'es': 'Sincronización con iCloud entre tus dispositivos',
      'it': 'Sincronizzazione iCloud tra i tuoi dispositivi',
      'ja': 'デバイス間のiCloud同期',
      'ar': 'مزامنة iCloud بين أجهزتك',
    },
    {
      'en': "Panda's basket: control, Siri and widget button",
      'fr': 'Panier du panda : commande, Siri et bouton de widget',
      'de': 'Pandas Korb: Steuerelement, Siri und Widget-Taste',
      'es': 'Canasta del panda: control, Siri y botón de widget',
      'it': 'Cestino del panda: controllo, Siri e pulsante del widget',
      'ja': 'パンダのかご：コントロール、Siri、ウィジェットのボタン',
      'ar': 'سلّة الباندا: عنصر تحكم وSiri وزر بالأداة',
    },
    {
      'en': 'Panda glyphs on the note and voice buttons',
      'fr': 'Des pandas sur les boutons note et voix',
      'de': 'Panda-Symbole auf den Notiz- und Sprachtasten',
      'es': 'Pandas en los botones de nota y de voz',
      'it': 'Panda sui pulsanti nota e voce',
      'ja': 'メモと音声のボタンにパンダのマーク',
      'ar': 'رسمة باندا على أزرار الملاحظة والصوت',
    },
    {
      'en': 'Why "Always" location is needed, explained',
      'fr': 'Pourquoi la position « Toujours » est nécessaire, expliqué',
      'de': 'Erklärt: Warum der Standort „Immer“ nötig ist',
      'es': 'Explicamos por qué hace falta la ubicación “Siempre”',
      'it': 'Spiegato perché serve la posizione “Sempre”',
      'ja': '位置情報を「常に」にする理由を説明',
      'ar': 'شرح ليش لازم الموقع يكون "دائمًا"',
    },
    {
      'en': 'Quick capture: previews and settings links',
      'fr': 'Capture rapide : aperçus et liens vers les réglages',
      'de': 'Schnell notieren: Vorschauen und Links zu den Einstellungen',
      'es': 'Captura rápida: vistas previas y enlaces a la configuración',
      'it': 'Cattura rapida: anteprime e link alle impostazioni',
      'ja': 'クイックキャプチャ：プレビューと設定へのリンク',
      'ar': 'تسجيل سريع: معاينات وروابط للإعدادات',
    },
    {
      'en': 'This News page',
      'fr': 'Cette page Nouveautés',
      'de': 'Diese Neuigkeiten-Seite',
      'es': 'Esta página de Novedades',
      'it': 'Questa pagina Novità',
      'ja': 'この新機能ページ',
      'ar': 'هالصفحة: شو الجديد',
    },
  ]),
  NewsEntry('0.2.1', 3, [
    {
      'en': 'One-line settings',
      'fr': 'Réglages sur une ligne',
      'de': 'Einstellungen in einer Zeile',
      'es': 'Configuración en una línea',
      'it': 'Impostazioni su una riga',
      'ja': '1行ずつの設定',
      'ar': 'إعدادات بسطر واحد',
    },
    {
      'en': 'Shortcuts links for Wi-Fi and place automations',
      'fr': 'Liens Raccourcis pour les automatisations Wi-Fi et lieu',
      'de': 'Kurzbefehle-Links für WLAN- und Ort-Automationen',
      'es': 'Enlaces a Atajos para automatizaciones de Wi-Fi y lugar',
      'it': 'Link a Comandi rapidi per le automazioni Wi-Fi e posto',
      'ja': 'Wi-Fiと場所のオートメーション用のショートカットリンク',
      'ar': 'روابط الاختصارات لأتمتة الواي فاي والمحل',
    },
  ]),
  NewsEntry('0.2.0', 2, [
    {
      'en': 'Share text into Red Panda',
      'fr': 'Partager du texte vers Red Panda',
      'de': 'Text an Red Panda teilen',
      'es': 'Compartir texto con Red Panda',
      'it': 'Condividi testo con Red Panda',
      'ja': 'テキストをRed Pandaに共有',
      'ar': 'شارك نص مع Red Panda',
    },
    {
      'en': 'Leave basket reminders',
      'fr': 'Rappels du panier de départ',
      'de': 'Erinnerungen aus dem Mitnehm-Korb',
      'es': 'Recordatorios de la canasta de salida',
      'it': 'Promemoria del cestino da portare',
      'ja': 'お出かけかごのリマインダー',
      'ar': 'تذكيرات سلّة الطلعة',
    },
  ]),
];
