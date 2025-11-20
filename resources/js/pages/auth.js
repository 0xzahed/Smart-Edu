document.addEventListener('DOMContentLoaded', () => {
  // Login form validation
  const loginForm = document.getElementById('loginForm');
  if (loginForm) {
    const emailInput = document.getElementById('emailInput');
    const passwordInput = document.getElementById('passwordInput');
    const roleInput = document.getElementById('roleInput');

    // role tab switching
    document.querySelectorAll('.role-tab').forEach((tab) => {
      tab.addEventListener('click', () => {
        document.querySelectorAll('.role-tab').forEach(t => t.classList.remove('active'));
        tab.classList.add('active');
        roleInput.value = tab.dataset.role;
      });
    });

    loginForm.addEventListener('submit', (e) => {
      let hasError = false;

      // domain-enforced email
      const email = emailInput.value.trim();
      const validDomain = /@diu\.edu\.bd$/i.test(email);
      if (!validDomain) {
        hasError = true;
        document.getElementById('emailError')?.classList.remove('hidden');
        emailInput.classList.add('ring-2', 'ring-red-400');
      } else {
        document.getElementById('emailError')?.classList.add('hidden');
        emailInput.classList.remove('ring-2', 'ring-red-400');
      }

      if (!passwordInput.value) {
        hasError = true;
        document.getElementById('passwordError')?.classList.remove('hidden');
      } else {
        document.getElementById('passwordError')?.classList.add('hidden');
      }

      if (hasError) e.preventDefault();
    });
  }

  // Registration form validation
  const regForm = document.getElementById('registrationForm');
  if (regForm) {
    // This is handled by the detailed registration functionality below
    // Keeping this minimal to avoid conflicts
  }
});

