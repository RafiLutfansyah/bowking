# Modern Luxury Light Design System - Bowking Flutter App

**Date**: 2025-12-26  
**Target Audience**: Premium/luxury service users  
**Theme**: Modern Luxury Light with Rose Gold + Slate accents  
**Status**: Design Approved

---

## 1. COLOR PALETTE & DESIGN TOKENS

### Dominant Colors (Light Background)
- **Primary Background**: `#FAFAF8` (off-white dengan sentuhan warm)
- **Secondary Background**: `#F5F3F0` (soft warm gray untuk surfaces)
- **Tertiary Background**: `#EFEFED` (subtle gray untuk disabled/inactive)

### Accent Colors
- **Rose Gold (Primary Accent)**: `#D4A574` (warm, sophisticated)
- **Rose Gold Light**: `#E8D4C0` (untuk hover/focus states)
- **Rose Gold Dark**: `#B8845C` (untuk pressed states)
- **Slate (Secondary Accent)**: `#2C3E50` (deep, trustworthy)
- **Slate Light**: `#546E7A` (untuk secondary text)

### Semantic Colors
- **Text Primary**: `#1A1A1A` (near-black, excellent contrast)
- **Text Secondary**: `#666666` (medium gray)
- **Text Tertiary**: `#999999` (light gray untuk hints)
- **Success**: `#4CAF50` (soft green)
- **Warning**: `#FF9800` (warm orange)
- **Error**: `#E53935` (soft red)
- **Divider**: `#E0E0E0` (subtle separator)

### Spacing System (8px base)
- `xs`: 4px
- `sm`: 8px
- `md`: 16px
- `lg`: 24px
- `xl`: 32px
- `2xl`: 48px

---

## 2. TYPOGRAPHY SYSTEM

### Display Fonts (Headings)
- **Font Family**: `Playfair Display` (elegant serif, premium feel)
- **Usage**: H1 (page titles), H2 (section headers)
- **Weight**: 700 (bold)
- **Letter Spacing**: -0.5px (sophisticated tightness)

### Body Fonts
- **Font Family**: `Inter` (clean, modern sans-serif)
- **Usage**: Body text, labels, descriptions
- **Weight**: 400 (regular) / 500 (medium) / 600 (semibold)
- **Line Height**: 1.6 (comfortable reading)

### Type Scale
```
H1: 32px / 700 / Playfair Display
H2: 24px / 700 / Playfair Display
H3: 20px / 600 / Inter
Body Large: 16px / 400 / Inter
Body Regular: 14px / 400 / Inter
Body Small: 12px / 400 / Inter
Caption: 11px / 500 / Inter (secondary text)
```

### Text Styles
- **Primary Text**: `#1A1A1A` (near-black)
- **Secondary Text**: `#666666` (medium gray)
- **Tertiary Text**: `#999999` (light gray)
- **Accent Text**: `#D4A574` (rose gold untuk highlights)

### Letter Spacing
- Headings: -0.5px (tight, elegant)
- Body: 0px (normal)
- Labels: 0.5px (slightly spaced untuk clarity)

---

## 3. COMPONENT STYLES

### 3.1 AppBar (Modern Luxury Style)
- **Background**: `#FAFAF8` (off-white)
- **Height**: 56px
- **Elevation**: 0 (flat, no shadow)
- **Title**: Playfair Display 24px / 700 / `#1A1A1A`
- **Divider bottom**: 1px `#E0E0E0`
- **Leading/Trailing icons**: `#2C3E50` (slate)
- **Icon size**: 24px

### 3.2 Button Styles

**Primary Button (Rose Gold)**
- **Background**: `#D4A574` (rose gold)
- **Text**: `#FAFAF8` (off-white)
- **Padding**: 12px horizontal / 16px vertical
- **Border radius**: 6px (subtle, not rounded)
- **Font**: Inter 14px / 600
- **Hover**: Background `#E8D4C0` (lighter rose gold)
- **Pressed**: Background `#B8845C` (darker rose gold)

**Secondary Button (Outline Slate)**
- **Background**: transparent
- **Border**: 1px `#2C3E50` (slate)
- **Text**: `#2C3E50` (slate)
- **Padding**: 12px horizontal / 16px vertical
- **Border radius**: 6px
- **Font**: Inter 14px / 600
- **Hover**: Background `#F5F3F0` (soft gray)

**Tertiary Button (Text Only)**
- **Background**: transparent
- **Text**: `#D4A574` (rose gold)
- **Font**: Inter 14px / 600
- **Hover**: Text `#B8845C` (darker rose gold)

### 3.3 Card Component
- **Background**: `#FAFAF8` (off-white)
- **Border**: 1px `#E0E0E0` (subtle divider)
- **Border radius**: 8px (minimal rounding)
- **Padding**: 16px (md spacing)
- **Shadow**: 0px 2px 8px rgba(0,0,0,0.08) (very subtle)
- **Hover**: Shadow 0px 4px 12px rgba(0,0,0,0.12)

