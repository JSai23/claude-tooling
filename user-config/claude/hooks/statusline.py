#!/usr/bin/env python3
"""Cyberpunk neon status line for Claude Code.

Style: evil_lualine + Tokyo Night scanline. No bg blocks —
thin │ separators, neon true-color foregrounds, ░▒▓ boot edge.
"""
import json, sys, subprocess, os, time
from pathlib import Path

# ── true-color helpers ──────────────────────────────────────
def fg(r, g, b):
    return f'\033[38;2;{r};{g};{b}m'

R   = '\033[0m'
B   = '\033[1m'

# ── cyberpunk palette (full neon) ───────────────────────────
CYAN    = fg(0, 255, 255)     # #00FFFF  model
MAGENTA = fg(255, 0, 220)     # #FF00DC  context
BLUE    = fg(0, 170, 255)     # #00AAFF  time
GREEN   = fg(0, 255, 130)     # #00FF82  git clean
YELLOW  = fg(255, 255, 0)     # #FFFF00  git dirty
PINK    = fg(255, 50, 130)    # #FF3282  diff deletions
PURPLE  = fg(200, 80, 255)    # #C850FF  language
ORANGE  = fg(255, 160, 0)     # #FFA000  context warning
RED     = fg(255, 50, 50)     # #FF3232  context critical
DIM     = fg(100, 100, 140)   # #64648C  folder / separators
WHITE   = fg(230, 230, 255)   # bright white

# lead-in glyph + separator
LEAD = f"{CYAN}◆{PURPLE}⟫{R}"
SEP  = f" {DIM}│{R} "

# ── session elapsed tracker ─────────────────────────────────
STAMP = Path('/tmp/.claude-statusline-session')

def session_elapsed():
    now = time.time()
    try:
        if STAMP.exists():
            start = float(STAMP.read_text().strip())
            # reset if stale (>24h)
            if now - start > 86400:
                start = now
                STAMP.write_text(str(now))
        else:
            start = now
            STAMP.write_text(str(now))
        s = int(now - start)
        if s < 60:   return f"{s}s"
        if s < 3600:  return f"{s // 60}m"
        return f"{s // 3600}h{(s % 3600) // 60}m"
    except Exception:
        return None

# ── git helpers ─────────────────────────────────────────────
GIT = ['git', '-c', 'core.useBuiltinFSMonitor=false']

def git_branch(cwd):
    try:
        return subprocess.check_output(
            GIT + ['rev-parse', '--abbrev-ref', 'HEAD'],
            cwd=cwd, stderr=subprocess.DEVNULL, text=True, timeout=2
        ).strip()
    except Exception:
        return None

def git_diff_stat(cwd):
    """Aggregate unstaged + staged changes. Always returns a string."""
    files = ins = dels = 0
    try:
        for extra in [[], ['--cached']]:
            out = subprocess.check_output(
                GIT + ['diff', '--shortstat'] + extra,
                cwd=cwd, stderr=subprocess.DEVNULL, text=True, timeout=2
            ).strip()
            if not out:
                continue
            for part in out.split(','):
                p = part.strip()
                if 'file' in p:      files += int(p.split()[0])
                elif 'insertion' in p: ins += int(p.split()[0])
                elif 'deletion' in p:  dels += int(p.split()[0])
    except Exception:
        pass
    return f"{files}f +{ins} -{dels}"

# ── language detection ──────────────────────────────────────
LANG_MAP = [
    ('Cargo.toml',       'rust',       ''),
    ('go.mod',           'go',         ''),
    ('package.json',     'js/ts',      ''),
    ('tsconfig.json',    'ts',         ''),
    ('pyproject.toml',   'python',     ''),
    ('requirements.txt', 'python',     ''),
    ('Gemfile',          'ruby',       ''),
    ('build.gradle',     'java',       ''),
    ('pom.xml',          'java',       ''),
    ('mix.exs',          'elixir',     ''),
    ('CMakeLists.txt',   'c++',        ''),
    ('Makefile',         'c',          ''),
    ('pubspec.yaml',     'dart',       ''),
    ('.swift',           'swift',      ''),
]

def detect_lang(cwd):
    p = Path(cwd)
    for fname, lang, icon in LANG_MAP:
        if (p / fname).exists():
            return icon, lang
    return None, None

# ── path shortener ──────────────────────────────────────────
def short_path(cwd):
    home = os.path.expanduser('~')
    p = ('~' + cwd[len(home):]) if cwd.startswith(home) else cwd
    parts = p.split('/')
    if len(parts) > 3:
        p = '/'.join(['…'] + parts[-2:])
    return p

# ── format tokens compactly ────────────────────────────────
def fmt_tok(n):
    if n >= 1_000_000: return f"{n / 1_000_000:.1f}M"
    if n >= 1_000:     return f"{n / 1_000:.1f}k"
    return str(n)

# ── main ────────────────────────────────────────────────────
try:
    data = json.load(sys.stdin)
    cwd      = data['workspace']['current_dir']
    model    = data['model']['display_name']
    ctx      = data['context_window']
    used_pct = ctx.get('used_percentage', 0) or 0
    used_tok = ctx.get('used_tokens')
    max_tok  = ctx.get('max_tokens')
    vim_mode = data.get('vim', {}).get('mode')

    segs = []

    # lead-in
    segs.append(LEAD)

    # model
    segs.append(f"{CYAN}{B}{model}{R}")

    # context: progress bar + pct + tokens
    if used_pct > 80:    cc = RED
    elif used_pct > 60:  cc = ORANGE
    else:                cc = MAGENTA
    bar_w  = 8
    filled = int(bar_w * used_pct / 100)
    bar    = '█' * filled + '░' * (bar_w - filled)
    if used_tok and max_tok:
        tok_s = f"{fmt_tok(used_tok)}/{fmt_tok(max_tok)}"
    else:
        est_max = 200000
        est_used = int(est_max * used_pct / 100)
        tok_s = f"{fmt_tok(est_used)}/{fmt_tok(est_max)}"
    segs.append(f"{cc}{bar} {used_pct:.0f}% {CYAN}{tok_s}{R}")

    # time + session elapsed
    try:
        now_t = subprocess.check_output(
            ['date', '+%H:%M'], text=True, timeout=1
        ).strip()
    except Exception:
        now_t = ''
    elapsed = session_elapsed()
    t_str = ''
    if now_t:    t_str += f"{ORANGE}{now_t}"
    if elapsed:  t_str += f" {BLUE}⟫ {elapsed}"
    if t_str:
        segs.append(f"{t_str}{R}")

    # git branch + diff (always show diff stats)
    branch = git_branch(cwd)
    if branch:
        diff = git_diff_stat(cwd)
        segs.append(f"{GREEN}{branch} {YELLOW}{diff}{R}")

    # language
    icon, lang = detect_lang(cwd)
    if lang:
        segs.append(f"{PURPLE}{icon} {lang}{R}")

    # folder
    segs.append(f"{WHITE}{short_path(cwd)}{R}")

    # vim mode
    if vim_mode:
        mc = GREEN if vim_mode == 'NORMAL' else CYAN
        ml = 'N' if vim_mode == 'NORMAL' else 'I'
        segs.append(f"{mc}{B}[{ml}]{R}")

    print(SEP.join(segs))

except Exception as e:
    print(f"{fg(255,94,94)}⚠ {e}{R}")