// Authentication page functionality - Login & Registration
document.addEventListener('DOMContentLoaded', function() {
    
    // Check if we're on login or registration page
    const isLoginPage = document.getElementById('loginForm') !== null;
    const isRegistrationPage = document.getElementById('registrationForm') !== null;
    
    // ===========================================
    // LOGIN PAGE FUNCTIONALITY
    // ===========================================
    if (isLoginPage) {
        // Role selection functionality
        const roleButtons = document.querySelectorAll('.role-tab');
        const loginForm = document.getElementById('loginForm');
        const emailInput = document.getElementById('emailInput');
        const passwordInput = document.getElementById('passwordInput');
        const loginButton = document.getElementById('loginButton');
        const roleInput = document.getElementById('roleInput');
        
        let selectedRole = 'student'; // Default role
        
        // Role selection handler
        roleButtons.forEach(button => {
            button.addEventListener('click', function() {
                // Remove active class from all buttons
                roleButtons.forEach(btn => {
                    btn.classList.remove('active');
                });
                
                // Add active class to clicked button
                this.classList.add('active');
                
                // Update selected role
                selectedRole = this.getAttribute('data-role');
                roleInput.value = selectedRole;
            });
        });
        
        // Form validation
        function validateLoginForm() {
            const email = emailInput.value.trim();
            const password = passwordInput.value.trim();
            
            // Email validation
            if (!email) {
                showError('Please enter your email');
                return false;
            }
            
            if (!email.includes('@diu.edu.bd')) {
                showError('Please use your @diu.edu.bd email address');
                return false;
            }
            
            // Password validation
            if (!password) {
                showError('Please enter your password');
                return false;
            }
            
            if (password.length < 6) {
                showError('Password must be at least 6 characters long');
                return false;
            }
            
            return true;
        }
        
        // Form submit handler
        loginForm.addEventListener('submit', function(e) {
            e.preventDefault();
            
            if (!validateLoginForm()) {
                return;
            }
            
            // Show loading state
            loginButton.disabled = true;
            loginButton.innerHTML = '<i class="fas fa-spinner fa-spin mr-2"></i>Signing In...';
            
            // Add selected role to form data
            const roleInput = document.createElement('input');
            roleInput.type = 'hidden';
            roleInput.name = 'role';
            roleInput.value = selectedRole;
            
            // Remove existing role input if any
            const existingRoleInput = this.querySelector('input[name="role"]');
            if (existingRoleInput && existingRoleInput !== document.getElementById('roleInput')) {
                existingRoleInput.remove();
            }
            
            // Make sure roleInput has the right value
            const mainRoleInput = document.getElementById('roleInput');
            if (mainRoleInput) {
                mainRoleInput.value = selectedRole;
            } else {
                this.appendChild(roleInput);
            }
            
            // Submit the form
            this.submit();
        });
        
        // Input focus effects
        [emailInput, passwordInput].forEach(input => {
            input.addEventListener('focus', function() {
                this.parentElement.classList.add('ring-2', 'ring-white/30');
            });
            
            input.addEventListener('blur', function() {
                this.parentElement.classList.remove('ring-2', 'ring-white/30');
            });
        });
        
        // OAuth button handlers
        const googleLogin = document.getElementById('googleLogin');
        const githubLogin = document.getElementById('githubLogin');
        
        if (googleLogin) {
            googleLogin.addEventListener('click', function(e) {
                e.preventDefault();
                window.location.href = `/auth/google?role=${selectedRole}`;
            });
        }
        
        if (githubLogin) {
            githubLogin.addEventListener('click', function(e) {
                e.preventDefault();
                window.location.href = `/auth/github?role=${selectedRole}`;
            });
        }
        
        // Forgot password handler
        document.getElementById('forgotPasswordLink')?.addEventListener('click', function(e) {
            e.preventDefault();
            showInfo('Forgot password functionality will be implemented soon!');
        });
        
        // Register link handler
        const registerLink = document.getElementById('registerLink');
        if (registerLink) {
            registerLink.addEventListener('click', function(e) {
                e.preventDefault();
                window.location.href = '/register';
            });
        }
    }
    
    // ===========================================
    // REGISTRATION PAGE FUNCTIONALITY
    // ===========================================
    // Registration functionality is handled by registration.js
    // This section is intentionally left minimal to avoid conflicts
    
    // ===========================================
    // SHARED FUNCTIONS
    // ===========================================
    
    // Remove inline function - use global system instead
    // function showError(message) { ... } - REMOVED
    
    // Message display function for registration
    function showMessage(message, type) {
        // Remove existing messages
        const existingMessages = document.querySelectorAll('.dynamic-message');
        existingMessages.forEach(msg => msg.remove());
        
        const messageDiv = document.createElement('div');
        messageDiv.className = `dynamic-message mb-6 p-4 rounded-lg border ${
            type === 'error' 
                ? 'bg-red-50 border-red-200 text-red-800' 
                : 'bg-green-50 border-green-200 text-green-800'
        }`;
        
        messageDiv.innerHTML = `
            <div class="flex">
                <i class="fas ${type === 'error' ? 'fa-exclamation-circle text-red-500' : 'fa-check-circle text-green-500'} mr-3 mt-0.5"></i>
                <div>
                    <h3 class="font-semibold">${type === 'error' ? 'Registration Failed' : 'Success'}</h3>
                    <div class="mt-2 text-sm">${message}</div>
                </div>
            </div>
        `;
        
        // Insert at the top of the form container
        const formContainer = document.querySelector('.glass-effect');
        if (formContainer) {
            formContainer.insertBefore(messageDiv, formContainer.firstChild);
        }
        
        // Auto-remove after 10 seconds
        setTimeout(() => {
            messageDiv.remove();
        }, 10000);
    }
});

// Global functions
window.authPageFunctions = {
    showError: function(message) {
        console.error('Auth Error:', message);
    },
    showMessage: function(message, type) {
        console.log(`Auth ${type}:`, message);
    }
};

// Google OAuth function
window.loginWithGoogle = function(role) {
    // Show loading state
    const buttons = document.querySelectorAll('button[onclick*="loginWithGoogle"]');
    buttons.forEach(btn => {
        btn.disabled = true;
        btn.classList.add('opacity-50', 'cursor-not-allowed');
        
        // Add loading text
        const span = btn.querySelector('span');
        if (span) {
            span.innerHTML = `<i class="fas fa-spinner fa-spin mr-2"></i>Redirecting...`;
        }
    });
    
    // Redirect to Google OAuth with role parameter
    window.location.href = `/auth/google/${role}`;
};
