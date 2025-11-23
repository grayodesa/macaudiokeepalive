# GitHub Publication Checklist

This checklist guides the preparation of this repository for public GitHub publication as an educational fork.

## 🎯 Publication Goal
- **Purpose**: Educational study fork (no binary releases yet)
- **Audience**: Developers studying macOS audio programming and Objective-C
- **License**: Unlicense (public domain) - allows free use and modification
- **Attribution**: Fork of milgra/macaudiokeepalive with v2.0 enhancements

---

## Phase 1: Repository Cleanup

### Files to Remove (Not Useful for Public)
- [ ] `logs.txt` - Runtime debug logs with local device info
- [ ] `Build Mac Audio Keepalive_2025-11-16T23-35-36.txt` - Build output log
- [ ] `.DS_Store` - macOS folder metadata
- [ ] `.serena/` directory - Personal MCP workflow data (44K)

**Commands:**
```bash
rm logs.txt
rm "Build Mac Audio Keepalive_2025-11-16T23-35-36.txt"
rm .DS_Store
rm -rf .serena/
```

### Files to Review/Decide
- [ ] **`claudedocs/`** directory - Contains development specs and session notes
  - **Option A (Recommended)**: Keep for educational value, rename to `docs/development/`
  - **Option B**: Remove as personal workflow artifacts

  **If keeping:**
  ```bash
  mkdir -p docs/development
  mv claudedocs/* docs/development/
  rmdir claudedocs
  ```

  **If removing:**
  ```bash
  rm -rf claudedocs/
  ```

---

## Phase 2: Update .gitignore

### Add Missing Patterns
- [ ] Update `.gitignore` to exclude development files

**Add these lines to `.gitignore`:**
```gitignore
# Development and debug files
.DS_Store
logs.txt
Build*.txt
.serena/

# Optional: If keeping development docs outside repo
# docs/development/
```

**Command:**
```bash
# Append to .gitignore
cat >> .gitignore << 'EOF'

# Development and debug files
.DS_Store
logs.txt
Build*.txt
.serena/
EOF
```

---

## Phase 3: Documentation Updates

### Update README.md
- [ ] Add v2.0 feature description
- [ ] Add fork attribution
- [ ] Add "educational purposes" notice
- [ ] Update version from 1.2 to 2.0
- [ ] Add build instructions
- [ ] Add development setup guide

**Suggested README additions:**

```markdown
## Attribution
This is an educational fork of [milgra/macaudiokeepalive](https://github.com/milgra/macaudiokeepalive)
with v2.0 enhancements. Original concept and v1.x implementation by Milan Toth.

## What's New in v2.0
- **Interval-based scheduling**: Configure audio pulses at regular intervals (5-30 minutes)
- **User preferences**: Persistent settings via NSUserDefaults
- **Preferences UI**: Easy configuration through preferences window
- **Dual audio modes**: Continuous (original behavior) or interval-based
- **Enhanced architecture**: Modular design with AudioController, AudioScheduler, SettingsManager

## Status
⚠️ **Educational fork for study purposes** - No binary releases available yet.
This fork demonstrates advanced macOS audio programming patterns and application architecture.
```

### Review CLAUDE.md
- [ ] Verify no sensitive/personal information
- [ ] Confirm it's useful for public study (it is!)
- [ ] Keep as-is - excellent documentation

### Optional: Additional Documentation
- [ ] Create `CONTRIBUTING.md` if welcoming contributions/feedback
- [ ] Create `docs/ARCHITECTURE.md` for deep technical details
- [ ] Create `docs/BUILDING.md` for detailed build instructions

---

## Phase 4: Code Review

### Security & Privacy Scan
- [ ] Verify no API keys in code
- [ ] Verify no credentials in code
- [ ] Verify no personal file paths in code
- [ ] Check Info.plist for personal identifiers (should be clean)
- [ ] Review copyright notices

**Quick scan commands:**
```bash
# Search for common sensitive patterns
rg -i "api[_-]?key|password|secret|token" --type objc
rg -i "\/Users\/[^\/]*\/" --type objc
rg -i "private|confidential" --type objc
```

### Code Quality Check
- [ ] All new files have header documentation
- [ ] Unconventional spacing style is consistent
- [ ] No compiler warnings (test with Xcode)
- [ ] No analyzer warnings (Product → Analyze in Xcode)

---

## Phase 5: Git Operations

### Commit Strategy Decision
Choose one approach:

#### Option A: Single Clean Commit (Recommended for Educational Fork)
- [ ] Stage all v2.0 changes
- [ ] Create single comprehensive commit
- [ ] Tag as v2.0.0

**Commands:**
```bash
git add .
git commit -m "feat: v2.0 with interval scheduling and preferences UI

Major enhancements to original v1.2:
- Add interval-based audio scheduling (AudioScheduler)
- Add user preferences persistence (SettingsManager)
- Add preferences window UI (PreferencesWindowController)
- Add audio mode orchestration (AudioController)
- Update to v2.0.0 in Info.plist
- Add comprehensive documentation (CLAUDE.md)

This fork extends the original concept for educational purposes,
demonstrating advanced macOS audio programming patterns."

git tag -a v2.0.0 -m "Version 2.0.0 - Interval scheduling and preferences"
```

