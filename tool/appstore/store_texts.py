"""Writes the App Store texts into appstore/metadata/<locale>/ (fastlane deliver layout).

usage: python3 tool/appstore/store_texts.py
Edit the texts here, re-run, commit. test/appstore_test.dart checks Apple's length limits (keywords: 100 bytes, to be safe).
App Store Connect locales: en-GB is the primary language; en-US gets the same text.
"""
import os

PAGES = "https://goosalex.github.io/red_panda"
SOURCE = "https://github.com/goosalex/red_panda"

T = {}

T["en"] = dict(
    name="Red Panda: To-dos & Notes",
    subtitle="Quick notes, a happy panda",
    keywords="todo,to-do,notes,reminders,checklist,tasks,voice notes,shopping list,widget,lock screen,errands",
    promotional_text="Jot it down in a second from the Lock Screen, the Action Button or Siri. Tick it off and the panda gets bamboo. No account, no tracking.",
    description="""Red Panda is a to-do and notes app with a panda who is happy when you get things done.

CAPTURE IN A SECOND
• Type or dictate a note: speech becomes text right on your iPhone
• Lock Screen and Control Centre buttons, the Action Button, Siri and widgets
• Share text or links from any app and each line becomes an item

GET THINGS DONE
• Tick items off, swipe to pin, snooze until tomorrow or postpone a deadline
• Deadlines and categories keep the list in order
• Every finished item feeds the panda bamboo; snoozing costs some

REMINDERS THAT HELP
• The panda gets sad as deadlines come closer, gently or persistently, with quiet hours
• Leave basket: things to take along remind you the moment you leave a place or your Wi-Fi drops

YOURS ALONE
• Red Panda collects nothing: no analytics, no advertising, no tracking, no account
• Your notes stay on your device, and in your own iCloud Drive if you switch on sync
• Your location never leaves your iPhone; it is only used for the leave basket
• Open source: anyone can check these promises

Made for iPhone and iPad, in English, French, German, Spanish, Italian, Japanese and Arabic.""",
    release_notes="Red Panda is now on the App Store. Settings > Privacy explains in detail why Red Panda collects nothing.",
)

T["fr"] = dict(
    name="Red Panda : tâches et notes",
    subtitle="Notes rapides, panda heureux",
    keywords="tâches,todo,notes,rappels,liste,courses,checklist,notes vocales,widget,écran verrouillé",
    promotional_text="Notez en une seconde depuis l'écran verrouillé, le bouton Action ou Siri. Cochez, et le panda reçoit du bambou. Sans compte, sans pistage.",
    description="""Red Panda est une app de tâches et de notes avec un panda qui est heureux quand vous avancez.

NOTER EN UNE SECONDE
• Tapez ou dictez une note : la parole devient du texte directement sur votre iPhone
• Boutons de l'écran verrouillé et du Centre de contrôle, bouton Action, Siri et widgets
• Partagez du texte ou des liens depuis n'importe quelle app : chaque ligne devient un élément

AVANCER
• Cochez, balayez pour épingler, reporter à demain ou repousser une échéance
• Échéances et catégories gardent la liste en ordre
• Chaque élément terminé nourrit le panda en bambou ; reporter en coûte un peu

DES RAPPELS UTILES
• Le panda devient triste à l'approche des échéances, doucement ou avec insistance, avec des heures calmes
• Panier de départ : ce qu'il faut emporter vous est rappelé dès que vous quittez un lieu ou que votre Wi-Fi décroche

RIEN QU'À VOUS
• Red Panda ne collecte rien : pas d'analyse, pas de publicité, pas de pistage, pas de compte
• Vos notes restent sur votre appareil, et dans votre propre iCloud Drive si vous activez la synchro
• Votre position ne quitte jamais votre iPhone ; elle ne sert qu'au panier de départ
• Open source : chacun peut vérifier ces promesses

Pour iPhone et iPad, en français, anglais, allemand, espagnol, italien, japonais et arabe.""",
    release_notes="Red Panda arrive sur l'App Store. Réglages > Confidentialité explique en détail pourquoi Red Panda ne collecte rien.",
)

