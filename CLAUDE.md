# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Application Overview

This is a modern Rails 8.0 habit tracking application with PWA capabilities. Users can create, track, and manage daily habits with streak tracking, progress visualization, and social features.

## Development Commands

**Setup:**
```bash
bundle install
rails db:create db:migrate db:seed
```

**Development Server:**
```bash
bin/dev  # Starts Rails server + TailwindCSS watcher
# or manually:
rails server
```

**Testing:**
```bash
rails test                    # Run all tests
rails test test/models/       # Run model tests
rails test test/controllers/  # Run controller tests  
rails test:system            # Run system tests
```

**Code Quality:**
```bash
rubocop           # Ruby linting
brakeman          # Security scanning
```

**Database:**
```bash
rails db:migrate              # Run migrations
rails db:rollback             # Rollback last migration
rails db:reset                # Drop, create, migrate, seed
```

## Architecture

**Core Models:**
- `User` - Authentication and profiles
- `Group` - Organization unit for users and habits
- `Habit` - Core tracking entity with streaks and frequency
- `Entry` - Daily habit completions with mood tracking
- `PublicActivity::Activity` - Activity feed
- `Noticed::Event` - Notifications system

**Frontend Stack:**
- Hotwire (Turbo + Stimulus) for SPA-like experience
- ViewComponent for reusable UI components
- TailwindCSS 4.x + shadcn/ui for styling
- Alpine.js for lightweight JavaScript interactions
- Import maps (no bundler needed)

**Key Gems:**
- `noticed` - Notifications system
- `public_activity` - Activity tracking
- `flipper` - Feature flags
- `chartkick` + `groupdate` - Data visualization
- `ransack` - Search/filtering
- `view_component` - Component architecture
- `solid_*` gems - Production performance (queue, cache, cable)

**Admin Interface:**
- Separate `/admin` namespace
- Admin user authentication via `User#admin?`
- Admin controllers in `app/controllers/admin/`

## Testing Patterns

- Uses Rails minitest with parallel execution
- System tests with Capybara for end-to-end testing
- ViewComponent tests in `test/components/`
- All fixtures loaded automatically
- Test data in `test/fixtures/*.yml`

## Database Configuration

- SQLite3 for development and production
- Multi-database setup in production (primary, cache, queue, cable)
- Active Storage for file uploads
- Comprehensive indexing for performance

## Deployment

- Docker-based deployment with Kamal
- Configured with Thruster for HTTP acceleration
- Sentry for error monitoring
- Resend for transactional emails