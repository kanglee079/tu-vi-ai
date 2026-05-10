---
name: Oriental Futurism
colors:
  surface: '#16130b'
  surface-dim: '#16130b'
  surface-bright: '#3d392f'
  surface-container-lowest: '#110e06'
  surface-container-low: '#1e1b13'
  surface-container: '#221f16'
  surface-container-high: '#2d2a20'
  surface-container-highest: '#38342b'
  on-surface: '#e9e2d3'
  on-surface-variant: '#d0c5af'
  inverse-surface: '#e9e2d3'
  inverse-on-surface: '#343026'
  outline: '#99907c'
  outline-variant: '#4d4635'
  surface-tint: '#e9c349'
  primary: '#f2ca50'
  on-primary: '#3c2f00'
  primary-container: '#d4af37'
  on-primary-container: '#554300'
  inverse-primary: '#735c00'
  secondary: '#ffb4ac'
  on-secondary: '#690007'
  secondary-container: '#960711'
  on-secondary-container: '#ff9f95'
  tertiary: '#62e6a2'
  on-tertiary: '#003921'
  tertiary-container: '#41c989'
  on-tertiary-container: '#005030'
  error: '#ffb4ab'
  on-error: '#690005'
  error-container: '#93000a'
  on-error-container: '#ffdad6'
  primary-fixed: '#ffe088'
  primary-fixed-dim: '#e9c349'
  on-primary-fixed: '#241a00'
  on-primary-fixed-variant: '#574500'
  secondary-fixed: '#ffdad6'
  secondary-fixed-dim: '#ffb4ac'
  on-secondary-fixed: '#410003'
  on-secondary-fixed-variant: '#92030f'
  tertiary-fixed: '#78fbb6'
  tertiary-fixed-dim: '#59de9b'
  on-tertiary-fixed: '#002111'
  on-tertiary-fixed-variant: '#005232'
  background: '#16130b'
  on-background: '#e9e2d3'
  surface-variant: '#38342b'
typography:
  headline-xl:
    fontFamily: EB Garamond
    fontSize: 40px
    fontWeight: '600'
    lineHeight: 48px
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: EB Garamond
    fontSize: 32px
    fontWeight: '500'
    lineHeight: 40px
  headline-md:
    fontFamily: EB Garamond
    fontSize: 24px
    fontWeight: '500'
    lineHeight: 32px
  body-lg:
    fontFamily: Manrope
    fontSize: 18px
    fontWeight: '400'
    lineHeight: 28px
  body-md:
    fontFamily: Manrope
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  body-sm:
    fontFamily: Manrope
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
  label-md:
    fontFamily: Manrope
    fontSize: 12px
    fontWeight: '600'
    lineHeight: 16px
    letterSpacing: 0.05em
  headline-lg-mobile:
    fontFamily: EB Garamond
    fontSize: 28px
    fontWeight: '500'
    lineHeight: 36px
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  unit: 8px
  container-padding-mobile: 20px
  container-padding-desktop: 40px
  gutter: 16px
  section-gap: 32px
---

## Brand & Style
The design system bridges the gap between ancient Eastern divination and modern computational intelligence. The brand personality is "The Scholar-Mystic"—authoritative, precise, yet deeply attuned to the ethereal. 

The visual style is **Oriental Futurism**, a blend of **Glassmorphism** and **Minimalism**. It utilizes semi-transparent surfaces to represent the "veil" between worlds, while maintaining the structural rigor of scientific software. The user experience should feel like reading a high-tech silk scroll: fluid, premium, and inherently trustworthy. Every interaction should feel intentional, avoiding clutter in favor of focus and serenity.

## Colors
The palette is rooted in imperial tradition but applied with modern digital sensibilities. 

- **Primary (Royal Gold):** Used for key astrological insights, focus states, and premium iconography. It represents enlightenment and the sun.
- **Secondary (Imperial Red):** Reserved for high-priority calls to action and primary navigational elements. It symbolizes vitality and destiny.
- **Background (Midnight Blue):** The primary canvas, evoking the night sky. In light-mode scenarios, the **Parchment Cream** acts as the primary background to mimic aged paper.
- **Accents:** **Jade Green** signifies growth, health, and positive planetary alignments. **Bronze** is used for borders, divider lines, and subtle structural elements.

## Typography
This design system employs a sophisticated typographic pairing to balance the mystical with the scientific.

- **Headlines:** **EB Garamond** provides a literary, historical weight. It should be used for all major titles, horoscope names, and "Minh Mệnh" insights.
- **Body & UI:** **Manrope** is used for all functional data, AI explanations, and interactive labels. Its clean, geometric nature ensures the "Scientific AI" aspect is legible and modern.
- **Stylistic Note:** Use "Title Case" for headings to maintain a formal, traditional tone. Apply slight tracking (letter-spacing) to labels to enhance the premium feel.

## Layout & Spacing
The layout follows a **Fluid Grid** system based on an 8px base unit. 

- **Margins:** Mobile screens utilize a 20px side margin, while tablets and desktops expand to 40px to provide breathing room for complex astrological charts.
- **Rhythm:** Vertical rhythm is strictly enforced with 32px or 48px gaps between major sections to prevent visual clutter, reflecting a "Zen" philosophy of space.
- **Adaptation:** On mobile, content stacks vertically with cards spanning the full width. On larger screens, the design system utilizes a multi-column approach where the primary natal chart remains centered or left-aligned with modular AI insights appearing in adjacent panels.

## Elevation & Depth
Depth is conveyed through **Glassmorphism** and **Tonal Layering** rather than heavy shadows.

- **Surfaces:** Use backdrop filters (blur: 12px to 20px) on containers. Against the Midnight Blue background, glass surfaces should have a 10% white or 5% gold tint.
- **Outlines:** Instead of shadows, use "Bronze" or "Gold" inner strokes (0.5pt) to define the edges of floating cards.
- **Shadows:** When necessary for high-level modals, use "Ambient Shadows"—diffused, low-opacity (#000000 at 15%) with a large spread (24px) to create a soft, ethereal lift.

## Shapes
The shape language is **Rounded**, avoiding harsh corners to maintain a "soft" and approachable mystical aesthetic.

- **Corner Radius:** Standard components use a 16px (1rem) radius. Large cards and containers use 24px (1.5rem).
- **Iconography:** Icons should feature rounded terminals and consistent stroke weights (1.5px).
- **Decorative Elements:** Incorporate the "Enso" (circle) and "Lotus" geometry. Geometric borders should be used sparingly as containers for "Minh Mệnh" summary insights, blending traditional fretwork with modern rounded corners.

## Components
- **Buttons:** Primary buttons use a solid **Imperial Red** fill with **Parchment Cream** text. Secondary buttons are "Ghost" style with a **Royal Gold** 1px border and glass background.
- **Cards:** The central component of the app. Features a backdrop blur, a subtle bronze stroke, and a corner watermark of a traditional cloud or lotus pattern at 5% opacity.
- **Input Fields:** Minimalist lines rather than boxes. The bottom border glows with a **Royal Gold** gradient when active.
- **Progress Indicators:** Circular "Bagua" inspired loaders or pulsing lotus petals for AI processing states.
- **Astrology Charts:** Vector-based paths in **Royal Gold** and **Jade Green**, utilizing thin strokes and soft-glow outer blurs to appear as if projected in light.
- **Chips/Tags:** Used for "Planet" or "Element" indicators. Small, pill-shaped with **Jade Green** (Wood), **Imperial Red** (Fire), or **Midnight Blue** (Water) subtle backgrounds.