### 3.4 TextField
- **Background**: `#F5F3F0` (soft gray)
- **Border**: 1px `#E0E0E0`
- **Border radius**: 6px
- **Padding**: 12px (sm spacing)
- **Text**: Inter 14px / 400 / `#1A1A1A`
- **Placeholder**: `#999999` (light gray)
- **Focus border**: 2px `#D4A574` (rose gold)
- **Focus shadow**: 0px 0px 0px 3px rgba(212,165,116,0.1)

### 3.5 Badge/Chip
- **Background**: `#E8D4C0` (rose gold light)
- **Text**: `#B8845C` (rose gold dark)
- **Padding**: 4px 8px
- **Border radius**: 4px
- **Font**: Inter 11px / 500

### 3.6 Divider
- **Color**: `#E0E0E0`
- **Thickness**: 1px
- **Margin**: 16px vertical (md spacing)

---

## 4. LAYOUT & SPACING GUIDELINES

### Screen Padding & Margins
- **Screen horizontal padding**: 16px (md spacing) on both sides
- **Screen vertical padding**: 16px (md spacing) top/bottom
- **Safe area**: Respect Flutter's SafeArea widget for notches/status bars

### Content Spacing
- **Section spacing**: 24px (lg spacing) between major sections
- **Component spacing**: 16px (md spacing) between components
- **Element spacing**: 8px (sm spacing) between small elements

### Grid System
- **Base unit**: 8px
- **Column layout**: 2-column for tablet (600dp+), 1-column for mobile
- **Gutter**: 16px between columns

### White Space Strategy
- **Generous negative space** around key elements (buttons, cards)
- **Minimum 16px** between interactive elements
- **Breathing room** around text (padding inside cards/containers)

### Responsive Breakpoints
- **Mobile**: < 600dp (single column, full-width cards)
- **Tablet**: 600dp - 1200dp (2-column layout, optimized spacing)
- **Desktop**: > 1200dp (3-column layout, increased padding)

### Animation & Micro-interactions
- **Fade duration**: 200ms (subtle, not distracting)
- **Scale duration**: 150ms (quick, responsive)
- **Easing**: `Curves.easeInOutCubic` (smooth, natural)
- **Hover effects**: Slight scale (1.02x) + shadow increase
- **Pressed effects**: Scale (0.98x) + shadow decrease
- **No bounce**: Avoid elastic/bounce curves for luxury feel

### Shadows (Elevation System)
- **Elevation 0**: No shadow (flat surfaces)
- **Elevation 1**: `0px 2px 8px rgba(0,0,0,0.08)` (subtle cards)
- **Elevation 2**: `0px 4px 12px rgba(0,0,0,0.12)` (hover/active cards)
- **Elevation 3**: `0px 8px 16px rgba(0,0,0,0.15)` (modals/dialogs)

### Icon System
- **Icon size**: 24px (standard), 20px (small), 32px (large)
- **Icon color**: `#2C3E50` (slate) for primary, `#D4A574` (rose gold) for accents
- **Icon weight**: Thin stroke (1.5px) for elegance
- **Icon spacing**: 8px margin from text

---

## 5. DESIGN PRINCIPLES FOR CONSISTENCY

### Eksklusivitas & Kepercayaan
- Gunakan rose gold untuk highlight premium features
- Gunakan slate untuk action buttons dan primary interactions
- Hindari warna mencolok atau gradient agresif

### Kesederhanaan & Elegance
- Maksimalkan white space
- Minimal decoration, maksimal clarity
- Setiap elemen harus punya purpose

### Responsiveness
- Mobile-first approach
- Tablet optimization dengan 2-column layout
- Maintain consistency across all breakpoints

### Accessibility
- Minimum contrast ratio 4.5:1 untuk text
- Focus states harus jelas (rose gold border)
- Icon + text untuk clarity

---

## 6. IMPLEMENTATION SCOPE

### Design System Files to Create
1. `lib/core/theme/app_colors.dart` - Color constants
2. `lib/core/theme/app_typography.dart` - Text themes
3. `lib/core/theme/app_theme.dart` - Updated ThemeData
4. `lib/core/theme/app_spacing.dart` - Spacing constants
5. `lib/core/widgets/custom_button.dart` - Button variants
6. `lib/core/widgets/custom_card.dart` - Card component
7. `lib/core/widgets/custom_text_field.dart` - TextField component

### Screen Examples to Refactor
1. **HomePage** - Hero section, service cards, call-to-action
2. **WalletPage** - Balance display, transaction list, actions
3. **ServicesPage** - Service grid, filters, details

### Responsive Considerations
- Mobile: 360dp - 599dp
- Tablet: 600dp - 1199dp
- Desktop: 1200dp+

---

## 7. NEXT STEPS

1. Create design system files with color, typography, and spacing constants
2. Update `AppTheme` with new color scheme and text themes
3. Create custom widget components (Button, Card, TextField)
4. Refactor HomePage, WalletPage, ServicesPage with new design
5. Test responsive behavior across breakpoints
6. Verify accessibility and contrast ratios
