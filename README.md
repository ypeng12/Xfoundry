# Xfoundry

Xfoundry is a unified Super App framework built with Flutter, designed to seamlessly aggregate real-time data from various sub-systems, integrations, and intelligent agents into a single, highly modular frontend console.

## Project Structure (Feature-First Architecture)

```text
lib/
├── core/                        # Core components, shared utilities across all modules
│   ├── network/                 # Unified API client for realtime fetching (Intercepts, WebSockets)
│   ├── config/                  # Environment variables and global configurations
│   └── database/                # Local offline caching support placeholder
├── features/                    # Specific sub-universes (Business Modules)
│   ├── housing/                 # ★ Module 1: UMD Housing
│   │   ├── models/
│   │   ├── services/            # (Connects to our internal FastAPI scraper)
│   │   └── ui/
│   ├── calendar/                # ★ Module 2: Google Calendar Integration
│   │   ├── models/
│   │   ├── services/            # (Implements Calendar API OAuth and realtime fetch)
│   │   └── ui/
│   └── canva/                   # ★ Module 3: Canva Integration
│       ├── models/
│       ├── services/            # (Listens to Canva Webhooks / APIs)
│       └── ui/
└── main.dart                    # App skeleton, routing manager, and module registry
```

## Backend Services
The repository also includes standard Python backend services under `umd_housing_api/`, which act as the internal API providers for the frontend modules.
