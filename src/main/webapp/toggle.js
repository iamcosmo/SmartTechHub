const loginForm = document.getElementById('loginForm');
    const signupForm = document.getElementById('signupForm');
    const loginLink = document.getElementById('loginLink');
    const signupLink = document.getElementById('signupLink');

    loginLink.addEventListener('click', () => {
        loginForm.style.display = 'block';
        signupForm.style.display = 'none';
    });

    signupLink.addEventListener('click', () => {
        loginForm.style.display = 'none';
        signupForm.style.display = 'block';
    });
    
    