T["de"] = dict(
    name="Red Panda: To-dos & Notizen",
    subtitle="Schnell notiert, Panda froh",
    keywords="todo,aufgaben,notizen,erinnerungen,einkaufsliste,checkliste,sprachnotiz,widget,sperrbildschirm",
    promotional_text="In einer Sekunde notiert, vom Sperrbildschirm, mit der Aktionstaste oder Siri. Abhaken, und der Panda bekommt Bambus. Kein Konto, kein Tracking.",
    description="""Red Panda ist eine To-do- und Notiz-App mit einem Panda, der sich freut, wenn du Dinge erledigst.

IN EINER SEKUNDE NOTIERT
• Tipp oder diktier eine Notiz: Sprache wird direkt auf deinem iPhone zu Text
• Tasten auf dem Sperrbildschirm und im Kontrollzentrum, Aktionstaste, Siri und Widgets
• Teile Text oder Links aus jeder App, und jede Zeile wird ein Eintrag

ERLEDIGEN
• Abhaken, wischen zum Anheften, auf morgen schlummern oder eine Frist verschieben
• Fristen und Kategorien halten die Liste in Ordnung
• Jeder erledigte Eintrag füttert den Panda mit Bambus; Schlummern kostet etwas

ERINNERUNGEN, DIE HELFEN
• Der Panda wird traurig, wenn Fristen näher rücken, sanft oder hartnäckig, mit Ruhezeiten
• Mitnehm-Korb: Was mit muss, meldet sich, sobald du einen Ort verlässt oder dein WLAN wegfällt

NUR DEINS
• Red Panda erfasst nichts: keine Analyse, keine Werbung, kein Tracking, kein Konto
• Deine Notizen bleiben auf deinem Gerät, und in deinem eigenen iCloud Drive, wenn du Sync einschaltest
• Dein Standort verlässt nie dein iPhone; er dient nur dem Mitnehm-Korb
• Open Source: Jede und jeder kann diese Versprechen prüfen

Für iPhone und iPad, auf Deutsch, Englisch, Französisch, Spanisch, Italienisch, Japanisch und Arabisch.""",
    release_notes="Red Panda ist jetzt im App Store. Einstellungen > Datenschutz erklärt genau, warum Red Panda nichts erfasst.",
)

T["es"] = dict(
    name="Red Panda: tareas y notas",
    subtitle="Notas rápidas, panda feliz",
    keywords="tareas,pendientes,notas,recordatorios,lista,compras,checklist,notas de voz,widget,pantalla",
    promotional_text="Anótalo en un segundo desde la pantalla bloqueada, el botón de acción o Siri. Márcalo y el panda recibe bambú. Sin cuenta, sin rastreo.",
    description="""Red Panda es una app de tareas y notas con un panda que se pone feliz cuando terminas cosas.

ANOTA EN UN SEGUNDO
• Escribe o dicta una nota: la voz se convierte en texto en tu iPhone
• Botones de la pantalla bloqueada y del Centro de control, botón de acción, Siri y widgets
• Comparte texto o enlaces desde cualquier app y cada línea se vuelve un elemento

TERMINA LO QUE EMPIEZAS
• Márcalos, desliza para fijar, posponer hasta mañana o mover una fecha límite
• Fechas límite y categorías mantienen la lista en orden
• Cada elemento terminado le da bambú al panda; posponer cuesta un poco

RECORDATORIOS QUE AYUDAN
• El panda se pone triste cuando se acercan las fechas límite, con suavidad o con insistencia, y con horas de silencio
• Canasta de salida: lo que tienes que llevar te avisa en cuanto sales de un lugar o se cae tu Wi-Fi

SOLO TUYO
• Red Panda no recopila nada: sin analíticas, sin publicidad, sin rastreo, sin cuenta
• Tus notas se quedan en tu dispositivo, y en tu propio iCloud Drive si activas la sincronización
• Tu ubicación nunca sale de tu iPhone; solo se usa para la canasta de salida
• Código abierto: cualquiera puede comprobar estas promesas

Para iPhone y iPad, en español, inglés, francés, alemán, italiano, japonés y árabe.""",
    release_notes="Red Panda llega al App Store. Configuración > Privacidad explica en detalle por qué Red Panda no recopila nada.",
)

