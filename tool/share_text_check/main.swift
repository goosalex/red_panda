// Checks ios/Shared/SharedText.swift (share-extension text splitting) on macOS:
//   xcrun swiftc -o /tmp/share_text_check tool/share_text_check/main.swift ios/Shared/SharedText.swift && /tmp/share_text_check
import Foundation

let cases: [(String, String, [String])] = [
  ("empty", "", []),
  ("whitespace only", "  \n\t \n ", []),
  ("single line", "  Buy milk  ", ["Buy milk"]),
  ("one paragraph, several lines", "Call the plumber\nabout the  leaking tap\ntomorrow", ["Call the plumber about the leaking tap tomorrow"]),
  ("two paragraphs", "Book flights\nfor June\n\nRenew passport", ["Book flights for June", "Renew passport"]),
  ("whitespace-only separator line", "First thing\n   \t\nSecond thing", ["First thing", "Second thing"]),
  ("windows line endings", "Line one\r\nstill one\r\n\r\nLine two\r\n", ["Line one still one", "Line two"]),
  ("markdown list", "- milk\n* eggs\n+ bread\n• butter\n  ◦ jam", ["milk", "eggs", "bread", "butter", "jam"]),
  ("numbered list", "1. Wash car\n2) Mow lawn\n10. Fix bike", ["Wash car", "Mow lawn", "Fix bike"]),
  ("checkbox list", "- [ ] pay rent\n- [x] call mum\n☐ water plants\n☑ feed cat\n✓ done thing\n[ ] bare box", ["pay rent", "call mum", "water plants", "feed cat", "done thing", "bare box"]),
  ("heading ending with colon", "Shopping:\n- milk\n- eggs", ["milk", "eggs"]),
  ("preamble without colon", "Weekend plans\n- hike\n- read", ["Weekend plans", "hike", "read"]),
  ("bullets with continuation lines", "- buy a present\n  for Anna's birthday\n- send the card\nby Friday", ["buy a present for Anna's birthday", "send the card by Friday"]),
  ("mixed paragraphs and bullets", "Call the bank\n\nGroceries:\n- apples\n- pears\n\nClean the garage", ["Call the bank", "apples", "pears", "Clean the garage"]),
  ("heading in its own paragraph", "To do:\n\n– taxes\n— dentist", ["taxes", "dentist"]),
  ("not bullets: negative number, emphasis, decimals", "-5 degrees tonight\n*really* cold\n3.5 kg flour", ["-5 degrees tonight *really* cold 3.5 kg flour"]),
  ("empty bullets dropped", "- \n- [ ]\n- real", ["real"]),
  ("tabs and space runs collapsed", "a\t\tb    c", ["a b c"]),
]

var failures = 0
for (name, input, expected) in cases {
  let got = SharedText.items(from: input)
  if got == expected {
    print("PASS  \(name)")
  } else {
    failures += 1
    print("FAIL  \(name)\n      expected \(expected)\n      got      \(got)")
  }
}

// Caps
let many = (1...150).map { "- item \($0)" }.joined(separator: "\n")
let capped = SharedText.items(from: many)
let long = SharedText.items(from: String(repeating: "x", count: 5000))
let capsOK = capped.count == 100 && capped.first == "item 1" && long.first?.count == 1000
print(capsOK ? "PASS  caps (100 items, 1000 chars)" : "FAIL  caps: \(capped.count) items, \(long.first?.count ?? 0) chars")
if !capsOK { failures += 1 }

print(failures == 0 ? "\nAll \(cases.count + 1) checks passed" : "\n\(failures) failed")
exit(failures == 0 ? 0 : 1)
