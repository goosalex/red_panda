"""Fills Red Panda's App Group folder with sample notes for the App Store screenshots.

usage: SHOT_TIME=09:41 python3 tool/screenshots/seed.py <app group folder> <lang>
Dates are relative to today at SHOT_TIME (the time the screenshot build shows,
see lib/platform/clock.dart), so the list looks the same whenever it is shot.
"""
import json
import os
import shutil
import sys
from datetime import datetime, timedelta, timezone

root, lang = sys.argv[1], sys.argv[2]

CATS = {  # id: (colour, {lang: name})
    "home": (0xFF4CAF50, dict(en="Home", fr="Maison", de="Zuhause", es="Casa", it="Casa", ja="家", ar="البيت")),
    "work": (0xFF2196F3, dict(en="Work", fr="Travail", de="Arbeit", es="Trabajo", it="Lavoro", ja="仕事", ar="الشغل")),
    "shop": (0xFFFF9800, dict(en="Shopping", fr="Courses", de="Einkauf", es="Compras", it="Spesa", ja="買い物", ar="مشتريات")),
}

# (text per language, category, due in days or None, done, leave basket)
NOTES = [
    (dict(en="Book the train to Lyon", fr="Réserver le train pour Lyon", de="Zug nach Lyon buchen",
          es="Reservar el tren a Guadalajara", it="Prenotare il treno per Torino", ja="京都行きの新幹線を予約",
          ar="احجز تذكرة الباص لطرابلس"), "work", 0, False, False),
    (dict(en="Call Grandma for her birthday", fr="Appeler Mamie pour son anniversaire", de="Oma zum Geburtstag anrufen",
          es="Llamar a la abuela por su cumpleaños", it="Chiamare la nonna per il compleanno", ja="おばあちゃんに誕生日の電話",
          ar="اتصل بتيتا بعيد ميلادها"), "home", 1, False, False),
    (dict(en="Send the slides to Sam", fr="Envoyer les diapos à Camille", de="Folien an Jonas schicken",
          es="Mandar las diapositivas a Sofía", it="Mandare le slide a Giulia", ja="佐藤さんにスライドを送る",
          ar="ابعت السلايدات لرامي"), "work", 2, False, False),
    (dict(en="Return the library books", fr="Rendre les livres à la bibliothèque", de="Bücher in die Bibliothek bringen",
          es="Devolver los libros a la biblioteca", it="Riportare i libri in biblioteca", ja="図書館に本を返す",
          ar="رجّع كتب المكتبة"), None, None, False, True),
    (dict(en="Umbrella", fr="Parapluie", de="Regenschirm", es="Paraguas", it="Ombrello", ja="傘", ar="شمسية"),
     None, None, False, True),
    (dict(en="Oat milk, bananas, coffee", fr="Lait d'avoine, bananes, café", de="Hafermilch, Bananen, Kaffee",
          es="Leche de avena, plátanos, café", it="Latte d'avena, banane, caffè", ja="オーツミルク、バナナ、コーヒー",
          ar="حليب شوفان، موز، قهوة"), "shop", None, False, False),
    (dict(en="Water the plants", fr="Arroser les plantes", de="Pflanzen gießen", es="Regar las plantas",
          it="Annaffiare le piante", ja="植物に水やり", ar="اسقي الزريعة"), "home", 4, False, False),
    (dict(en="Renew the bike insurance", fr="Renouveler l'assurance du vélo", de="Velo-Versicherung verlängern",
          es="Renovar el seguro de la bici", it="Rinnovare l'assicurazione della bici", ja="自転車保険を更新",
          ar="جدّد تأمين البسكليت"), None, 9, False, False),
    (dict(en="Pay the electricity bill", fr="Payer la facture d'électricité", de="Stromrechnung bezahlen",
          es="Pagar la luz", it="Pagare la bolletta della luce", ja="電気代を払う", ar="ادفع فاتورة الكهربا"),
     "home", None, True, False),
    (dict(en="Reply to the landlord", fr="Répondre au propriétaire", de="Dem Vermieter antworten",
          es="Contestarle al casero", it="Rispondere al padrone di casa", ja="大家さんに返信", ar="رد على صاحب البيت"),
     None, None, True, False),
]

hh, mm = map(int, os.environ.get("SHOT_TIME", "09:41").split(":"))
local_now = datetime.now().replace(hour=hh, minute=mm, second=0, microsecond=0)
now = local_now.astimezone(timezone.utc)
iso = lambda d: d.strftime("%Y-%m-%dT%H:%M:%S.000Z")
# Due "today" means a few hours from now, so nothing is overdue and the panda is happy.
evening = lambda days: (now + timedelta(hours=4)) if days == 0 else (
    local_now.replace(hour=18, minute=0) + timedelta(days=days)).astimezone(timezone.utc)

for sub in ("notes", "audio"):
    shutil.rmtree(os.path.join(root, sub), ignore_errors=True)
os.makedirs(os.path.join(root, "notes"))
done_ids = []
for i, (text, cat, due, done, basket) in enumerate(NOTES):
    nid = f"shot{i:02d}"
    n = {"id": nid, "createdAt": iso(now - timedelta(minutes=20 * (len(NOTES) - i))), "kind": "text", "text": text[lang], "rank": float(i)}
    if cat: n["categoryId"] = cat
    if due is not None: n["dueAt"] = iso(evening(due))
    if done:
        n["doneAt"] = iso(now - timedelta(hours=i))
        done_ids.append(nid)
    if basket: n["leaveBasket"] = True
    json.dump(n, open(os.path.join(root, "notes", f"{nid}.json"), "w"), ensure_ascii=False)
json.dump({"categories": [{"id": k, "name": v[1][lang], "color": v[0]} for k, v in CATS.items()]},
          open(os.path.join(root, "categories.json"), "w"), ensure_ascii=False)
# iCloud sync off: a simulator has no Apple Account, so "on" would show "Not signed in".
json.dump({"icloudSync": False}, open(os.path.join(root, "settings.json"), "w"))
json.dump({"bamboo": 23, "rewardedIds": done_ids}, open(os.path.join(root, "panda_state.json"), "w"))
for f in ("widget_cache.json", ".cloud_sync.json"):
    if os.path.exists(os.path.join(root, f)): os.remove(os.path.join(root, f))
print(f"{len(NOTES)} notes ({lang}) in {root}")
