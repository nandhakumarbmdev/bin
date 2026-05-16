---
name: explore
description: >
  Explain code, config, or any project file in plain English for someone who is smart but
  new to this specific codebase. Use this skill whenever the user asks to explain, walk
  through, break down, or understand anything in the project — file paths, pasted code,
  config files, or vague questions like "how does X work?". Trigger even without /explain:
  phrases like "what does this do", "help me understand this file", "walk me through this",
  "why is this here", or "I don't get how X works" all warrant this skill. Also trigger for
  config files: Dockerfiles, tsconfig, yaml, env files, and similar.
---

# /explain — Code Explanation Skill

---

## Step 0 — Read the invocation, determine three things

Before writing anything, answer these:

**1. What is the input?**

| Input | What to do |
|---|---|
| File path given | Read the file first. If it doesn't exist or can't be read, say so clearly and ask the user to confirm the path. Never guess the content. |
| File path + `section:name` | Read the full file, locate that function/class/block, explain only that. |
| File path + `line X-Y` | Read the full file for context, explain only lines X–Y. Pull in enough surrounding lines to make the logic coherent — typically 5–10 lines above and below. |
| Pasted code | Work from what was pasted. If it references imports or types not included, note what's missing and explain what can be inferred. |
| Vague question ("how does auth work?") | Don't guess. Ask which file or function to start from, or search for the relevant entry point first. |

**2. What is the mode?**

| Invocation | Mode |
|---|---|
| `/explain src/file.ts` | **Full** |
| `/explain src/file.ts section:functionName` | **Section** |
| `/explain src/file.ts line 40-60` | **Lines** |
| `/explain src/file.ts simple` | **Simple** |
| Pasted code, short (under ~80 lines) | **Full** |
| Pasted code, long (over ~80 lines) | Explain top-level structure, ask which part to go deeper on |

**File over ~200 lines, no section specified?** Don't explain everything. Explain the
top-level structure — what the file's job is, its main exports/classes/functions — then ask
which part to go deeper on.

**3. What kind of file is it?**

- **Code file** (.ts, .dart, .py, .go, etc.) → use the full explanation flow below
- **Config file** (.yml, .json, Dockerfile, .env, tsconfig, etc.) → use the Config flow below
- **Unsure** → read the file first, then decide

---

## Step 1 — Read before writing anything

- Read the file or section completely before forming an explanation.
- Then check the immediate context: imports, types, interfaces, and configs this file depends
  on. A function makes more sense when you know who calls it and why.
- To find callers ("what depends on this"): search the codebase for the function/class name
  using grep or a file search. Don't guess or skip this — if a search isn't possible, say so.
- Only start writing after you understand *why* this code exists, not just what it does.

---

## Step 2 — Calibrate to the reader

Before explaining, read the conversation for signals about who this person is:

- **New to the codebase**: explain the why behind decisions, not just the what. Use analogies.
- **Senior / quick refresher**: skip the obvious, focus on non-obvious design choices and
  tradeoffs. Lead with the summary, go deep only where complexity warrants it.
- **No signal**: default to "smart but new to this codebase." They know the language; they
  don't know why this file exists or how it fits.

---

## Step 3 — Full mode explanation (code files)

Work through these sections in order. Skip any that genuinely add no value for this specific
code — a simple pure function doesn't need edge cases or a flow diagram. Use judgment, but
don't skip complex parts just because they're "standard."

### One sentence
What does this code do? No jargon, no backstory. The job in one sentence.

### The big picture
Show how data or control moves through this code.

- **Data transformation or multi-system coordination**: draw an ASCII flow diagram built from
  the actual code. Show real function names, real branch conditions, real outputs. Don't use
  a generic shape.
- **UI component**: describe the render lifecycle — what triggers a re-render, what state it
  owns, what it emits.
- **Event handler / callback**: describe what fires it, what it does, what it produces or
  mutates.
- **Simple getter or pure utility**: skip the diagram. The one-sentence summary is enough
  for the big picture.

### Terms to know first
Only define terms that are project-specific or used in a non-obvious way. Skip anything the
reader already knows from the language or common libraries. One line per term. If there are
none, skip this section entirely.

### Section by section
Group related lines into logical sections. For each section:
- Show the relevant lines with line numbers
- What it does in plain English
- Why it exists — what breaks or goes wrong without it

When a section contains branches (`if`, `switch`, `try/catch`, ternary): explain them inline
here, not in a separate pass. For each branch:
- What condition triggers it?
- What happens when taken?
- What happens when NOT taken?
- Why does this branch exist?

Don't cover branches separately AND in the section breakdown — pick one place and be
complete there.

### Data at each stage
Only for code that transforms data. Show what the data looks like before and after each
meaningful step. Use the actual field names and types from the code.

### Edge cases
What happens when things go wrong? Only mention edge cases the code actually handles or
visibly ignores — don't invent scenarios. Empty inputs, nulls, failures, missing config,
concurrent calls.

### What depends on this
Search for callers. List the files or functions that call this code and what they expect from
it. Keep it to a short list. If nothing calls it directly (it's an entry point or exported
public API), say that explicitly.

---

## Step 4 — Section mode

Read the full file, find the named function/class/block. Explain only that, using the same
section-by-section structure above. Additionally:
- Show who calls this section and with what arguments (search for callers)
- Show what this section calls and why

---

## Step 5 — Lines mode

Read the full file for context. Explain only the specified lines, but:
- Pull in enough surrounding lines (typically 5–10 above and below) to make the logic
  coherent
- State explicitly what is happening just before line X and just after line Y, so the
  explained block isn't floating in a vacuum

Use section-by-section structure scaled to the line count. A 20-line block doesn't need
every subsection — just what's relevant.

---

## Step 6 — Simple mode

Only produce:
1. One sentence — what this code does
2. Big picture — diagram or lifecycle, whichever fits
3. Three sentences — the most important thing to understand about how it works

Nothing else.

---

## Step 7 — Config file flow

For non-code files (Dockerfile, docker-compose.yml, tsconfig.json, .env.example,
nginx.conf, and similar):

- **One sentence**: what this config controls
- **Key by key** (or block by block for yaml/docker): for each non-obvious entry, explain
  what it does and why it's set the way it is. Skip entries that are self-explanatory.
- **What breaks if this is wrong**: the most likely misconfiguration and its symptom
- **How it connects**: what reads this config and when

Don't use a flow diagram for config files. Don't apply code-explanation sections.

---

## Closing

After every explanation, invite the next question naturally — match the tone of the
conversation. Point toward what makes sense to ask next: a specific function, a line range,
how it connects to another part of the system. Don't use a fixed script.

---

## What NOT to do

- Don't explain syntax the reader already knows from the language.
- Don't explain obvious code. A simple getter needs no explanation.
- Don't suggest code changes or add comments. This is explanation only.
- Don't skip complex parts because they're "standard" or "boilerplate."
- Don't use the phrase "as you can see."
- Don't explain branches in two places — pick section-by-section and be complete there.
- Don't guess file content if the file can't be read. Say so and ask.
- Don't invent callers or dependencies. Search first; if search isn't possible, say so.