T["it"] = dict(
    name="Red Panda: promemoria e note",
    subtitle="Note veloci, panda felice",
    keywords="todo,promemoria,note,attività,lista,spesa,checklist,note vocali,widget,schermata di blocco",
    promotional_text="Annota in un secondo dalla schermata di blocco, dal tasto Azione o con Siri. Spunta e il panda riceve bambù. Nessun account, nessun tracciamento.",
    description="""Red Panda è un'app di promemoria e note con un panda che è felice quando porti a termine le cose.

ANNOTA IN UN SECONDO
• Scrivi o detta una nota: il parlato diventa testo direttamente sul tuo iPhone
• Pulsanti della schermata di blocco e del Centro di Controllo, tasto Azione, Siri e widget
• Condividi testo o link da qualsiasi app: ogni riga diventa una voce

PORTA A TERMINE
• Spunta, scorri per fissare in cima, rimandare a domani o spostare una scadenza
• Scadenze e categorie tengono la lista in ordine
• Ogni voce completata dà bambù al panda; rimandare costa un po'

PROMEMORIA CHE AIUTANO
• Il panda si rattrista quando le scadenze si avvicinano, con delicatezza o con insistenza, con ore di silenzio
• Cestino da portare: ciò che devi portare ti avvisa appena lasci un luogo o cade il tuo Wi-Fi

SOLO TUO
• Red Panda non raccoglie nulla: niente analisi, niente pubblicità, niente tracciamento, nessun account
• Le tue note restano sul dispositivo, e nel tuo iCloud Drive se attivi la sincronizzazione
• La tua posizione non lascia mai il tuo iPhone; serve solo al cestino da portare
• Open source: chiunque può verificare queste promesse

Per iPhone e iPad, in italiano, inglese, francese, tedesco, spagnolo, giapponese e arabo.""",
    release_notes="Red Panda arriva sull'App Store. Impostazioni > Privacy spiega nel dettaglio perché Red Panda non raccoglie nulla.",
)

T["ja"] = dict(
    name="Red Panda：ToDoとメモ",
    subtitle="さっとメモ、パンダもにっこり",
    keywords="ToDo,タスク,メモ,リマインダー,買い物,チェックリスト,音声メモ",
    promotional_text="ロック画面、アクションボタン、Siri から一瞬でメモ。チェックすればパンダに竹のごほうび。アカウントもトラッキングもありません。",
    description="""Red Panda は、あなたが用事を片付けると喜ぶパンダのいる ToDo とメモのアプリです。

一瞬でメモ
• 入力でも音声でもメモできます。音声は iPhone 上でテキストに
• ロック画面とコントロールセンターのボタン、アクションボタン、Siri、ウィジェット
• どのアプリからでもテキストやリンクを共有すると、1 行ずつ項目になります

片付ける
• チェックして完了。スワイプでピン留め、明日までスヌーズ、期限の延期
• 期限とカテゴリでリストを整理
• 完了するたびにパンダに竹をあげられます。スヌーズには少し竹が必要です

役に立つリマインダー
• 期限が近づくとパンダが悲しみます。控えめにもしつこくも設定でき、おやすみ時間もあります
• お出かけかご：持っていくものを、その場所を離れたときや Wi-Fi が切れたときに知らせます

あなただけのもの
• Red Panda は何も収集しません。分析、広告、トラッキング、アカウントはありません
• メモはデバイスに保存され、同期をオンにすればあなた自身の iCloud Drive にも保存されます
• 位置情報が iPhone の外に出ることはなく、お出かけかごにだけ使われます
• オープンソース：この約束は誰でも確かめられます

iPhone・iPad 対応。日本語、英語、フランス語、ドイツ語、スペイン語、イタリア語、アラビア語。""",
    release_notes="Red Panda が App Store に登場しました。設定 > プライバシー で、Red Panda が何も収集しない理由を詳しく説明しています。",
)

