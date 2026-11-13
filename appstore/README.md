# App Store submission

Everything App Store Connect asks for, ready to copy. Texts per language are in
`metadata/<locale>/` (fastlane `deliver` layout), written by `tool/appstore/store_texts.py`;
screenshots are in `screenshots/<locale>/`, made by `tool/screenshots/shoot.sh`.

Red Panda's promise, which every answer below follows: **no data is collected, no analytics,
no tracking, no server; location is used only on the device, for the leave basket.**
The repository stays public, so anyone can check it.

## 1. Before the first submission

- [ ] **GitHub Pages**: repository Settings > Pages > Deploy from a branch > `main`, folder `/docs`.
      The privacy and support links (`https://os-mas-datos.github.io/red_panda/<lang>/privacy/`) only work after this.
- [ ] **Licence**: the repository has no LICENSE file yet, so legally it is "source available", not open
      source. Pick one (for example MIT, Apache-2.0 or GPL-3.0) to make the open-source promise binding.
- [ ] **EU trader status** (Business > Agreements, or App Information): Digital Services Act. Mas Datos GmbH
      is a company, so it is a trader; Apple then shows its address, phone and email on the EU App Store.
      Without an answer the app is not offered in the EU.

## 2. App Information

| Field | Value |
| --- | --- |
| Primary language | English (U.K.) |
| Localisations | English (U.S.), French, German, Spanish (Mexico), Italian, Japanese, Arabic |
| Category | Productivity (secondary: Lifestyle) |
| Content rights | No third-party content |
| Age rating | Answer **None / No** to every question: no violence, mature themes, gambling, contests, unrestricted web access, user-generated content shared with others, or messaging. Result: **4+** |
| Price | Free, no in-app purchases (bamboo is only a game counter) |
| Availability | All countries (EU needs the trader status above) |
| Copyright | `2026 Mas Datos GmbH` |

Per language (from `metadata/<locale>/`): name, subtitle, privacy policy URL (App Information);
description, keywords, promotional text, support URL, marketing URL, "What's New" (version page).

## 3. App Privacy ("nutrition label")

**Data Collection: "No, we do not collect data from this app."**

Apple counts data as collected only when it leaves the device in a way that the developer or a third
party can access. Nothing in Red Panda does:

| Data | Where it goes | Why it is not "collected" |
| --- | --- | --- |
| Notes, voice recordings, categories, bamboo | App Group container on the device | Never leaves the device |
| Same, with iCloud sync on | The user's own iCloud Drive (private container) | Only the user can read it; we have no access |
| Location (leave basket) | iOS region monitoring (CLMonitor) on the device; the centre is kept on the device until the reminder fires | Never sent, never synced |
| Speech for voice notes | On-device recognition when iOS supports the language (`requiresOnDeviceRecognition`); otherwise Apple's speech service | Processed by Apple for the user, not by or for us |
| Settings | UserDefaults and `settings.json` on the device | Never synced |

Tracking: **No**. No third-party SDKs (dependencies: Flutter, path_provider, intl, rive, all local).
The privacy manifests (`ios/*/PrivacyInfo.xcprivacy`) say the same: `NSPrivacyTracking` false,
no collected data types.

## 4. Version page

- **Screenshots**: `screenshots/<locale>/iphone_*.png` (6.9", 1320 × 2868) and `ipad_*.png`
  (13", 2064 × 2752). Apple scales them down for the smaller devices.
- **Build**: the newest TestFlight build from Xcode Cloud.
- **Export compliance**: answered by the build (`ITSAppUsesNonExemptEncryption` = false).
- **Sign-in required**: No.
- **Release**: manually, or automatically after approval.

### Notes for App Review

> Red Panda is a to-do and notes app. It has no account, no server and collects no data; everything stays on
> the device (and in the user's own iCloud Drive if they turn on sync in Settings).
>
> Location ("Always") is used only for the optional leave basket: items marked for the basket remind the user
> when they leave the place where they marked them. The app asks iOS once for the current position and
> registers one circular region with CLMonitor; iOS wakes the app when the user leaves it, the app posts one
> local notification and removes the region. It never tracks the route and never sends the location anywhere.
> "While Using" also works (reminders then only while the app is open). The app explains this under
> Settings > Leave basket > "Why Always?".
>
> To try it: drag an item onto the basket button at the bottom of the list,
> allow location, then move more than 50 m away (or simulate a far location). A notification
> "🧺 Before you go…" lists the basket's items.
>
> Microphone and speech recognition: only while recording a voice note (the microphone button at the bottom
> right); speech is recognised on the device where iOS supports it.
>
> Lock Screen / Control Centre controls, the Action Button, Siri and widgets only open the app or add a note.
> The source code is public: https://github.com/os-mas-datos/red_panda

## 5. Submit

Add for Review > Submit. Review usually takes one to two days.
