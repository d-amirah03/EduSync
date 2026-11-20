# LOGAI — AI-Assisted Development & Documentation Log

| Field | Details |
| :--- | :--- |
| **Project** | EduSync (QR-Based Staff Attendance & AI Summary System) |
| **Course** | TMA3084 Software Engineering Laboratory (Semester 1, 2026/2027) |
| **Group** | Group 1_T10 — Nexus Devs |
| **Lecturer** | Mdm. Nurfauza Jali |
| **Demonstrator** | Md. Aminul Islam Rakib |
| **Repository** | https://github.com/d-amirah03/EduSync.git |
| **Last Updated** | 20/11/2026 |

---

## Team Members

| No. | Name | Matric No. | TSPi Role |
| :---: | :--- | :---: | :--- |
| 1 | Wan Adam Danish Bin Wan Abit | 103014 | Software Project Manager (PM) |
| 2 | Batrisya Qistina Binti Jumry | 103516 | Lead System Analyst & Requirement Engineer |
| 3 | Nur Damia Amirah Binti Meruni | 100316 | Backend & AI Integration |
| 4 | Qhairunnisa Shahirah Binti Zakaria | 106089 | Mobile Architect |
| 5 | Abdul Rahim Bin Idris | 102368 | Quality Assurance (QA) |

---

## AI Usage Audit Log (Milestone 1 & Milestone 2)

| Entry ID | Date | Member | Tool / Model | Linked Artefact / IDs | Prompt Summary | Human Verification & Refactoring Notes | Reviewer & Status |
| :---: | :---: | :--- | :--- | :--- | :--- | :--- | :--- |
| **AI-01** | 12/11/2026 | Qhairunnisa Shahirah | Gemini | `lib/theme.dart`, `lib/station.dart`, `FR-03`, `FR-AI-01`–`FR-AI-03` | Scaffolded responsive Flutter prototype widgets (`theme.dart`, `station.dart`) and layout structure from Figma specs. | Adjusted Material Design 3 colour tokens, Inter typography, light/dark mode rebuilding, and responsive breakpoint (`900 px`). Verified with `flutter analyze`. | Qhairunnisa & Abdul Rahim (**Approved**) |
| **AI-02** | 18/11/2026 | Wan Adam Danish | Gemini | `docs/SRS.pdf` (`FR-10`, `FR-12`, `NFR-AI-01`–`02`) | Structured Input/Action/Output specifications and Given/When/Then acceptance criteria for `FR-10` (Role-Based Access & Rules) and `FR-12` (PDF Report & Print Preview). | Cross-checked all screen IDs (`UI-01`, `UI-08`, `UI-11`), removed out-of-scope multi-session items, and aligned GitHub Issue numbers (`#10`, `#12`). | Wan Adam Danish & Batrisya (**Approved**) |
| **AI-03** | 19/11/2026 | Abdul Rahim | Gemini | `docs/SRS.pdf` (`NFR-01`–`NFR-07`, `NFR-AI-01`–`05`) | Refined measurable targets and concrete verification methods for Non-Functional Requirements and Responsible-AI constraints. | Verified targets against PDPA 2010 requirements, GitHub Secret Scanning, Flutter DevTools benchmarks, and `flutter analyze` CI checks (`0` static analysis errors). | Abdul Rahim & Nur Damia (**Approved**) |
| **AI-04** | 19/11/2026 | Batrisya Qistina | Gemini | `docs/SRS.pdf` (Sections 1.3, 2.4, 4.2, 4.3) | Audited SRS v2.0 for traceability gaps between new client feedback (`P4`–`P6`), requirements (`FR-01`–`FR-12`), and test cases (`TC-01`–`TC-35`). | Added `P4`–`P6` to Section 1.3, aligned `Table 4.2` Traceability Matrix rows, and verified all 4 client meetings in `Table 2.3` and Appendix A. | Batrisya & Wan Adam Danish (**Approved**) |
| **AI-05** | 19/11/2026 | Nur Damia Amirah | Gemini | `docs/SRS.pdf` (Section 3.3, `FR-AI-01`–`03`) | Reviewed AI interaction flow and pseudonymisation privacy rules for Gemini Flash primary and OpenRouter fallback providers. | Confirmed coded staff IDs (`TCH-01`) replace actual names in Supabase Edge Functions and verified plain totals fallback when both providers fail. | Nur Damia & Batrisya (**Approved**) |
| **AI-06** | 19/11/2026 | Wan Adam Danish | Gemini | `docs/SRS.pdf` (Appendix A — Client Meeting 05) | Drafted Client Meeting 05 minutes and matching validation rows covering AKP sign-in, role-based rule settings, and PDF print preview confirmation. | Filled in actual meeting attendees, dates, and screenshots; confirmed alignment with single daily check-in/out scope. | Wan Adam Danish & Batrisya (**Approved**) |
| **AI-07** | 19/11/2026 | Abdul Rahim | Gemini | `lib/admin.dart`, `lib/desktop.dart` (`LOGD` D-03) | Diagnosed and fixed `TextEditingController` disposal crashes when closing Add/Edit staff modal sheets and dialogs. | Refactored modal input state handling, ran `flutter test` and `flutter analyze`, and logged resolution under `D-03` in `LOGD`. | Abdul Rahim & Qhairunnisa (**Approved**) |
| **AI-08** | 20/11/2026 | Wan Adam Danish | Gemini | `lib/app_state.dart`, `lib/main.dart` (`FR-01`, `FR-10`) | Integrated Support Staff (AKP) login chip, `DELIMa ID` / `Personal email` toggle, 4-language selector bottom sheet, and live 5-rule password strength modal without adding new screens. | Tested role routing (`Teacher`, `Admin`, `Support staff`), form validation rules, and responsive mobile/desktop login behaviour. | Wan Adam Danish & Qhairunnisa (**Approved**) |
| **AI-09** | 20/11/2026 | Qhairunnisa Shahirah | Gemini | `lib/teacher.dart`, `lib/station.dart` (`FR-03`) | Updated `TeacherHome` and `TeacherProfile` to adapt dynamically for AKP staff (`En. Hafiz`, `7:30 AM`–`4:30 PM`) and wired `StationScreen` countdown to `app.qrRefreshSeconds` (`3`–`5` seconds). | Verified offline scan queuing state, account email status cards, and live 3–5 second QR rotation timer locally. | Qhairunnisa & Abdul Rahim (**Approved**) |
| **AI-10** | 20/11/2026 | Wan Adam Danish | Gemini | `lib/admin.dart` (`FR-10`, `FR-11`, `FR-12`) | Added in-place Attendance Rules modal (role-based check-in/out & QR timing), AKP staff directory with prefix search, and Print Preview → Sent to Printer & Full PDF dialogs. | Verified prefix search matching (`FR-11`), A4 PDF preview layout, and ran `dart format lib/`, `flutter analyze`, and `flutter test` before committing. | Wan Adam Danish & Abdul Rahim (**Approved**) |

---

## Declaration

All AI-assisted code and documentation outputs listed above were reviewed, edited, tested, and approved by Nexus Devs team members prior to merging into the repository in accordance with **Peraturan Akademik UNIMAS (Etika Akademik)** and TMA3084 course guidelines.