#### Option B: Multiple Logical Commits
- [ ] Commit 1: Cleanup (`.gitignore`, remove files, docs)
- [ ] Commit 2: Settings management (SettingsManager)
- [ ] Commit 3: Audio scheduling (AudioScheduler)
- [ ] Commit 4: Preferences UI (PreferencesWindowController)
- [ ] Commit 5: Integration (AudioController, AppDelegate updates)
- [ ] Tag as v2.0.0

---

## Phase 6: GitHub Repository Setup

### Repository Creation Decision
Choose one approach:

#### Option A: New Independent Repository (Recommended)
**Pros:** Clean history, no confusion with original, better discoverability
**Cons:** Not shown as fork on GitHub

- [ ] Create new repository on GitHub
- [ ] Name: `macaudiokeepalive` or `macaudiokeepalive-v2`
- [ ] Description: "macOS menu bar app preventing optical/HDMI audio dropout (v2.0 educational fork)"
- [ ] Public visibility
- [ ] Initialize without README (you have one)

**Commands:**
```bash
# Remove original remote
git remote remove origin

# Add your new remote (replace USERNAME)
git remote add origin git@github.com:USERNAME/macaudiokeepalive.git

# Push with tags
git push -u origin master --tags
```

#### Option B: GitHub Fork
**Pros:** Shows fork relationship, automatic upstream tracking
**Cons:** Less discoverable, some GitHub features limited for forks

- [ ] Fork milgra/macaudiokeepalive on GitHub
- [ ] Clone your fork locally
- [ ] Cherry-pick or merge your v2.0 changes
- [ ] Push to your fork

### Repository Configuration
- [ ] Set repository to **Public**
- [ ] Add description: "macOS menu bar app preventing optical/HDMI audio dropout (v2.0 educational fork)"
- [ ] Add topics/tags: `macos`, `objective-c`, `audio`, `core-audio`, `menu-bar-app`, `educational`
- [ ] Add README notice in description: "🎓 Educational fork - no binary releases yet"
- [ ] Enable Issues for study discussions (optional)
- [ ] Disable Wikis (optional)
- [ ] Disable Projects (optional)

---

## Phase 7: Post-Publication Verification

### Verify Repository
- [ ] Clone repository in fresh directory
- [ ] Verify all files are present
- [ ] Verify no unwanted files included (logs, .serena, etc.)
- [ ] Build project in Xcode from clean checkout
- [ ] Verify build succeeds without errors
- [ ] Run application to verify functionality

**Test commands:**
```bash
cd /tmp
git clone YOUR_REPO_URL test-clone
cd test-clone
open "Mac Audio Keepalive.xcodeproj"
# Build in Xcode (⌘B)
# Run in Xcode (⌘R)
```

### GitHub Polish
- [ ] Update repository description if needed
- [ ] Add repository topics if forgotten
- [ ] Pin repository if desired (on your profile)
- [ ] Update personal README or documentation with link

### Final Documentation Check
- [ ] README renders correctly on GitHub
- [ ] CLAUDE.md renders correctly on GitHub
- [ ] License file visible in repository
- [ ] Code is easily browsable on GitHub

---

## Decision Points Summary

Before starting, decide on:

| Decision | Options | Recommendation |
|----------|---------|----------------|
| **claudedocs/** | Keep (rename to `docs/development/`) or Remove | **Keep** - Educational value |
| **Commit strategy** | Single commit or Multiple commits | **Single** - Cleaner for study |
| **Repository type** | New independent or GitHub fork | **New independent** - Better discoverability |
| **Repository name** | `macaudiokeepalive` or `macaudiokeepalive-v2` | `macaudiokeepalive` - Simpler |
| **Additional docs** | Create CONTRIBUTING.md, etc. | **Optional** - Add later if needed |

---

## Quick Start (Recommended Path)

If you want the fastest clean publication:

```bash
# 1. Clean unwanted files
rm logs.txt "Build Mac Audio Keepalive_2025-11-16T23-35-36.txt" .DS_Store
rm -rf .serena/
mkdir -p docs/development && mv claudedocs/* docs/development/ && rmdir claudedocs

# 2. Update .gitignore
cat >> .gitignore << 'EOF'

# Development and debug files
.DS_Store
logs.txt
Build*.txt
.serena/
EOF

# 3. Stage and commit
git add .
git commit -m "feat: v2.0 with interval scheduling and preferences UI

Major enhancements to original v1.2:
- Add interval-based audio scheduling (AudioScheduler)
- Add user preferences persistence (SettingsManager)
- Add preferences window UI (PreferencesWindowController)
- Add audio mode orchestration (AudioController)

Educational fork for studying macOS audio programming patterns."

git tag -a v2.0.0 -m "Version 2.0.0 - Interval scheduling and preferences"

# 4. Create GitHub repo and push
# (Create new repo on GitHub first, then:)
git remote remove origin
git remote add origin git@github.com:YOUR_USERNAME/macaudiokeepalive.git
git push -u origin master --tags
```

---

## Estimated Timeline

- **Minimal cleanup**: 30-45 minutes
- **Complete cleanup with docs**: 2-3 hours
- **Including testing**: 3-4 hours

---

## Notes

- All sensitive data scans came back clean ✅
- License (Unlicense/public domain) allows unlimited forking ✅
- Original author credit will be maintained in README ✅
- Educational purpose is clearly stated ✅

Good luck with the publication! 🚀
