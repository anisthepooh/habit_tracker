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
rails test test/components/   # Run ViewComponent tests  
rails test:system            # Run system tests
rails test test/models/user_test.rb  # Run specific test file
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
- `User` - Authentication and profiles with timezone support
- `Group` - Organization unit for users and habits
- `Habit` - Core tracking entity with streaks, status, and reminders
- `Entry` - Daily habit completions with mood tracking
- `Session` - Custom session management with IP/user agent tracking
- `PublicActivity::Activity` - Activity feed
- `Noticed::Event` - Notifications system

**Authentication:**
- Custom session-based authentication (not Devise)
- Current object pattern for request-scoped data
- Role-based access with `User#admin?`

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
- `resend` - Transactional email service
- `will_paginate` - Pagination
- `sentry-ruby` - Error monitoring

**Admin Interface:**
- Separate `/admin` namespace
- Admin user authentication via `User#admin?`
- Admin controllers in `app/controllers/admin/`
- Flipper UI for feature flags at `/flipper`
- Admin dashboard with user statistics and communication tools

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

## PWA Features

- Service worker for offline functionality  
- Web app manifest for mobile installation
- Progressive enhancement approach

## Deployment

- Docker-based deployment with Kamal
- Configured with Thruster for HTTP acceleration
- Sentry for error monitoring
- Resend for transactional emails

## Key Development Patterns

- Strong parameters with modern `expect` syntax
- ViewComponent architecture for reusable UI
- Activity tracking across all major models
- Timezone-aware habit scheduling and streaks
- Comprehensive notification system with multiple channels
- Feature flag management for gradual rollouts

## Authentication System Implementation

**Custom Authentication Pattern:**
- Uses `Current` object with `ActiveSupport::CurrentAttributes` for request-scoped data
- Session management via `Authentication` concern included in `ApplicationController`
- Session cookie: `cookies.signed.permanent[:session_id]` with httponly and same_site protection
- Authentication flow: `require_authentication` → `resume_session` → `find_session_by_cookie`
- Session tracking includes IP address and user agent for security

**Key Authentication Files:**
- `app/controllers/concerns/authentication.rb` - Main authentication logic
- `app/models/current.rb` - Request-scoped session/user access
- `app/models/session.rb` - Session persistence model
- `app/models/user.rb` - User model with `has_secure_password`
- Authentication routes: login/logout at `/session`, signup at `/signup`

**Authentication Helpers:**
- `authenticated?` - Check if user is logged in
- `Current.user` - Access current user from anywhere
- `start_new_session_for(user)` - Create new session
- `terminate_session` - Logout functionality
- `after_authentication_url` - Redirect after login

## Component Architecture

**ViewComponent Pattern:**
- All UI components in `app/components/` directory
- Component-specific CSS and JavaScript via ViewComponent
- Reusable components: `ButtonComponent`, `AvatarComponent`, `SelectComponent`, `StatCardComponent`
- Sidebar components: `SidebarLinkComponent`, `SidebarAccordionComponent`
- List and activity components: `ListViewComponent`, `ActivityComponent`

**Stimulus Integration:**
- Stimulus controllers for interactive behavior
- Import maps for JavaScript dependencies
- Alpine.js for lightweight interactions