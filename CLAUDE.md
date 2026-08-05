# Fourth Thing — working notes for Claude

A single-page "fourth thing" standup-topic spinner with a terminal-roulette
aesthetic. See `.claude/plans/00-init.md` for the full spec of what shipped.

## Hard constraints (don't break these)

- Everything lives in **one file**, `index.html`, with inline `<style>` and
  `<script>`. No frameworks, no build step, no npm dependencies.
- **No external requests at runtime.** The favicon is a `data:` URI; the page
  must make exactly one network request (itself). Don't add fonts, CDNs, or
  analytics.
- Vanilla ES only — standards-based, nothing that needs transpiling.
- Default to the simplest thing that works. Don't add tooling, abstraction, or
  dependencies unless asked.

## Writing topics (the `TOPICS` array)

- **Soft superlatives, not hard ones.** Ask for *a* thing, not someone's
  all-time #1 — it's lower-pressure and easier to answer on the spot. Prefer
  "a concert you still think about" over "your best concert ever", "a recent fun
  vacation" over "your favorite vacation", "go-to" over "best". Avoid the
  "best / favorite / most … *ever*" framing.
- **No duplicates or near-duplicates.** Don't add a question that's just another
  one reworded — scan the existing list first.
- Keep them short, casual, and answerable in a standup. Mix open-enders,
  this-or-that binaries, and playfully controversial picks; dev-culture is fair
  game.
- New topics are submitted via github.com/mharen/fourth-thing.

## Accessibility & theming (must keep working)

- Light + dark via `prefers-color-scheme` (dark is the default); WCAG AA contrast
  in both.
- Honor `prefers-reduced-motion`: instant reveal, no blink or scroll animation.
- Keyboard: the button is focusable and Enter/Space activate it (also globally
  when nothing else is focused); keep a visible `:focus-visible` outline. The
  visible result is `aria-hidden`, and a `role="status"` region announces only
  the final pick.
- The result text must stay huge and legible for Zoom screen-share (sized with
  `clamp()`).
- The command (`$` prompt) line sits **below** the results, shell-style — output
  scrolls above the prompt. Don't "fix" this back to the top.

## Shareable links (`#slug`)

- Every pick puts a slug of the topic text in the hash, so the URL bar is always
  a copyable link to what's on screen. Loading a `#slug` shows that topic and
  skips the roulette; an unrecognized slug spins instead.
- Slugs come from the topic **text**, not its index — links have to survive
  topics being added, removed, or re-sorted. Don't switch to indices.
- Use `history.replaceState`, never `location.hash =`, when the page sets the
  hash itself. Assigning would stack a history entry per spin and turn the back
  button into a re-spin button.

## Dev / preview / deploy

- Preview via `.claude/launch.json` → "fourth-thing" (`npx http-server`,
  `autoPort` on). Don't hardcode a port — 8080 is often held by another session.
- Deploy: the `Dockerfile` serves `index.html` via `joseluisq/static-web-server`.

## Docs

- Plans live in `.claude/plans/`. Keep them accurate to what actually shipped,
  and truncate long lists to a few representative examples.
