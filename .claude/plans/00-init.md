# Fourth Thing — single-page topic spinner

> This file started as the build plan and has been revised to describe what
> actually shipped.

## Context

Engineers give the usual three standup updates daily; once a week they add a fun
"fourth thing." This site picks that week's fourth-thing prompt. It's a single,
standards-based HTML file: extremely fast, zero frameworks, zero build step,
inline CSS/JS, accessible, light + dark, and big enough to read when
screen-shared over Zoom.

Key decisions:

- **"Terminal roulette" aesthetic** — a monospace fake-terminal; candidate
  topics scroll past like log output, decelerate, and the winner is revealed in
  huge text with a blinking block cursor.
- **Command sits below the results** — like a real shell, the `$` prompt line
  stays at the bottom and output scrolls above it. (Layout reordered on
  2026-07-17.)
- **Remember recent picks** — the last **50** selections are stored in
  `localStorage` and excluded from the pool so topics don't repeat week to week.
- **One remembered pick per session** — a session = one page load. Extra spins
  in the same load *replace* the session's stored entry instead of appending, so
  only the final pick is kept. Tracked with an in-memory boolean; no cookies.

## Deliverable

- `index.html` — the entire app: inline CSS + JS, a `data:` URI favicon, and no
  external requests of any kind.
- `Dockerfile` — deploys the single file behind `joseluisq/static-web-server`
  (copies `index.html` into `/public/`). Build/deploy infra only; nothing extra
  reaches the browser.

### Page structure (top → bottom)

1. **header** — `<h1>Fourth Thing</h1>` and the tagline
   `did · doing · blocked · the fourth thing`.
2. **command results** — a scrolling `.log` region (candidates flicker past
   during the spin, the final line marked `✓`) and the giant `.result` line.
3. **command** — a fake prompt, `$ topics -4 --rand | head -n1`, with a blinking
   block cursor. Sits *below* the results to emulate a shell.
4. **button** — one real `<button>` labeled `[ execute ]` (Tab to focus,
   Enter/Space to activate). Enter/Space also work globally when nothing else is
   focused.
5. **footer** — `press [enter] or [space] to run`.

Also: an inline SVG "4" favicon via `data:` URI (keeps the page at exactly one
network request), `<title>Fourth Thing</title>`, a meta description, `lang="en"`,
viewport + `theme-color` metas, and a `<noscript>` note.

### Styling (inline `<style>`)

- System monospace stack:
  `ui-monospace, SFMono-Regular, Menlo, Consolas, monospace`. No web fonts.
- CSS custom properties for the palette. **Dark mode** (the default) = near-black
  `#0b0f0c` background with a green accent `#4ade80` and a soft glow on the
  result; **light mode** = paper `#f7f5ee` background, dark ink, darker green
  accent `#0b6b3a`, glow off. Switched via `@media (prefers-color-scheme: ...)`.
  All text meets WCAG AA contrast in both modes.
- Result line sized with `clamp(1.75rem, 5.5vw, 5rem)` so it stays legible over
  Zoom at any window size.
- The blinking cursor and scroll flicker animate only opacity / text content —
  no layout thrash.
- `@media (prefers-reduced-motion: reduce)`: no scroll animation, no blink —
  pressing execute prints the result instantly.

### Behavior (inline `<script>`, plain ES, no dependencies)

- `TOPICS`: a const array of **258** short prompts (10 representative examples
  below). New topics are submitted via the repo linked in a code comment
  (`github.com/mharen/fourth-thing`).
- Spin: pick the winner up front (`Math.random` over the eligible pool), then run
  a decelerating text-shuffle in the log region (a `setTimeout` chain with
  growing delays, ~1.5–2s total) before revealing the winner letter-by-letter.
  The reduced-motion path skips straight to the reveal.
- Eligible pool = `TOPICS` minus the recent-picks history stored under the
  `localStorage` key `fourth-thing:recent`. After a spin, record the winner and
  trim history to the newest 50. The first spin per page load appends an entry;
  later spins replace it. If excluding history would empty the pool, fall back to
  the full list. All `localStorage` access is wrapped in try/catch, so
  private-mode / blocked storage degrades to pure random.
- Accessibility: the visible `.result` is `aria-hidden`; a separate
  visually-hidden `role="status"` region announces only the final pick (not every
  shuffle frame, which would spam screen readers). The button has a clear
  `:focus-visible` outline.

### Topics (10 representative examples)

The full list is 258 short prompts kept deliberately casual — soft phrasings
over hard superlatives (e.g. "a concert you still think about" rather than "the
best concert ever"), a mix of open-enders, this-or-that binaries, and playfully
controversial picks, with no duplicates or near-duplicates.

1. What new music are you into?
2. When did you last leave the state?
3. What's a recent fun vacation?
4. Tabs or spaces?
5. Star Wars or Star Trek?
6. Pineapple on pizza: yes or no?
7. GIF: hard G or soft G?
8. What's a concert you still think about?
9. What's a low-stakes hill you'll die on?
10. What's your go-to karaoke song?

## Verification

1. Serve locally (`npx http-server`, or `.claude/launch.json` → "fourth-thing")
   and open it in the Browser pane.
2. Check both color schemes (light / dark).
3. Spin several times: the roulette animation runs, the result lands in giant
   readable text above the command line, and multiple spins in one page load
   leave only one new `localStorage` entry (the latest pick). Reload and spin
   again to confirm a second entry appears and prior picks are excluded.
4. Keyboard: Tab to the button; activate with Enter and Space.
5. Reduced motion: emulate `prefers-reduced-motion` and confirm the result
   appears instantly with no animation.
6. Confirm exactly one network request (the page itself) and no console errors.
