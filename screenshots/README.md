# Screenshots

This folder ships **SVG mockups** of every screen in the app, built from the
same design tokens as the live UI. They render directly in GitHub READMEs,
weigh almost nothing, and stay sharp at any zoom.

## Files

| File | Screen |
|---|---|
| `01-onboarding.svg` | Onboarding step 1 with stacked cards |
| `02-signin.svg`     | Sign in (email + Face ID + Passkey) |
| `03-home-dark.svg`  | Home — dark theme |
| `04-home-light.svg` | Home — light theme |
| `05-wallet.svg`     | Wallet — front card visible |
| `06-wallet-swipe.svg` | Wallet — mid-swipe (Mastercard rotating) |
| `07-stats.svg`      | Stats — bar chart + donut |
| `08-profile.svg`    | Profile with gradient avatar |
| `09-send.svg`       | Send money + slide-to-confirm |
| `10-receipt.svg`    | Receipt with success halo |
| `11-txn-detail.svg` | Transaction detail |
| `12-notifs.svg`     | Notifications |

## Replacing with real screenshots

If you want photo-accurate captures from a running app, save them with the
same filename **but `.png`** and update the README references from `.svg`
→ `.png`:

```bash
flutter run                                     # start the app
flutter screenshot --out=screenshots/03-home-dark.png
```

Then in the main `README.md`, search-replace `03-home-dark.svg` →
`03-home-dark.png` (and similar for any others you've replaced).
