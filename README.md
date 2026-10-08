# Recruiting Agent Control Tower (SW-06)

> **Autonomous Multi-Agent Orchestration & Human-in-the-Loop Governance for Talent Acquisition**

---

## 🎯 Executive Overview

Modern talent acquisition teams are moving from single standalone recruiting bots to **fleets of specialized AI agents** (sourcing, candidate verification, personalized outreach, interview scheduling, market intelligence).

The **Recruiting Agent Control Tower** solves the orchestration and governance challenge:
- Coordinating who or what performs each recruitment task.
- Dynamically assigning work based on requisition urgency (P0/P1/P2) and SLA deadlines.
- Preserving rich candidate context across multi-agent handoffs.
- Enforcing **Human-in-the-Loop (HITL)** guardrails when confidence drops or sensitive candidate interactions occur.
- Providing an auditable timeline and end-to-end recruitment funnel observability.

---

## 🏗️ System Architecture

```
                       ┌──────────────────────────────┐
                       │   Open Requisitions Queue    │
                       │   (P0 Urgent, P1 High, P2)   │
                       └──────────────┬───────────────┘
                                      │
                       ┌──────────────▼───────────────┐
                       │     Control Tower Engine     │
                       │  - Requisition Dispatcher    │
                       │  - Capacity & SLA Router     │
                       │  - HITL Policy Guardrails    │
                       └──────────────┬───────────────┘
                                      │
         ┌────────────────────────────┼────────────────────────────┐
         │                            │                            │
┌────────▼────────┐          ┌────────▼────────┐          ┌────────▼────────┐
│  Sourcing Agent │          │ Verification    │          │ Outreach Agent  │
│  - GitHub Mining│ ──State─►│ Agent           │ ──State─►│ - Custom Hooks  │
│  - Talent Pools │  Handoff │ - Repo Commits  │  Handoff │ - Email Drafts  │
└─────────────────┘          │ - Match Scoring │          └────────┬────────┘
                             └────────┬────────┘                   │
                                      │                            │
                                      │ (Confidence < 75%)         │ (Executive / Sensitive)
                                      └─────────────┬──────────────┘
                                                    │
                                     ┌──────────────▼──────────────┐
                                     │   HITL Exception Center     │
                                     │   (Human Recruiter Review)  │
                                     │   - Approve / Override      │
                                     └──────────────┬──────────────┘
                                                    │
                                     ┌──────────────▼──────────────┐
                                     │  Scheduling Agent & Handoff │
                                     │  - Calendar Availability    │
                                     │  - Greenhouse / Ashby Sync  │
                                     └─────────────────────────────┘
```

---

## 🚀 Key Features Built

1. **Mission Control Command Center:**
   - Real-time KPI summary (Active Requisitions, Agents Online, Pending Approvals, Shortlist Count).
   - Live Agent Fleet telemetry and active task indicators.
   - P0/P1 Requisition Queue with SLA timers.
   - Real-time Control Plane activity feed.

2. **Multi-Agent Workflow & Kanban Pipeline:**
   - 4-Stage visual pipeline (`Sourcing` ➔ `Screening/Verification` ➔ `Outreach` ➔ `Recruiter Handoff`).
   - Deep **Candidate Dossier Modal** showing preserved context passed between agents, LLM prompts/drafts, and confidence metrics.

3. **Human-in-the-Loop (HITL) Exception Action Center:**
   - Detects low confidence scores ($< 75\%$), executive outreach rules, or candidate sentiment anomalies.
   - Recruiter can review, approve, override, or reject decisions with 1 click.

4. **Agent & Human Resource Registry:**
   - Unified directory of AI Agents and Human Recruiters.
   - Tracks roles, autonomy levels, throughput per hour, and quality/SLA metrics.

5. **Funnel Analytics & Observability:**
   - Visual conversion funnel (Discovered ➔ Verified ➔ Contacted ➔ Responded ➔ Shortlisted).
   - Time-to-shortlist velocity savings benchmark.

6. **Interactive Live Multi-Agent Simulation Engine:**
   - Click **"Run Live Simulation"** to trigger a real-time autonomous workflow.
   - Demonstrates: Sourcing Agent finding a profile ➔ Verification Agent scoring ➔ Exception raised to HITL queue ➔ Recruiter approval ➔ Advancing to outreach and scheduling.

---

## 💻 How to Run the Web Application

The application is completely self-contained with no external build step required:

### Option 1: Direct File Launch
Simply open `index.html` in any web browser:
```powershell
Start-Process "index.html"
```

### Option 2: Local HTTP Server (Python / PowerShell / Node)
```powershell
# Using Python (if available):
python -m http.server 8080

# Or open directly in Default Browser:
Invoke-Item "index.html"
```
