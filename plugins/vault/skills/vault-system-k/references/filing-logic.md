# Filing Logic — Scope Tables and Decision Trees

## Area Scope Table

| Area | Scope | What Belongs Here |
|------|-------|-------------------|
| `ai-dev-ecosystem` | AI accelerating development | Agent architecture, LLM tooling, IDE evolution, agentic workflows, AI-assisted coding, developer tools |
| `modeling` | ML/AI as a discipline | LLM internals, training techniques, model capabilities, AI papers, benchmarks, fine-tuning, prompt engineering theory |
| `systems-infra` | Computing infrastructure | Databases, kernels, OS, networking, distributed systems, cloud, DevOps, deployment |
| `prediction-markets` | Prediction market domain | Platform mechanics, market design, information aggregation, calibration, forecasting theory |
| `stocks` | Public equities | Stock analysis, market structure, fundamental/technical analysis, options, equity strategies |
| `crypto-assets` | Digital assets | Crypto protocols, DeFi, tokenomics, blockchain, digital asset strategies |
| `math-stats` | Quantitative foundations | Mathematics, statistics, probability, stochastic processes, numerical methods, optimization |
| `personal-dev` | Self-improvement | Productivity systems, PKM methodology, habits, learning strategies, career development |
| `writing-content` | Writing and media | Writing process, content strategy, publishing, media consumption/production, communication |

### Area Boundary Decisions

When content spans areas:

- **AI paper about training techniques** → `modeling` (it's about the model, not about using it to develop)
- **Using Claude to write code** → `ai-dev-ecosystem` (it's about development workflow)
- **Statistics for prediction markets** → `prediction-markets` (the application domain wins)
- **Math foundations for quant strategies** → `math-stats` (if it's the math itself) or the relevant project (if it's applied to a specific strategy)
- **Building a database** → `systems-infra` (infrastructure)
- **Database for a prediction market project** → the project folder (it serves the project directly)

**Rule**: File in the more specific location. Cross-link from the broader area's MOC.

## Project Scope Table

| Project | Goal | What Belongs Here |
|---------|------|-------------------|
| `personal-server-infra` | Personal server setup | Server configuration, hosting, home lab, self-hosting decisions |
| `polymarket-framework` | Polymarket trading framework | Polymarket API, market analysis tooling, trading strategies specific to Polymarket |
| `prediction-market-algo-dev` | Prediction market algorithms | Algorithm design, backtesting results, model development for prediction markets |
| `qr-strategies-futures` | QR strategies for futures | Futures trading strategies, QR-specific research, backtesting |
| `quant-bridge-framework` | Quantitative bridge system | Cross-market analysis, bridge between prediction markets and traditional quant |

### Project vs Area Decision

- **Does it have a deadline/goal?** → Project
- **Will it end?** → Project
- **Is it ongoing maintenance of knowledge?** → Area
- **Does it directly produce a deliverable?** → Project

Notes can start in an Area and later serve a Project — link them, don't move them. Only file directly in a Project if the note was created FOR that project's specific goal.

## Resource Sub-folder Mapping

| Content Type | Destination | Examples |
|--------------|-------------|----------|
| Readwise imports, web clips | `3-Resources/clips/` | Highlighted articles, saved quotes |
| Tweets, short posts, quick takes | `3-Resources/short-form/` | Twitter threads, LinkedIn posts |
| Full articles, essays, long reads | `3-Resources/long-form/` | Blog posts, research articles |
| Book notes, summaries | `3-Resources/books/` | Book highlights, chapter summaries |
| Video notes, transcripts | `3-Resources/videos/` | YouTube notes, lecture transcripts |

### Resource vs Area Decision

- **Is it someone else's content you're saving?** → Resource
- **Is it your own thinking about a topic?** → Area
- **Is it a curated collection of external content?** → Resource
- **Does it contain your analysis or synthesis?** → Area (even if it references external content)

## Decision Tree for Ambiguous Content

```
Is this note about an active project's specific goal?
├── YES → File in project
└── NO ──→ Is this your own thinking/analysis?
            ├── YES ──→ Does it relate to an area of ongoing interest?
            │           ├── YES → File in that area
            │           └── NO → Is it worth keeping?
            │                     ├── YES → Create new area or archive
            │                     └── NO → Delete
            └── NO ──→ Is this reference material?
                        ├── YES → File in Resources (correct sub-folder)
                        └── NO → Archive or delete
```

## Reading Intent Signals

When processing inbox items from the writer or thinker:
- `filing-hint` — strong signal for destination, verify with sem-search-a
- `context` — explains what prompted the note and what it relates to
- `source: thinker` — synthesis note, may need to update MOC thesis
- `tags` — knowledge role can hint at filing (e.g., `#tool` might be a resource)

## Semantic Search Confirmation

When filing isn't obvious, use semantic search to confirm:

1. Run `qmd vsearch` or `qmd query` with the note's key sentences
2. Look at top 5-10 results — where do they live?
3. If 3+ results are in the same area → strong filing signal
4. If results span multiple areas → file in the most specific one, cross-link from others
5. If no good matches → this might be a new topic. Check if it warrants a new area (rarely) or file in the closest area
