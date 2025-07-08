
import { Controller } from "@hotwired/stimulus"

// Stimulus is Rails' way of adding JavaScript behavior
export default class extends Controller {
  static targets = ["container", "count"]
  
  connect() {
    console.log("Suggestions controller connected")
    this.updateCount()
  }
  
  // Called when suggestions are added/removed
  updateCount() {
    const count = this.containerTarget.children.length
    if (this.hasCountTarget) {
      this.countTarget.textContent = count
    }
  }
  
  // Handle suggestion acceptance
  accept(event) {
    const suggestionId = event.currentTarget.dataset.suggestionId
    this.updateSuggestion(suggestionId, 'accepted')
  }
  
  // Handle suggestion dismissal  
  dismiss(event) {
    const suggestionId = event.currentTarget.dataset.suggestionId
    this.updateSuggestion(suggestionId, 'dismissed')
  }
  
  async updateSuggestion(id, status) {
    try {
      const response = await fetch(`/suggestions/${id}`, {
        method: 'PATCH',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': this.csrfToken()
        },
        body: JSON.stringify({ suggestion: { status } })
      })
      
      if (response.ok) {
        // Rails way: let the server handle the update
        const card = this.element.querySelector(`[data-suggestion-id="${id}"]`)
        this.markSuggestionAs(card, status)
      }
    } catch (error) {
      console.error('Error updating suggestion:', error)
    }
  }
  
  markSuggestionAs(card, status) {
    card.classList.add('opacity-75')
    const buttons = card.querySelectorAll('button')
    buttons.forEach(btn => btn.disabled = true)
    
    // Add status indicator
    const badge = document.createElement('span')
    badge.className = `badge ${status === 'accepted' ? 'badge-green' : 'badge-red'}`
    badge.textContent = status.toUpperCase()
    card.querySelector('.suggestion-header').appendChild(badge)
  }
  
  csrfToken() {
    return document.querySelector('[name="csrf-token"]').content
  }
}