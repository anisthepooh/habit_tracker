import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "indicator", "requirements"]

  connect() {
    this.update()
  }

  update() {
    const password = this.inputTarget.value
    const strength = this.calculateStrength(password)
    this.updateIndicator(strength)
    this.updateRequirements(password)
  }

  calculateStrength(password) {
    let score = 0
    const checks = {
      length: password.length >= 8,
      uppercase: /[A-Z]/.test(password),
      lowercase: /[a-z]/.test(password),
      numbers: /\d/.test(password),
      special: /[!@#$%^&*(),.?":{}|<>]/.test(password)
    }

    // Base requirements (required)
    if (checks.length) score += 2
    if (checks.uppercase) score += 2
    if (checks.numbers) score += 2

    // Additional strength indicators
    if (checks.lowercase) score += 1
    if (checks.special) score += 1
    if (password.length >= 12) score += 1

    return {
      score,
      checks,
      level: this.getStrengthLevel(score)
    }
  }

  getStrengthLevel(score) {
    if (score <= 2) return 'weak'
    if (score <= 4) return 'medium'
    if (score <= 6) return 'strong'
    return 'very-strong'
  }

  updateIndicator(strength) {
    const colors = {
      'weak': 'bg-red-500',
      'medium': 'bg-yellow-500',
      'strong': 'bg-blue-500',
      'very-strong': 'bg-green-500'
    }

    const widths = {
      'weak': 'w-1/4',
      'medium': 'w-2/4',
      'strong': 'w-3/4',
      'very-strong': 'w-full'
    }

    const labels = {
      'weak': 'Weak',
      'medium': 'Medium',
      'strong': 'Strong',
      'very-strong': 'Very Strong'
    }

    // Remove all color classes
    Object.values(colors).forEach(color => {
      this.indicatorTarget.classList.remove(color)
    })
    
    // Remove all width classes
    Object.values(widths).forEach(width => {
      this.indicatorTarget.classList.remove(width)
    })

    // Add current classes
    if (this.inputTarget.value.length > 0) {
      this.indicatorTarget.classList.add(colors[strength.level])
      this.indicatorTarget.classList.add(widths[strength.level])
      
      // Update label
      const label = this.indicatorTarget.querySelector('[data-strength-label]')
      if (label) {
        label.textContent = labels[strength.level]
      }
    } else {
      // Empty password - reset indicator
      this.indicatorTarget.classList.add('w-0')
    }
  }

  updateRequirements(password) {
    const requirements = [
      { 
        element: this.requirementsTarget.querySelector('[data-requirement="length"]'),
        met: password.length >= 8
      },
      {
        element: this.requirementsTarget.querySelector('[data-requirement="uppercase"]'),
        met: /[A-Z]/.test(password)
      },
      {
        element: this.requirementsTarget.querySelector('[data-requirement="number"]'),
        met: /\d/.test(password)
      }
    ]

    requirements.forEach(req => {
      if (req.element) {
        const icon = req.element.querySelector('[data-requirement-icon]')
        const text = req.element.querySelector('[data-requirement-text]')
        
        if (req.met) {
          req.element.classList.remove('text-gray-500')
          req.element.classList.add('text-green-600')
          if (icon) icon.textContent = '✓'
          if (text) text.classList.add('line-through')
        } else {
          req.element.classList.remove('text-green-600')
          req.element.classList.add('text-gray-500')
          if (icon) icon.textContent = '○'
          if (text) text.classList.remove('line-through')
        }
      }
    })
  }
}