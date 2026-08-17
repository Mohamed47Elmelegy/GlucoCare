---
name: DoseTrack Medical App Design System
colors:
  surface: '#FFFFFF'
  surface-dim: '#d8d9e3'
  surface-bright: '#f9f9ff'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f2f3fd'
  surface-container: '#ecedf7'
  surface-container-high: '#e6e7f2'
  surface-container-highest: '#e1e2ec'
  on-surface: '#191b23'
  on-surface-variant: '#424754'
  inverse-surface: '#2e3038'
  inverse-on-surface: '#eff0fa'
  outline: '#727785'
  outline-variant: '#c2c6d6'
  surface-tint: '#005ac2'
  primary: '#0058be'
  on-primary: '#ffffff'
  primary-container: '#2170e4'
  on-primary-container: '#fefcff'
  inverse-primary: '#adc6ff'
  secondary: '#006c49'
  on-secondary: '#ffffff'
  secondary-container: '#6cf8bb'
  on-secondary-container: '#00714d'
  tertiary: '#924700'
  on-tertiary: '#ffffff'
  tertiary-container: '#b75b00'
  on-tertiary-container: '#fffbff'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#d8e2ff'
  primary-fixed-dim: '#adc6ff'
  on-primary-fixed: '#001a42'
  on-primary-fixed-variant: '#004395'
  secondary-fixed: '#6ffbbe'
  secondary-fixed-dim: '#4edea3'
  on-secondary-fixed: '#002113'
  on-secondary-fixed-variant: '#005236'
  tertiary-fixed: '#ffdcc6'
  tertiary-fixed-dim: '#ffb786'
  on-tertiary-fixed: '#311400'
  on-tertiary-fixed-variant: '#723600'
  background: '#F8FAFC'
  on-background: '#191b23'
  surface-variant: '#e1e2ec'
  warning: '#F59E0B'
  danger: '#EF4444'
  text-primary: '#1E293B'
  text-secondary: '#64748B'
  border: '#E2E8F0'
  status-taken-bg: '#D1FAE5'
  status-taken-text: '#065F46'
  status-missed-bg: '#FEE2E2'
  status-missed-text: '#991B1B'
  status-upcoming-bg: '#DBEAFE'
  status-upcoming-text: '#1E40AF'
  dark-background: '#0F172A'
  dark-surface: '#1E293B'
  dark-text: '#F1F5F9'
  dark-border: '#334155'
typography:
  h1:
    fontFamily: Cairo
    fontSize: 28px
    fontWeight: '700'
    lineHeight: '1.2'
  h2:
    fontFamily: Cairo
    fontSize: 22px
    fontWeight: '600'
    lineHeight: '1.3'
  h3:
    fontFamily: Cairo
    fontSize: 18px
    fontWeight: '600'
    lineHeight: '1.4'
  body:
    fontFamily: Cairo
    fontSize: 16px
    fontWeight: '400'
    lineHeight: '1.5'
  caption:
    fontFamily: Cairo
    fontSize: 13px
    fontWeight: '400'
    lineHeight: '1.4'
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  base: 8px
  gap: 12px
  card-padding: 16px
  screen-edge: 20px
---

# DESIGN.md — DoseTrack Medical App

## Brand
- **App Name:** DoseTrack
- **Tagline:** صحتك في يدك
- **Language:** Arabic (RTL)
- **Platform:** Flutter Mobile (iOS + Android)

## Color Palette
- **Primary:** #3B82F6 (Blue)
- **Secondary:** #10B981 (Green)
- **Warning:** #F59E0B (Amber)
- **Danger:** #EF4444 (Red)
- **Background:** #F8FAFC
- **Card:** #FFFFFF
- **Text Primary:** #1E293B
- **Text Secondary:** #64748B
- **Border:** #E2E8F0

## Typography
- **Font Family:** Cairo (Arabic), Inter (fallback)
- **Direction:** RTL
- **H1:** 28px / Bold
- **H2:** 22px / SemiBold
- **H3:** 18px / SemiBold
- **Body:** 16px / Regular
- **Caption:** 13px / Regular

## Spacing
- **Base unit:** 8px
- **Card padding:** 16px
- **Screen padding:** 20px
- **Gap between elements:** 12px

## Border Radius
- **Cards:** 16px
- **Buttons:** 12px
- **Inputs:** 10px
- **Chips:** 20px (pill)

## Shadows
- **Card shadow:** 0px 2px 12px rgba(0,0,0,0.08)
- **Button shadow:** none

## Components
- Primary Button: filled #3B82F6, white text, 12px radius, height 52px
- Secondary Button: outlined #3B82F6, blue text
- Input Field: border #E2E8F0, focus border #3B82F6, height 52px
- Status Chip — Taken: background #D1FAE5, text #065F46
- Status Chip — Missed: background #FEE2E2, text #991B1B
- Status Chip — Upcoming: background #DBEAFE, text #1E40AF
- Bottom Navigation: 5 tabs, icons + Arabic labels
- Cards: white, 16px radius, soft shadow

## Icons
- Style: Outline (Phosphor Icons)
- Size: 24px default, 20px in lists

## Dark Mode
- Background: #0F172A
- Card: #1E293B
- Text: #F1F5F9
- Border: #334155