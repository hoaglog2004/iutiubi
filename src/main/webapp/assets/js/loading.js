/**
 * Loading States and UI Feedback Utilities
 * Provides helper functions for loading spinners, toasts, lazy loading, and more
 */

const LoadingUtils = {
    // Toast container reference
    toastContainer: null,

    /**
     * Initialize the loading utilities
     */
    init: function() {
        // Create toast container if it doesn't exist
        if (!this.toastContainer) {
            this.toastContainer = document.createElement('div');
            this.toastContainer.className = 'toast-container';
            document.body.appendChild(this.toastContainer);
        }

        // Initialize lazy loading for images
        this.initLazyLoading();
    },

    /**
     * Show a loading overlay
     * @param {string} message - Optional message to display
     * @returns {HTMLElement} - The overlay element
     */
    showOverlay: function(message = 'Đang tải...') {
        let overlay = document.getElementById('loading-overlay');
        
        if (!overlay) {
            overlay = document.createElement('div');
            overlay.id = 'loading-overlay';
            overlay.className = 'loading-overlay';
            overlay.innerHTML = `
                <div class="loading-content">
                    <div class="loading-spinner large"></div>
                    <div class="loading-text">${message}</div>
                </div>
            `;
            document.body.appendChild(overlay);
        } else {
            overlay.querySelector('.loading-text').textContent = message;
        }
        
        setTimeout(() => overlay.classList.add('active'), 10);
        return overlay;
    },

    /**
     * Hide the loading overlay
     */
    hideOverlay: function() {
        const overlay = document.getElementById('loading-overlay');
        if (overlay) {
            overlay.classList.remove('active');
            setTimeout(() => overlay.remove(), 300);
        }
    },

    /**
     * Show a toast notification
     * @param {string} message - The message to display
     * @param {string} type - Type: 'success', 'error', 'warning', 'info'
     * @param {number} duration - Duration in milliseconds (0 for no auto-hide)
     */
    showToast: function(message, type = 'info', duration = 5000) {
        if (!this.toastContainer) {
            this.init();
        }

        const icons = {
            success: 'fas fa-check-circle',
            error: 'fas fa-times-circle',
            warning: 'fas fa-exclamation-triangle',
            info: 'fas fa-info-circle'
        };

        const toast = document.createElement('div');
        toast.className = `toast toast-${type}`;
        toast.innerHTML = `
            <i class="toast-icon ${icons[type] || icons.info}"></i>
            <span class="toast-message">${message}</span>
            <button class="toast-close" onclick="LoadingUtils.closeToast(this.parentElement)">
                <i class="fas fa-times"></i>
            </button>
        `;

        this.toastContainer.appendChild(toast);

        // Auto-hide after duration
        if (duration > 0) {
            setTimeout(() => this.closeToast(toast), duration);
        }

        return toast;
    },

    /**
     * Close a specific toast
     * @param {HTMLElement} toast - The toast element to close
     */
    closeToast: function(toast) {
        if (toast && toast.parentElement) {
            toast.classList.add('hiding');
            setTimeout(() => toast.remove(), 300);
        }
    },

    /**
     * Show success toast
     * @param {string} message - The message to display
     */
    success: function(message) {
        return this.showToast(message, 'success');
    },

    /**
     * Show error toast
     * @param {string} message - The message to display
     */
    error: function(message) {
        return this.showToast(message, 'error');
    },

    /**
     * Show warning toast
     * @param {string} message - The message to display
     */
    warning: function(message) {
        return this.showToast(message, 'warning');
    },

    /**
     * Show info toast
     * @param {string} message - The message to display
     */
    info: function(message) {
        return this.showToast(message, 'info');
    },

    /**
     * Set button to loading state
     * @param {HTMLElement} button - The button element
     * @param {boolean} loading - Whether to show loading state
     */
    setButtonLoading: function(button, loading) {
        if (loading) {
            button.classList.add('btn-loading');
            button.disabled = true;
            if (!button.querySelector('.btn-text')) {
                button.innerHTML = `<span class="btn-text">${button.innerHTML}</span>`;
            }
        } else {
            button.classList.remove('btn-loading');
            button.disabled = false;
            const btnText = button.querySelector('.btn-text');
            if (btnText) {
                button.innerHTML = btnText.innerHTML;
            }
        }
    },

    /**
     * Create a skeleton loader element
     * @param {string} type - Type: 'text', 'avatar', 'card', 'thumbnail'
     * @param {string} size - For text: 'short', 'medium', 'long'
     * @returns {HTMLElement} - The skeleton element
     */
    createSkeleton: function(type = 'text', size = 'medium') {
        const skeleton = document.createElement('div');
        skeleton.className = 'skeleton';

        switch (type) {
            case 'text':
                skeleton.classList.add('skeleton-text', size);
                break;
            case 'avatar':
                skeleton.classList.add('skeleton-avatar');
                break;
            case 'card':
                skeleton.classList.add('skeleton-card');
                break;
            case 'thumbnail':
                skeleton.classList.add('skeleton-thumbnail');
                break;
        }

        return skeleton;
    },

    /**
     * Initialize lazy loading for images
     */
    initLazyLoading: function() {
        const images = document.querySelectorAll('img[data-src]');
        
        if ('IntersectionObserver' in window) {
            const imageObserver = new IntersectionObserver((entries, observer) => {
                entries.forEach(entry => {
                    if (entry.isIntersecting) {
                        const img = entry.target;
                        this.loadImage(img);
                        observer.unobserve(img);
                    }
                });
            }, {
                rootMargin: '50px 0px'
            });

            images.forEach(img => {
                img.classList.add('lazy-image');
                imageObserver.observe(img);
            });
        } else {
            // Fallback for older browsers
            images.forEach(img => this.loadImage(img));
        }
    },

    /**
     * Load a lazy image
     * @param {HTMLImageElement} img - The image element
     */
    loadImage: function(img) {
        const src = img.getAttribute('data-src');
        if (src) {
            img.src = src;
            img.removeAttribute('data-src');
            img.addEventListener('load', () => {
                img.classList.add('loaded');
            });
        }
    },

    /**
     * Create a progress bar
     * @param {HTMLElement} container - The container element
     * @param {boolean} indeterminate - Whether the progress is indeterminate
     * @returns {Object} - Object with update and remove methods
     */
    createProgressBar: function(container, indeterminate = false) {
        const progressContainer = document.createElement('div');
        progressContainer.className = 'progress-bar-container';
        
        const progressBar = document.createElement('div');
        progressBar.className = 'progress-bar';
        if (indeterminate) {
            progressBar.classList.add('indeterminate');
        } else {
            progressBar.style.width = '0%';
        }
        
        progressContainer.appendChild(progressBar);
        container.appendChild(progressContainer);

        return {
            update: function(percent) {
                progressBar.classList.remove('indeterminate');
                progressBar.style.width = `${Math.min(100, Math.max(0, percent))}%`;
            },
            remove: function() {
                progressContainer.remove();
            }
        };
    },

    /**
     * Wrap an async function with loading overlay
     * @param {Function} asyncFn - The async function to wrap
     * @param {string} message - Loading message
     * @returns {Promise} - The result of the async function
     */
    withLoading: async function(asyncFn, message = 'Đang xử lý...') {
        this.showOverlay(message);
        try {
            return await asyncFn();
        } catch (error) {
            // Show error toast to user
            this.error(error.message || 'Đã xảy ra lỗi. Vui lòng thử lại.');
            throw error;
        } finally {
            this.hideOverlay();
        }
    },

    /**
     * Make a form submit with loading state
     * @param {HTMLFormElement} form - The form element
     * @param {string} message - Loading message
     */
    submitWithLoading: function(form, message = 'Đang gửi...') {
        const submitBtn = form.querySelector('[type="submit"]');
        if (submitBtn) {
            this.setButtonLoading(submitBtn, true);
        }
        this.showOverlay(message);
    }
};

// Initialize on DOM ready
document.addEventListener('DOMContentLoaded', () => {
    LoadingUtils.init();
});

// Make available globally
window.LoadingUtils = LoadingUtils;