T["ar"] = dict(
    name="Red Panda: مهام وملاحظات",
    subtitle="ملاحظات بسرعة، باندا مبسوط",
    keywords="مهام,ملاحظات,تذكير,مشتريات,قائمة,ملاحظات صوتية,ودجت",
    promotional_text="سجّلها بثانية من شاشة القفل أو زر الإجراء أو Siri. علّم عليها وبياخد الباندا خيزران. بلا حساب وبلا تتبّع.",
    description="""Red Panda تطبيق مهام وملاحظات مع باندا بينبسط لما تخلّص أشغالك.

سجّل بثانية
• اكتب أو احكي ملاحظة: الكلام بيصير نص على الآيفون تبعك
• أزرار شاشة القفل ومركز التحكم، زر الإجراء، Siri والودجات
• شارك نص أو روابط من أي تطبيق، وكل سطر بيصير بند

خلّص أشغالك
• علّم عالبنود، اسحب لتثبّت، أجّل لبكرا أو أخّر موعد نهائي
• المواعيد والتصنيفات بتخلّي القائمة مرتبة
• كل بند بتخلّصو بيطعمي الباندا خيزران؛ التأجيل بيكلّف شوي

تذكيرات بتساعد
• الباندا بيزعل لما تقرب المواعيد، بلطف أو بإصرار، مع ساعات هدوء
• سلّة الطلعة: الأغراض اللي لازم تاخدها بتذكّرك أول ما تطلع من مكان أو ينقطع الواي فاي

إلك وبس
• Red Panda ما بيجمع ولا شي: ما في تحليلات ولا إعلانات ولا تتبّع ولا حساب
• ملاحظاتك بتضل على جهازك، وعلى iCloud Drive تبعك إذا شغّلت المزامنة
• موقعك أبداً ما بيطلع من الآيفون تبعك؛ بس لسلّة الطلعة
• مفتوح المصدر: أي حدا فيه يتأكد من هالوعود

للآيفون والآيباد، بالعربي والإنكليزي والفرنسي والألماني والإسباني والإيطالي والياباني.""",
    release_notes="Red Panda صار عالـ App Store. الإعدادات < الخصوصية بتشرح بالتفصيل ليش Red Panda ما بيجمع ولا شي.",
)

# App Store Connect locale -> app language.
LOCALES = {"en-GB": "en", "en-US": "en", "fr-FR": "fr", "de-DE": "de", "es-MX": "es",
           "it": "it", "ja": "ja", "ar-SA": "ar"}

root = os.path.join(os.path.dirname(__file__), "..", "..", "appstore", "metadata")
for locale, lang in LOCALES.items():
    d = os.path.join(root, locale)
    os.makedirs(d, exist_ok=True)
    files = dict(T[lang])
    files["privacy_url"] = f"{PAGES}/{lang}/privacy/"
    files["support_url"] = f"{PAGES}/{lang}/support/"
    files["marketing_url"] = SOURCE
    for k, v in files.items():
        with open(os.path.join(d, f"{k}.txt"), "w") as f:
            f.write(v.strip() + "\n")
with open(os.path.join(root, "copyright.txt"), "w") as f:
    f.write("2026 Mas Datos GmbH\n")
print(f"{len(LOCALES)} locales written")
