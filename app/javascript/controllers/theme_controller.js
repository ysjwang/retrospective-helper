import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["body", "toggle"]
  static values = { theme: String }

  connect() {
    console.log("Theme controller connected")
    this.loadTheme()
  }

  loadTheme() {
    // Get theme from cookie or default to 'retro'
    const savedTheme = this.getCookie('theme') || 'retro'
    this.themeValue = savedTheme
    this.applyTheme(savedTheme)
    this.updateToggleState()
  }

  toggle() {
    const newTheme = this.themeValue === 'retro' ? 'professional' : 'retro'
    this.themeValue = newTheme
    this.applyTheme(newTheme)
    this.saveToCookie(newTheme)
    this.updateToggleState()
  }

  applyTheme(theme) {
    const body = document.body
    body.classList.remove('theme-retro', 'theme-professional')
    body.classList.add(`theme-${theme}`)
  }

  updateToggleState() {
    if (this.hasToggleTarget) {
      const isRetro = this.themeValue === 'retro'
      this.toggleTarget.textContent = isRetro ? 'Professional Mode' : 'Retro Mode'
      this.toggleTarget.title = isRetro ? 'Switch to Professional theme' : 'Switch to Retro theme'
    }
  }

  saveToCookie(theme) {
    document.cookie = `theme=${theme}; path=/; max-age=31536000; SameSite=Lax`
  }

  getCookie(name) {
    const value = `; ${document.cookie}`;
    const parts = value.split(`; ${name}=`);
    if (parts.length === 2) return parts.pop().split(';').shift();
  }
}